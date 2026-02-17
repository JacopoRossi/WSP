# DSL Similarity Test

Tool for calculating similarity between DSL (Domain-Specific Language) files using the **DSL-CodeBLEU** metric.

## 📋 Requirements

Before using the tool, install the required dependencies:

```bash
pip install -r requirements.txt
```

## 📁 File Structure

### `calculate_similarity.py`

**Core module for DSL similarity calculation.**

- Implements the **DSL-CodeBLEU** algorithm which combines:
  - **BLEU-4** (25%): textual similarity based on n-grams
  - **Weighted BLEU** (25%): BLEU weighted for different n-gram lengths
  - **Syntax similarity** (25%): structural matching of the DSL AST
  - **Dataflow similarity** (25%): data flow and dependency analysis

- Main functions:
  - `calculate_dsl_similarity(reference, hypothesis)`: calculates DSL-CodeBLEU score between two DSL files
  - `calculate_bleu_fallback(reference, hypothesis)`: standard BLEU calculation as fallback
  - `calculate_structural_similarity(ref_parser, hyp_parser)`: structural metrics analysis

- Can be used standalone via CLI:
  ```bash
  python calculate_similarity.py reference.dsl hypothesis.dsl --language dsl
  ```

### `dsl_parser.py`

**Custom parser for the DSL language.**

- Parses DSL files and builds the Abstract Syntax Tree (AST)
- Extracts structural elements:
  - **Workspace**: environment configuration
  - **Services**: services defined in the DSL
  - **Tasks**: tasks and operations
  - **Task attributes**: task attributes and parameters
  - **Dataflow**: relationships and dependencies between elements

- Main class:
  - `DSLParser(content)`: initializes the parser with DSL file content
  - `parse()`: performs parsing and populates the AST
  - Access methods for parsed elements for structural analysis

### `similarity_in_folder.py`

**Script for analyzing similarity within a single folder.**

- Compares a main DSL file (reference) with all run files in the same folder
- Automatically identifies:
  - Main file: file without "run" in the name
  - Run files: all files with "run" in the name (e.g., `task_manual_run1.dsl`)

- Generates reports with:
  - DSL-CodeBLEU score for each comparison
  - Aggregated statistics (average, min, max)
  - Output in CSV and/or TXT format

- **Usage:**
  ```bash
  # Analyze a folder
  python similarity_in_folder.py DSL/task52
  
  # With custom outputs
  python similarity_in_folder.py DSL/task52 --csv my_report.csv --txt my_report.txt
  
  # CSV only (no TXT)
  python similarity_in_folder.py DSL/task52 --no-txt
  ```

- **Generated output:**
  - `similarity_report_<folder_name>.csv`: detailed CSV report
  - `similarity_report_<folder_name>.txt`: readable text format report

### `run_all_folders.py`

**Orchestrator script for batch analysis of multiple folders.**

- Automatically runs `similarity_in_folder.py` on all subfolders of a base directory
- Aggregates results from all folders into a single CSV
- Calculates global statistics across all analyses

- **Usage:**
  ```bash
  # Analyze all folders in DSL/
  python run_all_folders.py
  
  # Specify custom directory
  python run_all_folders.py --dsl-dir path/to/DSL
  
  # Custom output
  python run_all_folders.py --output results.csv
  ```

- **Generated output:**
  - `all_folders_similarity.csv`: aggregated results with:
    - Folder name
    - Average DSL-CodeBLEU for each folder
    - Global average
    - Min/Max per folder

- **Workflow:**
  1. Scans the `DSL/` directory (or the specified one)
  2. For each subfolder, runs `similarity_in_folder.py`
  3. Extracts the average DSL-CodeBLEU score from the output
  4. Saves all aggregated results in a final CSV

## 🚀 Quick Start

### Single folder analysis

```bash
python similarity_in_folder.py DSL/task52
```

### Batch analysis of all folders

```bash
python run_all_folders.py
```

## 📊 Output

All scripts calculate and report exclusively the **DSL-CodeBLEU** metric, which combines textual and structural similarity to provide a comprehensive evaluation of similarity between DSL files.

