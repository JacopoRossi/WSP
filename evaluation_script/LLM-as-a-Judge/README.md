# LLM Judge

This project uses a Python script to judge the output of a large language model.

## Prerequisites

Before running the script, you need to set up your environment.

### Gemini API Key

You must have a Gemini API key to run this script. Export it as an environment variable:

```bash
export GEMINI_API_KEY="YOUR_API_KEY"
```

Replace `"YOUR_API_KEY"` with your actual Gemini API key.

### Dependencies

Install the required Python packages using pip:

```bash
pip install -r requirements.txt
```

## Usage

To run the script, use the following command:

```bash
python llm_judge.py --original-file path/to/your/original_task.dsl --run-file path/to/your/run_file.dsl
```

Replace `path/to/your/original_task.dsl` and `path/to/your/run_file.dsl` with the actual file paths.

This will compare the original task with the run file and provide an evaluation.
