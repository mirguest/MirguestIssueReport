
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

    // first commit
    std::cout << "First Commit" << std::endl;
    for (int i = 0; i < 5; ++i) {
        std::cout << SA.read("/Event/Sim/SimHeader") << std::endl;
    }
    SA.commit();
    // second commit
    std::cout << "Second Commit" << std::endl;
    for (int i = 0; i < 5; ++i) {
        std::cout << SA.read("/Event/Sim/SimHeader") << std::endl;
    }
    SA.commit();
}

void test_staging_add_new()
{
    Repo repo;
    StagingArea SA(&repo);

    // first commit
    std::cout << "First Commit" << std::endl;
    for (int i = 0; i < 5; ++i) {
        std::cout << SA.read("/Event/Sim/SimHeader") << std::endl;
    }
    SA.commit();
    // second commit
    std::cout << "Second Commit With another object" << std::endl;
    for (int i = 0; i < 5; ++i) {
        std::cout << SA.read("/Event/Sim/SimHeader") << std::endl;
        std::cout << SA.read("/Event/Sim/ElecHeader") << std::endl;
    }
    SA.commit();
    std::cout << "Third Commit With another object" << std::endl;
    for (int i = 0; i < 5; ++i) {
        std::cout << SA.read("/Event/Sim/SimHeader") << std::endl;
        std::cout << SA.read("/Event/Sim/ElecHeader") << std::endl;
    }
    SA.commit();

}

void test_staging_async() {
    Repo repo;
    StagingArea SA(&repo);

    for (int i = 0; i < 10; ++i) {
        SA.commit();
        if (i % 2 == 0) {
            std::cout << "Loading DetSim Header: " 
                      << SA.read("/Event/Sim/SimHeader")
                      << std::endl;
        }
        std::cout << "Loading ElecSim Header: "
                  << SA.read("/Event/Sim/ElecHeader")
                  << std::endl;
    }
    SA.commit();
}

int main() {
    test_snapshot();
    test_repo();
    test_staging();
    test_staging_add_new();
    test_staging_async();
}
