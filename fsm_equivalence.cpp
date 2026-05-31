#include <iostream>
#include <vector>
#include <set>
#include <map>
#include <queue>
#include <algorithm>
#include <string>

// Represents a state in the product machine: (v1, v2)
struct StatePair {
    int v1;
    int v2;

    bool operator<(const StatePair& other) const {
        if (v1 != other.v1) return v1 < other.v1;
        return v2 < other.v2;
    }

    bool operator==(const StatePair& other) const {
        return v1 == other.v1 && v2 == other.v2;
    }
};

// Transition function for M1 (T-FF)
int trans_M1(int v1, int a) {
    return v1 ^ a; // Toggles on a=1, holds on a=0
}

// Transition function for M2 (T-FF)
int trans_M2(int v2, int a) {
    return v2 ^ a; // Toggles on a=1, holds on a=0
}

// Transition function for M2' (Reset on a=0, Hold on a=1)
int trans_M2_prime(int v2, int a) {
    return (a == 0) ? 0 : v2; // Resets on a=0, holds on a=1
}

// Outputs (state is output)
int out_M1(int v1) { return v1; }
int out_M2(int v2) { return v2; }
int out_M2_prime(int v2) { return v2; }

// Perform Equivalence Checking on two FSMs
void check_equivalence(
    int (*trans1)(int, int),
    int (*trans2)(int, int),
    int (*out1)(int),
    int (*out2)(int),
    int init1,
    int init2,
    const std::string& fsm1_name,
    const std::string& fsm2_name
) {
    std::cout << "========================================\n";
    std::cout << "Checking Equivalence: " << fsm1_name << " vs " << fsm2_name << "\n";
    std::cout << "========================================\n";

    StatePair init_state = {init1, init2};
    std::set<StatePair> ARS = {init_state}; // All Reached States
    std::set<StatePair> NNS = {init_state}; // New Next States (Frontier)

    // Store the shortest input path to each state for counterexample generation
    std::map<StatePair, std::vector<int>> path;
    path[init_state] = {};

    int iteration = 1;
    bool equivalent = true;
    StatePair witness = {-1, -1};

    // Output check on initial state
    if (out1(init_state.v1) != out2(init_state.v2)) {
        equivalent = false;
        witness = init_state;
    }

    std::cout << "--- Initialization ---\n";
    std::cout << "ARS = { (" << init_state.v1 << "," << init_state.v2 << ") }\n";
    std::cout << "NNS = { (" << init_state.v1 << "," << init_state.v2 << ") }\n";

    while (equivalent && !NNS.empty()) {
        std::cout << "\n--- Iteration " << iteration++ << " ---\n";
        std::set<StatePair> NS; // Next States

        // For each state in the frontier
        for (const auto& s : NNS) {
            std::cout << "From state (" << s.v1 << "," << s.v2 << "):\n";
            // Check under all possible inputs (a = 0 and a = 1)
            for (int a = 0; a <= 1; ++a) {
                int next_v1 = trans1(s.v1, a);
                int next_v2 = trans2(s.v2, a);
                StatePair next_state = {next_v1, next_v2};
                
                std::cout << "  Input a=" << a << " -> (" << next_v1 << "," << next_v2 << ")";
                
                // If it's a newly discovered state
                if (ARS.find(next_state) == ARS.end()) {
                    NS.insert(next_state);
                    // Record path
                    std::vector<int> p = path[s];
                    p.push_back(a);
                    path[next_state] = p;
                    std::cout << " [NEW]";
                }
                std::cout << "\n";
            }
        }

        // Print NS
        std::cout << "NS = { ";
        for (const auto& s : NS) {
            std::cout << "(" << s.v1 << "," << s.v2 << ") ";
        }
        std::cout << "}\n";

        // Compute new frontier NNS = NS - ARS
        std::set<StatePair> new_NNS = NS;
        NNS = new_NNS;

        // Print NNS
        std::cout << "NNS = { ";
        for (const auto& s : NNS) {
            std::cout << "(" << s.v1 << "," << s.v2 << ") ";
        }
        std::cout << "}\n";

        if (NNS.empty()) {
            std::cout << "NNS is empty. Terminating Reachability.\n";
            break;
        }

        // Update ARS and check outputs for new states
        for (const auto& s : NNS) {
            ARS.insert(s);
            // Check if outputs differ
            if (out1(s.v1) != out2(s.v2)) {
                equivalent = false;
                witness = s;
                break;
            }
        }

        // Print ARS
        std::cout << "ARS = { ";
        for (const auto& s : ARS) {
            std::cout << "(" << s.v1 << "," << s.v2 << ") ";
        }
        std::cout << "}\n";

        if (!equivalent) {
            std::cout << "\nOutput mismatch detected in state (" << witness.v1 << "," << witness.v2 << ")!\n";
            break;
        }
    }

    std::cout << "\n--- Verification Results ---\n";
    std::cout << "All Reached States (ARS): { ";
    for (const auto& s : ARS) {
        std::cout << "(" << s.v1 << "," << s.v2 << ") ";
    }
    std::cout << "}\n";

    if (equivalent) {
        std::cout << "Result: FSM " << fsm1_name << " and " << fsm2_name << " are EQUIVALENT.\n";
    } else {
        std::cout << "Result: FSM " << fsm1_name << " and " << fsm2_name << " are NOT EQUIVALENT.\n";
        std::cout << "Difference found at state: (" << witness.v1 << "," << witness.v2 << ")\n";
        std::cout << "Counterexample input sequence: ";
        const auto& ce = path[witness];
        if (ce.empty()) {
            std::cout << "(initial states differ)";
        } else {
            for (size_t i = 0; i < ce.size(); ++i) {
                std::cout << "a=" << ce[i] << (i + 1 < ce.size() ? ", " : "");
            }
        }
        std::cout << "\n";
    }
    std::cout << "========================================\n\n";
}

int main() {
    // Case 1: M1 vs M2 (both T-FF, starting at 0, 0)
    check_equivalence(trans_M1, trans_M2, out_M1, out_M2, 0, 0, "M1", "M2");

    // Case 2: M1 vs M2' (T-FF vs Reset/Hold, starting at 0, 0)
    check_equivalence(trans_M1, trans_M2_prime, out_M1, out_M2_prime, 0, 0, "M1", "M2'");

    return 0;
}
