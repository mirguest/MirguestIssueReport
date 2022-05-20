#include "Param.h"
void run() {
    Param param;
    param.name = "job";
    // gROOT->ProcessLine(".L lib.C+");
    gROOT->LoadMacro("lib.C+");
    lib(param);

}
