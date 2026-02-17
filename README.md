# WS-Line: Workload Scheduling through LLM-Assisted DSL Generation and CSOP Modeling

## Folder Structure

```
0_1_dsl_converter.py         # Converts DSL files to DZN format
0_2_minizinc_sched.py             # Runs MiniZinc with the model and data
0_3_display.py              # Generates a chart from MiniZinc results
unifyScript.py              # from DSL to result script (without display)
unifyScriptDisplay.py       # from DSL to result script (with display)
WSLine_unifyScript_LLM.py   # Complete automation: Documentation → DSL → DZN → MiniZinc
WSLine_unifyScriptDisplay_LLM.py  # Complete automation: Documentation → DSL → DZN → MiniZinc with Gantt chart display
dsl_generator/              # Automated DSL generation from documentation (LLM + RAG)
temp_dzn_data/              # Output folder for generated .dzn files
minizinc_model/             # MiniZinc models (.mzn)
SpaceOBC_DSL/               # Example DSL files (SpaceOBC)
Syntethic_DSL/              # Synthetic DSL examples
evaluation_data/            # Documentation and test data for DSL generation
test_results/               # Contains the time results 
```

## Requirements

- Python 3.8+
- [MiniZinc](https://www.minizinc.org/) installed and available in your PATH
- For DSL generation: OpenAI API key (set in `.env` file or environment variable)

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

## DSL Generator (Automated DSL Creation from Documentation)

The `dsl_generator` module automatically generates DSL files from Source Requirements using Large Language Models (LLM) and Retrieval-Augmented Generation (RAG).

### Features

- **Automatic DSL Generation**: Converts Source Requirements (PDF) into valid DSL files
- **RAG-based Context Retrieval**: Uses vector embeddings to retrieve relevant information
- **Completeness Checking**: Validates that documentation contains all necessary information
- **Interactive Mode**: Prompts user for missing information if needed
- **Validation & Auto-correction**: Validates generated DSL and attempts to fix errors automatically

### Quick Start

1. **Set up your OpenAI API key** in `.env` file:
   ```
   OPENAI_API_KEY=your_api_key_here
   ```

2. **Generate DSL from documentation**:
   ```sh
   python dsl_generator/generate_dsl.py SR/8_task_manual.pdf -o myDSL/8task.dsl
   ```

### DSL Generator Usage

**Generate DSL from Source Requirements PDF:**
```sh
python dsl_generator/generate_dsl.py <documentation_file> -o <output_dsl_file>
```


### Configuration

The DSL generator can be configured via `dsl_generator/config/config.yaml`:
- LLM model and parameters
- RAG settings (top_k, similarity threshold)
- Embedding model
- Chunk size and overlap
- Output directory

### Prompts

The LLM prompts used for DSL generation are located in:
```
dsl_generator/config/prompts/
├── system_prompt.txt           # System role and DSL specifications
├── extraction_prompt.txt       # Information extraction from documentation
└── generation_prompt.txt       # DSL code generation
```

These prompts can be customized to:
- Adapt the generation style
- Add domain-specific instructions
- Improve accuracy for specific use cases
- Modify the output format

---

## Complete Automation Scripts (WSLine)

The **WSLine** scripts provide complete end-to-end automation from documentation to scheduling results in a single command.

### WSLine_unifyScript_LLM.py

Fully automated pipeline that combines all steps without visualization:
1. **DSL Generation** from PDF documentation (using LLM + RAG)
2. **DSL to DZN Conversion**
3. **MiniZinc Execution** for scheduling

**Usage:**
```sh
python WSLine_unifyScript_LLM.py <documentation_file.pdf> <output_dsl_file.dsl> <model_file.mzn>
```

**Example:**
```sh
python WSLine_unifyScript_LLM.py SR/12_task_manual.pdf myDSL/12_task.dsl minizinc_model/modelAllOpsParameter.mzn
```

### WSLine_unifyScriptDisplay_LLM.py

Same as above but with **Gantt chart visualization**:
1. **DSL Generation** from PDF documentation
2. **DSL to DZN Conversion**
3. **MiniZinc Execution**
4. **Gantt Chart Display** of scheduling results

**Usage:**
```sh
python WSLine_unifyScriptDisplay_LLM.py <documentation_file.pdf> <output_dsl_file.dsl> <model_file.mzn>
```

**Example:**
```sh
python WSLine_unifyScriptDisplay_LLM.py SR/12_task_manual.pdf myDSL/12_task.dsl minizinc_model/modelAllOpsParameter.mzn
```


---

## Evaluation Data

The `evaluation_data/` folder contains all data used for testing and evaluating the DSL generation system.

### Purpose

- **documentation/**: PDF manuals used as input for DSL generation testing
- **gold_standard/**: Manually created, validated DSL files used as reference for comparison
- **test/**: DSL files generated by the system across multiple runs for evaluation
- **result/**: Stores complete WSLine result

---

## Evaluation Scripts

The `evaluation_script/` folder contains tools for evaluating and testing the DSL generation system, including similarity metrics, LLM-based judging, and document generation.

### Structure

```
evaluation_script/
├── DSL-BLUECode/              # DSL similarity evaluation using DSL-CodeBLEU metric
├── LLM-as-a-Judge/            # LLM-based semantic evaluation
└── document_generator/        # Synthetic documentation generation for testing
```

---

### 1. DSL-BLUECode (Similarity Evaluation)

Implements the **DSL-CodeBLEU** metric for semantic evaluation of generated DSL files against gold standards.

#### DSL-CodeBLEU Metric

Combines four components:
- **BLEU-4**: N-gram based textual similarity
- **Weighted BLEU**: Multi-length n-gram weighting
- **Syntax Similarity**: AST structural matching
- **Dataflow Similarity**: Dependency and relationship analysis

#### Key Scripts

**`calculate_similarity.py`** - Core similarity calculation
```sh
python calculate_similarity.py reference.dsl hypothesis.dsl --language dsl
```

**`similarity_in_folder.py`** - Single folder analysis
- Compares reference DSL with all run variants
- Generates CSV and TXT reports with statistics
```sh
# Analyze a specific folder
python similarity_in_folder.py DSL/task12

# Custom output files
python similarity_in_folder.py DSL/task12 --csv results.csv --txt report.txt
```

**`run_all_folders.py`** - Batch analysis across all test cases
- Processes all subfolders in DSL directory
- Aggregates results into single CSV
- Calculates global statistics
```sh
# Analyze all test folders
python run_all_folders.py

# Custom directory
python run_all_folders.py --dsl-dir path/to/DSL --output results.csv
```

**`dsl_parser.py`** - Custom DSL parser for AST extraction
- Parses DSL structure (workspace, services, tasks, constraints)
- Builds Abstract Syntax Tree
- Extracts dataflow relationships

#### Output

- **CSV Reports**: Detailed similarity scores for each comparison
- **TXT Reports**: Human-readable summary with statistics
- **Aggregated Results**: Combined analysis across all test cases

---

### 2. LLM-as-a-Judge (Qualitative Evaluation)

Uses Large Language Models (Gemini) to perform semantic evaluation of generated DSL files.

#### Setup

1. **Set Gemini API key**:
   ```sh
   export GEMINI_API_KEY="your_api_key"
   ```

2. **Install dependencies**:
   ```sh
   pip install -r requirements.txt
   ```

#### Usage

**`llm_judge.py`** - Compare original and generated DSL files
```sh
python llm_judge.py --original-file gold_standard/12_task.dsl --run-file test/12_task_run1.dsl
```

The LLM evaluates:
- Semantic correctness
- Completeness of information
- Structural validity
- Adherence to DSL specifications

---

### 3. Document Generator (Synthetic Test Data)

Generates synthetic technical documentation from DSL files for testing and evaluation purposes.

#### Setup

1. **Set Gemini API key** (in `.env` file or environment):
   ```sh
   export GEMINI_API_KEY="your_api_key"
   ```

2. **Install dependencies**:
   ```sh
   pip install -r requirements.txt
   ```

#### Key Scripts

**`generate_single.py`** - Generate Markdown manual from DSL
```sh
python generate_single.py path/to/task.dsl --output manual.md
```

**`md_to_pdf.py`** - Convert Markdown to PDF
```sh
python md_to_pdf.py manual.md
```



---

### Parameters:

- `<model_file>`: Path to your MiniZinc model (inside minizinc_model folder)
- `<dsl_file>`: Path to your DSL input file
- `<dzn_file>`: Path to your dzn file used as output or input
- `<timestep>`: specifie a time point inside time windows (e.g. 5 or 10 or ...)

### Steps

1. **Convert DSL to DZN:**
   ```sh
   python 0_1_dsl_converter.py `<dsl_file>` `<dzn_file>`
   ```

2a. **Run MiniZinc result in terminal:**

```sh
   python 0_2_minizinc.py minizinc_model/modelAllOpsParameter.mzn `<dzn_file>`
```

2b. **Run MiniZinc result in terminal with analysis on specific time point:**

```sh
   python 0_2_minizinc.py minizinc_model/modelAllOpsParameter.mzn `<dzn_file>` `<timestep>`   ```
```

2c. **Run MiniZinc json result:**

```sh
   python 0_2_minizinc_sched.py minizinc_model/modelAllOpsParameter.mzn `<dzn_file>`
```


2e. **Run MiniZinc visual result:**

```sh
   python 0_3_display.py --exec python 0_2_minizinc.py minizinc_model/modelAllOpsParameter.mzn `<dzn_file>`   ```
```

## Automatic Steps

It is possible to execute the script 1 and 2c automatically by running:

```sh
python unifyScript.py minizinc_model/modelAllOpsParameter.mzn `<dsl_file>`
```

It is possible to execute the script 1 and 2e automatically by running:

```sh
python unifyScriptDisplay.py minizinc_model/modelAllOpsParameter.mzn `<dsl_file>`
```

## Notes

- `.dzn` files are generated automatically in the `temp_dzn_data/` folder.

## Complete End-to-End Workflow

### Option 1: Using WSLine Scripts 

**With visualization (Gantt chart)**:
```sh
python WSLine_unifyScriptDisplay_LLM.py SR/12_task_manual.pdf myDSL/12_task.dsl minizinc_model/modelAllOpsParameter.mzn
```

**Without visualization (faster)**:
```sh
python WSLine_unifyScript_LLM.py SR/12_task_manual.pdf myDSL/12_task.dsl minizinc_model/modelAllOpsParameter.mzn
```

### Option 2: Manual Step-by-Step

1. **Generate DSL from documentation**:
   ```sh
   python dsl_generator/generate_dsl.py SR/12_task_manual.pdf -o myDSL/12_task.dsl
   ```

2. **Convert DSL to DZN and run MiniZinc**:
   ```sh
   python unifyScript.py minizinc_model/modelAllOpsParameter.mzn myDSL/12_task.dsl
   ```

2. **Convert DSL to DZN and run MiniZinc and display results**:
   ```sh
   python unifyScriptDisplay.py minizinc_model/modelAllOpsParameter.mzn myDSL/12_task.dsl
   ```
