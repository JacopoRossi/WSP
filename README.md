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
- You can also use the model directly inside Minizinc editor

## Set Up Python using conda

It is possible to use the already defined conda environment.

After having installed **Conda** or **Miniconda** following the [website](https://docs.conda.io/projects/conda/en/stable/user-guide/install/index.html) instructions, download the Github project, open the terminal or an Anaconda Prompt, change directory to go to the location where the file "env.yml" is located and do the following steps:

1. Create the environment from the env.yml file:

```
conda env create -f env.yml
```

The first line of the yml file sets the new environment's name, in this case "wsl_env"

2. Activate the new environment:

```
conda activate wsl_env
```

3. Verify that the new environment was installed correctly:

```
conda env list
```

or

```
conda info --envs.
```



### Parameters:
- `<model_file>`: Path to your MiniZinc model (inside minizinc_model folder)
- `<dsl_file>`: Path to your DSL input file 
- `<dzn_file>`: Path to your dzn file (inside dzn_experiments)
- `<timestep>`: specifie a time point inside time windows (e.g. 5 or 10 or ...)

### Manual Steps

1. **Convert DSL to DZN:**
   ```sh
   python 0_1_dsl_converter.py `<dsl_file>` `<dzn_file>`
   ```

2a. **Run MiniZinc result in terminal:**
   ```sh
   python 0_2_minizinc.py minizinc_model/modelResourceSpecific.mzn `<dzn_file>`
   ```

2b. **Run MiniZinc result with analisi on specific time step:**
   ```sh
   python 0_2_minizinc.py minizinc_model/modelResourceSpecific.mzn `<dzn_file>` `<timestep>`   ```

2c. **Run MiniZinc result chart:**
   ```sh
   python 0_3_display.py --exec python 0_2_minizinc.py minizinc_model/modelResourceSpecific.mzn `<dzn_file>`
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
