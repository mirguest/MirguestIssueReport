#ifndef DBTest_h
#define DBTest_h

#include "SniperKernel/AlgBase.h"
class DBTest: public AlgBase {
public:
    DBTest(const std::string& name);

    bool initialize();
    bool execute();
    bool finalize();
};

#endif
