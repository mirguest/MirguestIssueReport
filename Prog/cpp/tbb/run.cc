#include <iostream>
#include <list>
#include <tbb/task.h>
#include <tbb/task_scheduler_init.h>
#include <tbb/atomic.h>

// g++ run.cc -I$TBBROOT/include -L$TBBROOT/lib -ltbb

// counter for total events.
tbb::atomic<int> its_done = 0;
int total_evtmax = 50;

int eventid() {
    return its_done.fetch_and_add(1);
}
bool doNext(int evtid) {
    return evtid < total_evtmax;
}

// child
class TbbTask: public tbb::task
{
public:
    tbb::task* execute() {
	std::cout << "TbbTask::execute. " << std::endl;
        return NULL;
    }

    bool busy() { return m_busy; }

protected:
    bool m_busy;
};

class IOTbbTask: public TbbTask
{
    tbb::task* execute() {
        std::cout << "IOTbbTask::execute. " << std::endl;
        return NULL;
    }
};

// for iotask, we use only one.
IOTbbTask* global_iotask = 0;

class WorkerTbbTask: public TbbTask
{
    tbb::task* execute() {
        std::cout << "WorkerTbbTask::execute. " << std::endl;

	// then, we need to recycle.
	tbb::task* next = NULL;
	int evtid = eventid();
	if (doNext(evtid)) {
            recycle_as_continuation();
	    next = this;
	}

        // sometimes, we need to call io task.
        if (evtid==10) {
	    std::cout << "global_iotask: " << global_iotask << std::endl;
	    tbb::task::enqueue(*global_iotask, tbb::priority_high);
	}
        return next;
    }
};

// supervisor, root of children
class TaskSupervisor: public tbb::task
{
public:
    TaskSupervisor() {
        m_stat = false;
    }

    tbb::task* execute() {
        if (m_stat) {
	    std::cout << "TaskSupervisor::execute continuation" << std::endl;
	} else {
	    std::cout << "TaskSupervisor::execute spaw children" << std::endl;
	    int n = m_children.size();

	    recycle_as_safe_continuation();
	    m_stat = true;

	    set_ref_count(n+1);
	    for ( auto c : m_children ) spawn(*c);

	    m_children.clear();

	}
        return NULL;
    }

    // construct some tasks for test
    // We construct 4 tasks at first, then recycle these tasks.
    // At the same time, we insert some I/O tasks into the queue.
    void init() {
        for (int i = 0; i < 4; ++i) {
	    TbbTask* child = new (allocate_child()) WorkerTbbTask();
	    m_children.push_back(child);
        }
    }

private:
    std::list<TbbTask*> m_children;
    bool m_stat;
};


int main() {
    int nthreads = 4;
    tbb::task_scheduler_init scheduler_init(nthreads);

    global_iotask = new (tbb::task::allocate_root()) IOTbbTask();

    TaskSupervisor* supervisor = new(tbb::task::allocate_root()) TaskSupervisor();
    supervisor->init();

    tbb::task::spawn_root_and_wait(*supervisor);
}
