from subprocess import Popen, PIPE
import select
import time

running_procs = [
    Popen(['python', 'produce.py'], stdout=PIPE)
    for i in range(2)
    ]

def handle_results(stream):
    try:
        print stream.readline()
    except:
        print "Nothing to read"

while running_procs:
    for proc in running_procs:
        retcode = proc.poll()
        if retcode is not None: # Process finished.
            running_procs.remove(proc)

            # Here, `proc` has finished with return code `retcode`
            print "Return Code: ", retcode
            if retcode != 0:
                """Error handling."""
                pass
            handle_results(proc.stdout)
            break
        else:
            #print "Try to use select"
            if select.select([proc.stdout],[],[],1)[0]:
                print "Begin to use select"
                handle_results(proc.stdout)

    else: # No process is done, wait a bit and check again.
        time.sleep(1)
        #print "Sleeping"
        continue

