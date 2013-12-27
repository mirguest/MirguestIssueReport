
#include <iostream>
#include "StagingArea.h"
#include "Snapshot.h"
#include "Repo.h"

void test_snapshot() {

    Snapshot ss;
    ss.add("/Event/Sim/SimHeader", 1);
    ss.add("/Event/Sim/ElecHeader", 1);
    ss.commit();

    std::cout << ss.get("/Event/Sim/SimHeader") << std::endl;

}

void test_repo() {
    Repo repo;

    std::cout << repo.get_latest("/Event/Sim/SimHeader") << std::endl;
}

void test_staging()
{
    Repo repo;
    StagingArea SA(&repo);

    SA.read("/Event/Sim/SimHeader");
}

int main() {
    test_snapshot();
    test_repo();
    test_staging();
}
