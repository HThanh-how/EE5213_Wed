def print_set(name, s):
    states = " ".join([f"S{val}" for val in sorted(s)])
    print(f"{name} = {{ {states} }}")

def reachability(R, I):
    ARS = set(I)  # All Reached States
    NNS = set(I)  # New Next States (Frontier Set)
    iteration = 1

    print("--- Initialization ---")
    print_set("ARS", ARS)
    print_set("NNS", NNS)

    while True:
        print(f"\n--- Iteration {iteration} ---")
        iteration += 1
        
        NS = set()
        for s in NNS:
            if s in R:
                NS.update(R[s])
                
        print_set("NS ", NS)

        new_NNS = NS - ARS
        NNS = new_NNS
        print_set("NNS", NNS)

        if not NNS:
            print("NNS is empty. Terminating.")
            break
            
        ARS.update(NNS)
        print_set("ARS", ARS)

    return ARS

if __name__ == "__main__":
    transition_relation = {
        0: {1, 5}, 1: {2}, 5: {5, 2},
        2: {3}, 3: {4}, 4: set()
    }
    initial_states = {0}
    
    print("Starting Reachability Analysis...\n")
    reachable_states = reachability(transition_relation, initial_states)

    states = " ".join([f"S{val}" for val in sorted(reachable_states)])
    print(f"\nFinal Reachable States (ARS): {{ {states} }}")
