# WSP - Automated Task Workload Scheduling in Constrained Services Environment

## Folder Structure

```
0_1_dsl_converter.py         # Converts DSL files to DZN format
0_2_minizinc.py             # Runs MiniZinc with the model and data
0_3_display.py              # Generates a chart from MiniZinc results
unifyScript.py              # Pipeline script (without display)
unifyScriptDisplay.py       # Main pipeline script (with display)
dzn_experiments/            # Output folder for generated .dzn files
minizinc_model/             # MiniZinc models (.mzn)
SpaceOBC_DSL/               # Example DSL files (SpaceOBC)
Syntethic_DSL/              # Synthetic DSL examples
```

## Requirements

- Python
- [MiniZinc](https://www.minizinc.org/) installed and available in your PATH



**Parameters:**
- `<model_file>`: Path to your MiniZinc model (inside minizinc_model folder)
- `<dsl_file>`: Path to your DSL input file 
- `<dzn_file>`: Path to your dzn file (inside dzn_experiments)

### Manual Steps

1. **Convert DSL to DZN:**
   ```sh
   python 0_1_dsl_converter.py `<dsl_file>` `<dzn_file>`
   ```

2a. **Run MiniZinc:**
   ```sh
   python 0_2_minizinc.py `<model_file>` `<dzn_file>`
   ```

2b. **Run MiniZinc and Generate chart:**
   ```sh
   python 0_3_display.py --exec python 0_2_minizinc.py `<model_file>` `<dzn_file>`
   ```

## Examples

```sh
python unifyScriptDisplay.py minizinc_model/modelResourceSpecific.mzn `<dsl_file>`
```

```sh
python unifyScript.py minizinc_model/modelResourceSpecific.mzn `<dsl_file>`
```

## Notes

- `.dzn` files are generated automatically in the `dzn_experiments/` folder.
- MiniZinc models are in [`minizinc_model/`](minizinc_model/).
