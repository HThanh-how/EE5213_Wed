from typing import List, Set, Union, Any
from .kripke import KripkeStructure

class CTLChecker:
    def __init__(self, model: KripkeStructure):
        self.model = model

    def check(self, formula: Union[str, List[Any]]) -> bool:
        sat_states = self.sat(formula)
        return self.model.initial_states.issubset(sat_states)

    def sat(self, phi: Union[str, List[Any]]) -> Set[str]:
        if isinstance(phi, str):
            if phi.lower() == "true":
                return set(self.model.states)
            elif phi.lower() == "false":
                return set()
            else:
                return {s for s, labels in self.model.labels.items() if phi in labels}
        
        if not isinstance(phi, list) or len(phi) == 0:
            raise ValueError(f"Invalid formula format: {phi}")

        op = phi[0].upper()

        if op == "NOT":
            return set(self.model.states) - self.sat(phi[1])
        elif op == "AND":
            return self.sat(phi[1]) & self.sat(phi[2])
        elif op == "OR":
            return self.sat(phi[1]) | self.sat(phi[2])
        elif op == "IMPLIES": # phi -> psi  === NOT phi OR psi
            return (set(self.model.states) - self.sat(phi[1])) | self.sat(phi[2])
        elif op == "EX":
            sat_phi = self.sat(phi[1])
            return {s for s in self.model.states if any(t in sat_phi for t in self.model.transitions.get(s, set()))}
        elif op == "EU":
            sat_phi = self.sat(phi[1])
            sat_psi = self.sat(phi[2])
            W = sat_psi.copy()
            while True:
                W_new = W | {s for s in sat_phi if any(t in W for t in self.model.transitions.get(s, set()))}
                if W == W_new:
                    break
                W = W_new
            return W
        elif op == "EG":
            sat_phi = self.sat(phi[1])
            W = sat_phi.copy()
            while True:
                W_new = W & {s for s in W if any(t in W for t in self.model.transitions.get(s, set()))}
                if W == W_new:
                    break
                W = W_new
            return W
        elif op == "EF":
            return self.sat(["EU", "true", phi[1]])
        elif op == "AX":
            return self.sat(["NOT", ["EX", ["NOT", phi[1]]]])
        elif op == "AG":
            return self.sat(["NOT", ["EF", ["NOT", phi[1]]]])
        elif op == "AF":
            return self.sat(["NOT", ["EG", ["NOT", phi[1]]]])
        elif op == "AU":
            phi1 = phi[1]
            psi1 = phi[2]
            return self.sat(
                ["AND",
                    ["NOT", ["EU", ["NOT", psi1], ["AND", ["NOT", phi1], ["NOT", psi1]]]],
                    ["NOT", ["EG", ["NOT", psi1]]]
                ]
            )
        else:
            raise ValueError(f"Unknown or unsupported operator: {op}")
