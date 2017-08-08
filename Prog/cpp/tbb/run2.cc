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
            return next;
	}
    private:
        int tid;
    };

    class BTask: public tbb::task {
    public:
    };

    class TaskSupervisor: public tbb::task {
    public:
	TaskSupervisor() {
	    tid = -1;
	    for (int i = 0; i < m_nthreads; ++i) {
		tbb::task* child = new (allocate_child()) ATask(i);
		m_children.push_back(child);
	    }
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
};

int TestCase::m_nthreads = 4;
int TestCase::m_evtmax = 100;
tbb::atomic<int> TestCase::m_cur_evtid = 0;


int main() {
    TestCase tc;
    tc.run();
}
