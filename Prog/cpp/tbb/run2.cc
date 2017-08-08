#include <iostream>
#include <list>
#include <tbb/task.h>
#include <tbb/task_scheduler_init.h>
#include <tbb/atomic.h>

#define LOG(x) do { std::cout << "[tid:" << tid << "] " << __func__ << " " << x << std::endl; } while(0)

class TestCase {
public:
    bool run() {
	tbb::task_scheduler_init scheduler_init(m_nthreads);

	m_iotask = new(tbb::task::allocate_root()) BTask();
	TaskSupervisor* supervisor = new(tbb::task::allocate_root()) TaskSupervisor();

	tbb::task::spawn_root_and_wait(*supervisor);
        return true;
    }

    class ATask: public tbb::task {
    public:
	ATask(int i): tid(i) {
	}

	tbb::task* execute() {
	    tbb::task* next = NULL;

	    int evtid = m_cur_evtid.fetch_and_add(1);
	    if (evtid < m_evtmax) {
	        LOG("ATask::execute");

		recycle_as_continuation();
		next = this;
	    } else {
                LOG("stop");
	    }

            // if iotask flag is zero, we try to invoke it.
            // otherwise, it is running yet.
            if (m_iotask && m_iotask_flag.compare_and_swap(1, 0)) {
                LOG("iotask flag: 0->1");
		dynamic_cast<BTask*>(m_iotask)->set_next_task(next);
		next = m_iotask;
            }

            return next;
	}
    private:
        int tid;
    };

    class BTask: public tbb::task {
    public:
	BTask() {
            tid = 999;
	    cnt_data_to_be_read = 3;

	    next_task = 0;
	}

	tbb::task* execute() {
            LOG("BTask::execute cnt_data_to_be_read:" << cnt_data_to_be_read);
	    cnt_data_to_be_read -= 1;

	    // make it recycle, so it could be used later.
	    // but the next time, we are invoke it by ATask.
            if (cnt_data_to_be_read != 0) {
                recycle_as_continuation();
	    } else {
                LOG("stop recycle_as_continuation");

		m_iotask = 0;
		LOG("reset iotask=0");
		// return NULL;
	    }

	    tbb::task* next = NULL;

	    if (next_task) {
                next = next_task;
	    	next_task = 0;
	    }

	    // done: reset the flag
	    while(m_iotask_flag.compare_and_swap(0, 1)) {
	    }
	    LOG("reset iotaskflag.");
	    return next;
	}

	void set_next_task(tbb::task* t) {
            next_task = t;
        }

    private:
        int tid;

	int cnt_data_to_be_read;

	tbb::task* next_task;
    };

    class TaskSupervisor: public tbb::task {
    public:
	TaskSupervisor() {
	    tid = -1;
	    for (int i = 0; i < m_nthreads; ++i) {
		tbb::task* child = new (allocate_child()) ATask(i);
		m_children.push_back(child);
	    }

 	    // // insert task B
	    // tbb::task* tb = new (allocate_child()) BTask();
	    // m_children.push_back(tb);
        }
    
	tbb::task* execute() {
	    if (m_children.size()) {
	        recycle_as_safe_continuation();
		set_ref_count(m_children.size() + 1);
  	        for ( auto c: m_children ) spawn(*c);
		m_children.clear();
	    } else {
                LOG("END.");
	    }
            return NULL;
	}
    private:
	std::list<tbb::task*> m_children;
	int tid;
    };

protected:
    static int m_nthreads;
    static int m_evtmax;
    static tbb::atomic<int> m_cur_evtid;

    static tbb::task* m_iotask;
    static tbb::atomic<int> m_iotask_flag;
};

int TestCase::m_nthreads = 4;
int TestCase::m_evtmax = 10;
tbb::atomic<int> TestCase::m_cur_evtid = 0;
tbb::task* TestCase::m_iotask = 0;
tbb::atomic<int> TestCase::m_iotask_flag = 0;

int main() {
    TestCase tc;
    tc.run();
}
