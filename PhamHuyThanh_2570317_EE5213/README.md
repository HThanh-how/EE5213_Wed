# Enterprise CTL Model Checker

This is an Enterprise-grade Computation Tree Logic (CTL) Model Checker built for the EE5213 course.

## Project Structure
- `src/`: Core checking algorithms (Bottom-up Fixpoint computation).
- `data/`: Real-world scenarios (Microwave Oven, Mutual Exclusion).
- `docs/`: Academic reports and LaTeX source.
- `tests/`: Automated unit tests using pytest.

## Running the Checker
You can run the model checker using the CLI:
```bash
python src/main.py --model data/microwave.json --formulas data/microwave_formulas.json
python src/main.py --model data/mutex.json --formulas data/mutex_formulas.json
```

## Running Tests
```bash
pip install -r requirements.txt
pytest tests/
```
