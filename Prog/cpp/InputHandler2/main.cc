
#include "InputHandler.h"
#include "TestStream/NormalTest1Stream.h"
#include "TestStream/NormalTest1EvtObj.h"

#include <iostream>
#include <string>

int main() {
    InputHandler hinput;

    hinput.attachStream("K40", new NormalTest1Stream);

    hinput.attach("K40", "K40.root");

    IStream* k40input = hinput.get("K40");

    std::string dummypath("");

    for (int i = 0; i < 100; ++i) {
        k40input->next();
        NormalTest1EvtObj* evt = dynamic_cast<NormalTest1EvtObj*>(k40input->get(dummypath));

        std::cout << evt->evtID() << std::endl;
    }

    std::cout << "FINALIZE" << std::endl;
    return 0;
}
