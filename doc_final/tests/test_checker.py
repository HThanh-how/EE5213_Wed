import pytest
import sys
from pathlib import Path

# Add src to path for testing
sys.path.append(str(Path(__file__).parent.parent / "src"))

from core.kripke import KripkeStructure
from core.checker import CTLChecker

@pytest.fixture
def sample_model():
    data = {
      "states": ["s0", "s1"],
      "initial_states": ["s0"],
      "transitions": {
        "s0": ["s1"],
        "s1": ["s0"]
      },
      "labels": {
        "s0": ["p"],
        "s1": ["q"]
      }
    }
    return KripkeStructure.from_dict(data)

def test_ex(sample_model):
    checker = CTLChecker(sample_model)
    # from s0, EX(q) is true because s1 has q
    assert checker.check(["EX", "q"]) == True

def test_ag(sample_model):
    checker = CTLChecker(sample_model)
    # AG(p) is false because s1 does not have p
    assert checker.check(["AG", "p"]) == False

def test_ef(sample_model):
    checker = CTLChecker(sample_model)
    # EF(q) is true
    assert checker.check(["EF", "q"]) == True
