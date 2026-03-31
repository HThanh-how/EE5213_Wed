# ASIC Verification - Exercise 2 Report
**Student:** <STUDENT_NAME>  
**Student ID:** <STUDENT_ID>  

---

## 1. Exercise 2: FSM Reachability Analysis

### 1.1 Objective
Implement the State Reachability Analysis algorithm for an arbitrary Finite State Machine (FSM) using C++. The program computes the set of reachable states given a set of initial states and a transition relation.

### 1.2 Design Specifications
- **Input:** Set of initial states ($I$), and a transition relation ($R$) mapping current states to next possible states.
- **Output:** The complete set of reachable states ($ARS$ - All Reached States).
- **Algorithm Strategy:**
  - Track **All Reached States** (`ARS`) and **New Next States** (`NNS` or Frontier Set).
  - Iteratively compute the next states (`NS`) from the current frontier `NNS`.
  - Update the frontier as newly discovered states (`NNS = NS - ARS`).
  - Add the new frontier to the all reached states (`ARS = ARS U NNS`).
  - Terminate when the frontier is empty.

### 1.3 Implementation (`fsm_reachability.cpp`)
```cpp
#include <iostream>
#include <vector>
#include <set>
#include <map>
#include <algorithm>

// Define State as an integer for simplicity
typedef int State;

// Reachability Analysis Algorithm
std::set<State> Reachability(
    const std::map<State, std::set<State>>& R,
    const std::set<State>& I
) {
    std::set<State> ARS = I;  // All Reached States
    std::set<State> NNS = I;  // New Next States (Frontier Set)

    while (true) {
        std::set<State> NS; 

        // NS = R(all inputs, NNS);
        // Find all possible next states from the current frontier
        for (State s : NNS) {
            if (R.find(s) != R.end()) {
                for (State next_s : R.at(s)) {
                    NS.insert(next_s);
                }
            }
        }

        // NNS = NS - ARS; 
        std::set<State> new_NNS;
        std::set_difference(
            NS.begin(), NS.end(),
            ARS.begin(), ARS.end(),
            std::inserter(new_NNS, new_NNS.begin())
        );
        NNS = new_NNS;

        // if NNS is empty then break;
        if (NNS.empty()) {
            break;
        }

        // ARS = ARS U NNS;
        ARS.insert(NNS.begin(), NNS.end());
    }

    return ARS;
}

int main() {
    // Transition relation based on a hypothetical Explicit State graph
    std::map<State, std::set<State>> transition_relation = {
        {0, {1, 5}}, {1, {2}}, {5, {5, 2}},
        {2, {3}}, {3, {4}}, {4, {}}
    };

    std::set<State> initial_states = {0};

    std::cout << "Starting Reachability Analysis...\n";
    std::cout << "Initial States: { ";
    for (State s : initial_states) std::cout << "S" << s << " ";
    std::cout << "}\n\n";

    std::set<State> reachable_states = Reachability(transition_relation, initial_states);

    std::cout << "Final Reachable States (ARS): { ";
    for (State s : reachable_states) {
        std::cout << "S" << s << " ";
    }
    std::cout << "}\n";

    return 0;
}
```

### 1.4 Execution Results
Using the provided transition graph test case:
```text
Starting Reachability Analysis...
Initial States: { S0 }

Final Reachable States (ARS): { S0 S1 S2 S3 S4 S5 }
```
