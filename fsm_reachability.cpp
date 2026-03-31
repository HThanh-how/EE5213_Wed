#include <iostream>
#include <vector>
#include <set>
#include <map>
#include <algorithm>

// Define State as an integer for simplicity, but it can be any type
typedef int State;

// Function to compute the reachable states
// R: Next state function (Transition Relation), mapped as Current State -> Set of Next States
// I: Set of Initial States
std::set<State> Reachability(
    const std::map<State, std::set<State>>& R,
    const std::set<State>& I
) {
    // 1. ARS = NNS = I; 
    std::set<State> ARS = I;  // All Reached States
    std::set<State> NNS = I;  // New Next States (Frontier Set)

    // 2. Iterate the following computation:
    while (true) {
        std::set<State> NS; // Next States

        // 3. NS = R(all inputs, NNS);
        // Find all possible next states from the current frontier set
        for (State s : NNS) {
            if (R.find(s) != R.end()) {
                for (State next_s : R.at(s)) {
                    NS.insert(next_s);
                }
            }
        }

        // 4. NNS = NS - ARS; 
        // Find newly discovered states that haven't been reached before
        std::set<State> new_NNS;
        std::set_difference(
            NS.begin(), NS.end(),
            ARS.begin(), ARS.end(),
            std::inserter(new_NNS, new_NNS.begin())
        );
        NNS = new_NNS;

        // 5. if NNS = empty then print ARS and stop;
        if (NNS.empty()) {
            break;
        }

        // 6. ARS = ARS U NNS;
        ARS.insert(NNS.begin(), NNS.end());
    }

    return ARS;
}

int main() {
    // Example from the lecture (Explicit State Enumeration)
    // Let's create a transition relation based on a hypothetical graph
    // S0 -> {S1, S5}
    // S1 -> {S2}
    // S5 -> {S5, S2}
    // S2 -> {S3}
    // S3 -> {S4}
    // S4 -> {}
    
    std::map<State, std::set<State>> transition_relation = {
        {0, {1, 5}},
        {1, {2}},
        {5, {5, 2}},
        {2, {3}},
        {3, {4}},
        {4, {}}
    };

    std::set<State> initial_states = {0};

    std::cout << "Starting Reachability Analysis..." << std::endl;
    std::cout << "Initial States: { ";
    for (State s : initial_states) std::cout << "S" << s << " ";
    std::cout << "}\n" << std::endl;

    std::set<State> reachable_states = Reachability(transition_relation, initial_states);

    std::cout << "Final Reachable States (ARS): { ";
    for (State s : reachable_states) {
        std::cout << "S" << s << " ";
    }
    std::cout << "}\n";

    return 0;
}
