#include "G4Threading.hh"
#include "Randomize.hh"
#include <iostream>
#include <cstdlib>
#include <unistd.h>
#define MESSAGE(x) std::cout << x << std::endl;

//Define a thread-function using G4 types
G4ThreadFunReturnType myfunc(  G4ThreadFunArgType val) {
  double value = *(double*)val;
  sleep(10*G4UniformRand());
  MESSAGE("value is:"<<value);
  return /*(G4ThreadFunReturnType)*/NULL;
}


//Example: spawn 10 threads that execute myfunc
int main(int argc,char* argv[]) {
  MESSAGE( "Starting program ");
  int nthreads = 10;
  if (argc>1) {
      nthreads = atoi(argv[1]);
  }
  G4Thread* tid = new G4Thread[nthreads];
  double *valss = new double[nthreads];

  for ( int idx = 0 ; idx < nthreads ; ++idx ) {
    valss[idx] = (double)idx;
    G4THREADCREATE(&(tid[idx]) , myfunc,&(valss[idx]) );
  }

  for ( int idx = 0 ; idx < nthreads ; ++idx ) {
    G4THREADJOIN( (tid[idx]) );
  }

  MESSAGE( "Program ended ");

  return 0;

}

