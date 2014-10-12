#ifndef NormalTest1EvtObj_h
#define NormalTest1EvtObj_h

#include "EventObject.h"

class NormalTest1EvtObj: public EventObject {
public:

    int evtID() {
        return m_evtID;
    }
    void setEvtID(int evtID) {
        m_evtID = evtID;
    }
private:
    int m_evtID;
};

#endif
