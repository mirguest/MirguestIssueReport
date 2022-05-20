#include <iostream>
#include <list>
#include <tbb/task.h>
#include <tbb/task_scheduler_init.h>
#include <tbb/atomic.h>
#include <tbb/concurrent_queue.h>

#define LOG(x) do { std::cout << "[tid:" << tid << "] " << __func__ << " " << x << std::endl; } while(0)

template<class T>
class Dispatcher {
public:
    void add(T item) { queue.push(item); }
    bool get(T& item) {
        return queue.try_pop(item);
    }

    void init_io(T item) { io_item = item; }
    void add_io() {
        // add an io task into the queue.
        if (io_queue.empty()) {
            io_queue.push(io_item);
	}
    }    
    bool get_io(T& item) {
        // io task
        if (!io_queue.empty()) {
            return io_queue.try_pop(item);
        }
	return false;
    }
private:
    T io_item;
    tbb::concurrent_queue<T> io_queue;
    tbb::concurrent_queue<T> queue;
    
};

class SNiPERTask {
public:

    SNiPERTask(int i) : tid(i) {}

    virtual bool run() {
        return true;
    }

    virtual bool execute() {
        LOG("SNiPERTask: I'am working now.");
        return true;
    }

protected:

    int tid;
};

class SNiPERIOTask: public SNiPERTask {
public:

    SNiPERIOTask() : SNiPERTask(8888) {}

    virtual bool run() {
        return true;
    }

    virtual bool execute() {
        LOG("SNiPERIOTask: I'am doing I/O now.");
        return true;
    }

private:

};


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

	    // io item
            SNiPERTask* io_item = NULL;
	    m_dispatcher.get_io(io_item);
	    if (io_item) {
                LOG("Get an IO task. Run IO task.");
		io_item->execute();
		recycle_as_continuation();
		next = this;
                return next;
	    }

            // get one item
            SNiPERTask* item = NULL;
            m_dispatcher.get(item);
	    if (!item) {
                LOG("Can't get item from dispatcher.");
		return NULL;
	    }

	    int evtid = m_cur_evtid.fetch_and_add(1);
	    if (evtid < m_evtmax) {
	        LOG("ATask::execute");

		item->execute();

		// 
		// put it back to dispatcher.
		m_dispatcher.add(item);

                // if necessary, add io task
                m_dispatcher.add_io();

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


    class TaskSupervisor: public tbb::task {
    public:
	TaskSupervisor() {
	    tid = -1;
	    for (int i = 0; i < m_nthreads; ++i) {
		tbb::task* child = new (allocate_child()) ATask(i);
		m_children.push_back(child);

		SNiPERTask* item = new SNiPERTask(i);
		m_dispatcher.add(item);
	    }

 	    // insert iotask
	    SNiPERIOTask* iotask = new SNiPERIOTask();
	    m_dispatcher.init_io(iotask);
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

    static Dispatcher<SNiPERTask*> m_dispatcher;
};

int TestCase::m_nthreads = 4;
int TestCase::m_evtmax = 10;
tbb::atomic<int> TestCase::m_cur_evtid = 0;
Dispatcher<SNiPERTask*> TestCase::m_dispatcher;

int main() {
    TestCase tc;
    tc.run();
}
