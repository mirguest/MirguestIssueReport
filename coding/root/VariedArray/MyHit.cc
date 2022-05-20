
#include "MyHit.h"

ClassImp(MyHit)

MyHit::MyHit() {
    pmtID = 0;
    hitTime = 0;
}

MyHit::MyHit(Int_t pmtid, Float_t hittime) {
    pmtID = pmtid;
    hitTime = hittime;
}
