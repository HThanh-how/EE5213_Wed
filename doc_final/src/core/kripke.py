from dataclasses import dataclass
from typing import Dict, Set, Any

@dataclass
class KripkeStructure:
    states: Set[str]
    initial_states: Set[str]
    transitions: Dict[str, Set[str]]
    labels: Dict[str, Set[str]]

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "KripkeStructure":
        states = set(data.get("states", []))
        initial_states = set(data.get("initial_states", []))
        transitions = {k: set(v) for k, v in data.get("transitions", {}).items()}
        labels = {k: set(v) for k, v in data.get("labels", {}).items()}
        
        # Validation: Ensure total relation
        for s in states:
            if s not in transitions or not transitions[s]:
                # Self-loop to make it total relation if terminal
                transitions[s] = {s}
                
        return cls(states=states, initial_states=initial_states, transitions=transitions, labels=labels)
