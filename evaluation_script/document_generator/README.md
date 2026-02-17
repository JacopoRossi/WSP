# Manual Creation Tool

## Usage Instructions

### 1. Set up Gemini API Key

Export your Gemini API key as an environment variable:

```bash
export GEMINI_API_KEY="your_api_key"
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Generate the manual in Markdown format

```bash
python generate_single.py "dsl_file_path" --output output_name.md
```

### 4. Convert Markdown to PDF

```bash
python md_to_pdf.py "output_name.md"
```

---

The PDF file will be generated in the same directory as the Markdown file.
