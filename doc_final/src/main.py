import argparse
import json
import sys
import uuid
from pathlib import Path

# Add src to path to allow direct execution
sys.path.append(str(Path(__file__).parent))

from core.kripke import KripkeStructure
from core.checker import CTLChecker
from utils.logger import get_logger

logger = get_logger("CTL_CLI")

def parse_args():
    parser = argparse.ArgumentParser(description="Enterprise CTL Model Checker")
    parser.add_argument("--model", type=str, required=True, help="Path to JSON model file")
    parser.add_argument("--formulas", type=str, required=True, help="Path to JSON formulas file")
    return parser.parse_args()

def main():
    args = parse_args()
    trace_id = str(uuid.uuid4())
    logger.info("Initializing CTL Model Checker", extra={"trace_id": trace_id, "context": {"model": args.model, "formulas": args.formulas}})

    try:
        model_path = Path(args.model)
        formulas_path = Path(args.formulas)
        
        if not model_path.exists() or not formulas_path.exists():
            raise FileNotFoundError("Model or formulas file not found.")

        with open(model_path, "r", encoding="utf-8") as f:
            model_data = json.load(f)
            
        with open(formulas_path, "r", encoding="utf-8") as f:
            test_formulas = json.load(f)

        kripke_model = KripkeStructure.from_dict(model_data)
        checker = CTLChecker(kripke_model)

        results = []
        for test in test_formulas:
            formula = test["formula"]
            description = test.get("description", "No description")
            expected = test.get("expected")
            
            is_satisfied = checker.check(formula)
            match = (is_satisfied == expected) if expected is not None else None
            
            results.append({
                "description": description,
                "formula": formula,
                "result": is_satisfied,
                "expected": expected,
                "pass": match
            })

            logger.info("Checked Formula", extra={
                "trace_id": trace_id,
                "context": {
                    "description": description,
                    "is_satisfied": is_satisfied,
                    "pass": match
                }
            })

        passed = sum(1 for r in results if r["pass"])
        logger.info(f"Batch Checking Completed. Passed {passed}/{len(results)}", extra={"trace_id": trace_id, "context": {"total_tests": len(results)}})
        
        # Pretty print results
        print("\n=== FINAL RESULTS ===")
        for res in results:
            status = "PASS" if res["pass"] else "FAIL"
            print(f"[{status}] {res['description']}")
            print(f"    Formula: {res['formula']}")
            print(f"    Result: {res['result']} | Expected: {res['expected']}\n")

    except Exception as e:
        logger.error("Error during execution", exc_info=True, extra={"trace_id": trace_id})
        sys.exit(1)

if __name__ == "__main__":
    main()
