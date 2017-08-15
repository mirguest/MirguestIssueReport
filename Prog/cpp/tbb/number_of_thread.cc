/*
 * $ g++ -std=c++11 -o not number_of_thread.cc -I$TBBROOT/include -L$TBBROOT/lib -ltbb
 * $ ./not -n 40 --evtmax 100
 */

#include <iostream>
#include <list>
#include <cstdlib>
#include <cstring>
#include <pthread.h>
#include <tbb/task.h>
#include <tbb/task_scheduler_init.h>
#include <tbb/atomic.h>
#include <tbb/concurrent_queue.h>


#define LOG(x) do { std::cout << "[tid:" << tid << "]@{thread id " << pthread_self() << "} " << __func__ << " " << x << std::endl; } while(0)


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

    SNiPERTask(int i, int w) : tid(i), workload(w) {}

    virtual bool run() {
        for (int i = 0; i < 10000000; ++i) {
            for (int j = 0; j < 10000000; ++j) {
                int k = i+j;
		double kd = i*j;
            }
        }
        return true;
    }

    virtual bool execute() {
        LOG("SNiPERTask: I'am working now.");
        for (int i = 0; i < 1000*workload; ++i) {
            for (int j = 0; j < 1000*workload; ++j) {
                int k = i+j;
		double kd = i*j;
            }
        }

        return true;
    }

protected:

    int tid;
    int workload;
};


class TestCase {
public:
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

		SNiPERTask* item = new SNiPERTask(i, m_workload);
		m_dispatcher.add(item);
	    }

 	    // insert iotask
	    // SNiPERIOTask* iotask = new SNiPERIOTask();
	    // m_dispatcher.init_io(iotask);
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

public:
    TestCase(int argc, char* argv[]): tid(418) {
        for (int i = 1; i < argc; ++i) {
            if (strcmp(argv[i], "-n")==0) {
                if (++i<argc) { m_nthreads = atoi(argv[i]); }
                else { std::cerr << "missing value" << std::endl;}
            } else if (strcmp(argv[i], "--evtmax")==0) {
                if (++i<argc) { m_evtmax = atoi(argv[i]); }
                else { std::cerr << "missing value" << std::endl;}
            } else if (strcmp(argv[i], "--workload")==0) {
                if (++i<argc) { m_workload = atoi(argv[i]); }
                else { std::cerr << "missing value" << std::endl;}
            } else {
		std::cerr << "unknown option: " << argv[i] << std::endl;
            } 
        }
    }


    bool run() {
        LOG("Initialize number of threads: " << m_nthreads);
	tbb::task_scheduler_init scheduler_init(m_nthreads);

	TaskSupervisor* supervisor = new(tbb::task::allocate_root()) TaskSupervisor();

	tbb::task::spawn_root_and_wait(*supervisor);

        return true;
    }

private:
    int tid;
    static int m_workload;
    static int m_nthreads;
    static int m_evtmax;
    static tbb::atomic<int> m_cur_evtid;

    static Dispatcher<SNiPERTask*> m_dispatcher;

};

int TestCase::m_workload = 0; // 0 -> ... more heavy
int TestCase::m_nthreads = 1;
int TestCase::m_evtmax = 10;
tbb::atomic<int> TestCase::m_cur_evtid = 0;
Dispatcher<SNiPERTask*> TestCase::m_dispatcher;


int main(int argc, char* argv[]) {
    TestCase tc(argc, argv);
    tc.run();

}
