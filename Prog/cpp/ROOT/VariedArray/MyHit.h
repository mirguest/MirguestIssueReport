#ifndef MyHit_h
#define MyHit_h

#include "TObject.h"

class MyHit: public TObject {
public:
    MyHit(); 

    MyHit(Int_t pmtid, Float_t hittime);

    void SetPmtID(Int_t pmtid) {
        pmtID = pmtid;
    }

    void SetHitTime(Float_t hittime) {
        hitTime = hittime;
    }

private:
    Int_t pmtID;
    Float_t hitTime;
    
    ClassDef(MyHit, 1);
};

#endif
