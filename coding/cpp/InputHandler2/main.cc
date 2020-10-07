
#include "InputHandler.h"
#include "TestStream/NormalTest1Stream.h"
#include "TestStream/NormalTest1EvtObj.h"

#include <iostream>
#include <string>

int main() {
    InputHandler hinput;

    hinput.attachStream("K40", new NormalTest1Stream);
    hinput.attachStream("U", new NormalTest1Stream);

    hinput.attach("K40", "K40.root");
    hinput.attach("U", "U.root");

    IStream* k40input = hinput.get("K40");
    IStream* u238input = hinput.get("U");

    std::string dummypath("");

    for (int i = 0; i < 100; ++i) {
        k40input->next();
        if (i % 2) {
            u238input->next();
        }
        NormalTest1EvtObj* evt = dynamic_cast<NormalTest1EvtObj*>(k40input->get(dummypath));
        NormalTest1EvtObj* evt2 = dynamic_cast<NormalTest1EvtObj*>(u238input->get(dummypath));

        std::cout << evt->evtID() << std::endl;
        std::cout << evt2->evtID() << std::endl;

        delete evt;
        delete evt2;
    }

    std::cout << "FINALIZE" << std::endl;
    return 0;
}
