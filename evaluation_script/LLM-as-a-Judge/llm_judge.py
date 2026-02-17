#!/usr/bin/env python3
"""
LLM as a Judge - DSL Comparison System
Compares original DSL tasks with their runs using Google Gemini
"""

import os
import sys
import json
from pathlib import Path
from typing import Dict, List, Tuple
from google import genai


class DSLJudge:
    """Judge system for comparing DSL files using Gemini"""
    
    def __init__(self, api_key: str = None, model_name: str = "models/gemini-3-pro-preview"):
        """
        Initialize the DSL Judge
        
        Args:
            api_key: Google API key for Gemini (if None, reads from GEMINI_API_KEY env var)
            model_name: Gemini model to use
        """
        if api_key is None:
            api_key = os.getenv("GEMINI_API_KEY")
            if not api_key:
                raise ValueError(
                    "API key not provided. Set GEMINI_API_KEY environment variable "
                    "or pass api_key parameter"
                )
        
        self.client = genai.Client(api_key=api_key)
        self.model_name = model_name
        
    def create_comparison_prompt(self, original_dsl: str, run_dsl: str) -> str:
        """
        Create a prompt for Gemini to compare two DSL files
        
        Args:
            original_dsl: Content of the original DSL file
            run_dsl: Content of the run DSL file
            
        Returns:
            Formatted prompt string
        """
        prompt = f"""You are an expert system evaluator comparing DSL (Domain Specific Language) files.
Your task is to compare the ORIGINAL DSL with a RUN DSL and determine if they are semantically equivalent in terms of content.

IMPORTANT EVALUATION CRITERIA:
1. **Structural equivalence**: Check if services, tasks, and constraints are the same
2. **Data values**: Compare all numerical values (durations, resources, delays, etc.)
3. **Relationships**: Verify that task dependencies and constraints match
4. **Naming**: Check if names and identifiers are consistent (minor formatting differences are acceptable)
5. **Completeness**: Ensure no tasks, services, or constraints are missing or added

SCORING GUIDELINES:
- 100: Perfect match, semantically identical
- 90-99: Minor cosmetic differences (spacing, comments, order) but semantically identical
- 70-89: Minor differences in non-critical fields or very small value differences
- 50-69: Some notable differences but core structure is similar
- 30-49: Significant differences in structure or values
- 0-29: Major differences, different tasks or completely different structure

Provide your evaluation in the following JSON format:
{{
    "equivalent_meaning": <boolean>,
    "score": <integer from 0 to 100>,
    "explanation": "<detailed explanation in English of why you gave this score, highlighting specific differences or confirmations of similarity>"
}}

ORIGINAL DSL:
```
{original_dsl}
```

RUN DSL:
```
{run_dsl}
```

Analyze the two DSL files and provide your evaluation in JSON format."""
        
        return prompt
    
    def compare_dsl_files(self, original_path: Path, run_path: Path) -> Dict:
        """
        Compare two DSL files and return score and explanation
        
        Args:
            original_path: Path to original DSL file
            run_path: Path to run DSL file
            
        Returns:
            Dictionary with 'score' and 'explanation'
        """
        # Read files
        with open(original_path, 'r', encoding='utf-8') as f:
            original_content = f.read()
        
        with open(run_path, 'r', encoding='utf-8') as f:
            run_content = f.read()
        
        # Create prompt and get response
        prompt = self.create_comparison_prompt(original_content, run_content)
        
        try:
            # Assicurati che il model name abbia il prefisso models/
            model_path = self.model_name if self.model_name.startswith('models/') else f'models/{self.model_name}'
            
            # Configurazione con temperatura 0 per risposte deterministiche
            config = {
                'temperature': 0.0,
                'top_p': 1.0,
                'top_k': 1
            }
            
            response = self.client.models.generate_content(
                model=model_path,
                contents=prompt,
                config=config
            )
            result_text = response.text
            
            # Extract JSON from response
            # Try to find JSON in the response
            if "```json" in result_text:
                json_start = result_text.find("```json") + 7
                json_end = result_text.find("```", json_start)
                json_text = result_text[json_start:json_end].strip()
            elif "```" in result_text:
                json_start = result_text.find("```") + 3
                json_end = result_text.find("```", json_start)
                json_text = result_text[json_start:json_end].strip()
            else:
                # Se non ci sono backtick, cerca direttamente le parentesi graffe
                json_text = result_text.strip()
                # Se il parsing fallisce, prova a estrarre solo il JSON dalle parentesi graffe
                if json_text and not json_text.startswith('{'):
                    brace_start = json_text.find('{')
                    brace_end = json_text.rfind('}')
                    if brace_start != -1 and brace_end != -1 and brace_end > brace_start:
                        json_text = json_text[brace_start:brace_end+1]
            
            result = json.loads(json_text)
            
            # Validate result
            if "score" not in result or "explanation" not in result:
                raise ValueError("Response missing required fields")
            
            # Ensure score is in valid range
            result["score"] = max(0, min(100, int(result["score"])))
            
            return result
            
        except Exception as e:
            print(f"Error processing comparison: {e}", file=sys.stderr)
            print(f"Response: {response.text if 'response' in locals() else 'No response'}", file=sys.stderr)
            return {
                "score": 0,
                "explanation": f"Errore durante la valutazione: {str(e)}"
            }
    
    def evaluate_task_folder(self, task_folder: Path) -> List[Dict]:
        """
        Evaluate all runs in a task folder against the original
        
        Args:
            task_folder: Path to task folder (e.g., task8 or spaceOBC1)
            
        Returns:
            List of dictionaries with evaluation results
        """
        # Find original task file
        task_name = task_folder.name
        
        # Try different naming patterns
        # Pattern 1: {task_name}.dsl (e.g., spaceOBC1.dsl)
        original_file = task_folder / f"{task_name}.dsl"
        
        # Pattern 2: {task_number}_task.dsl (e.g., 8_task.dsl for task8)
        if not original_file.exists() and task_name.startswith("task"):
            task_number = task_name.replace("task", "")
            original_file = task_folder / f"{task_number}_task.dsl"
        
        if not original_file.exists():
            raise FileNotFoundError(
                f"Original task file not found. Tried: {task_name}.dsl or "
                f"{task_name.replace('task', '')}_task.dsl in {task_folder}"
            )
        
        # Find all run files (all .dsl files except the original)
        all_dsl_files = sorted(task_folder.glob("*.dsl"))
        run_files = [f for f in all_dsl_files if f != original_file]
        
        if not run_files:
            print(f"Warning: No run files found in {task_folder}", file=sys.stderr)
            return []
        
        results = []
        
        print(f"\n{'='*60}")
        print(f"Evaluating {task_name}: {len(run_files)} runs")
        print(f"{'='*60}\n")
        
        for run_file in run_files:
            print(f"Comparing: {run_file.name}...", end=" ", flush=True)
            
            result = self.compare_dsl_files(original_file, run_file)
            result["run_file"] = run_file.name
            result["original_file"] = original_file.name
            result["task"] = task_name
            
            results.append(result)
            
            print(f"Score: {result['score']}/100")
        
        return results
    
    def evaluate_all_tasks(self, base_folder: Path) -> Dict[str, List[Dict]]:
        """
        Evaluate all task folders in the base directory
        
        Args:
            base_folder: Base directory containing task folders
            
        Returns:
            Dictionary mapping task names to their evaluation results
        """
        task_folders = sorted([
            f for f in base_folder.iterdir() 
            if f.is_dir() and f.name.startswith("task")
        ])
        
        if not task_folders:
            raise ValueError(f"No task folders found in {base_folder}")
        
        all_results = {}
        
        for task_folder in task_folders:
            try:
                results = self.evaluate_task_folder(task_folder)
                all_results[task_folder.name] = results
            except Exception as e:
                print(f"Error evaluating {task_folder.name}: {e}", file=sys.stderr)
                all_results[task_folder.name] = []
        
        return all_results
    
    def save_results(self, results: Dict[str, List[Dict]], output_file: Path):
        """
        Save evaluation results to a JSON file
        
        Args:
            results: Evaluation results
            output_file: Path to output JSON file
        """
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(results, f, ensure_ascii=False, indent=2)
        
        print(f"\nResults saved to: {output_file}")
    
    def print_summary(self, results: Dict[str, List[Dict]]):
        """
        Print a summary of evaluation results
        
        Args:
            results: Evaluation results
        """
        print(f"\n{'='*60}")
        print("SUMMARY")
        print(f"{'='*60}\n")
        
        total_comparisons = 0
        total_score = 0
        
        for task_name, task_results in results.items():
            if not task_results:
                continue
            
            avg_score = sum(r["score"] for r in task_results) / len(task_results)
            total_comparisons += len(task_results)
            total_score += sum(r["score"] for r in task_results)
            
            print(f"{task_name}: {len(task_results)} runs, avg score: {avg_score:.1f}/100")
        
        if total_comparisons > 0:
            overall_avg = total_score / total_comparisons
            print(f"\nOverall: {total_comparisons} comparisons, avg score: {overall_avg:.1f}/100")


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(
        description="LLM as a Judge - Compare DSL files using Google Gemini"
    )
    parser.add_argument(
        "--base-dir",
        type=Path,
        default=Path(__file__).parent,
        help="Base directory containing task folders (default: script directory)"
    )
    parser.add_argument(
        "--task",
        type=str,
        help="Specific task folder to evaluate (e.g., task8). If not specified, evaluates all tasks."
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).parent / "evaluation_results.json",
        help="Output JSON file for results (default: evaluation_results.json)"
    )
    parser.add_argument(
        "--api-key",
        type=str,
        help="Google Gemini API key (or set GEMINI_API_KEY environment variable)"
    )
    parser.add_argument(
        "--model",
        type=str,
        default="models/gemini-3-pro-preview",
        help="Gemini model to use (default: models/gemini-3-pro-preview). Options: models/gemini-3-pro-preview, gemini-1.5-flash, gemini-1.5-pro, gemini-pro"
    )
    parser.add_argument(
        "--original-file",
        type=Path,
        help="Path to the original DSL file for a direct comparison."
    )
    parser.add_argument(
        "--run-file",
        type=Path,
        help="Path to the run DSL file for a direct comparison."
    )
    
    args = parser.parse_args()
    
    # Initialize judge
    try:
        judge = DSLJudge(api_key=args.api_key, model_name=args.model)
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

    # Decide execution mode
    if args.original_file and args.run_file:
        # Direct file comparison mode
        try:
            if not args.original_file.exists():
                raise FileNotFoundError(f"Original file not found: {args.original_file}")
            if not args.run_file.exists():
                raise FileNotFoundError(f"Run file not found: {args.run_file}")

            print(f"Performing direct comparison between:")
            print(f"  Original: {args.original_file}")
            print(f"  Run:      {args.run_file}")

            result = judge.compare_dsl_files(args.original_file, args.run_file)

            # Add file names to the result for context
            result['original_file'] = args.original_file.name
            result['run_file'] = args.run_file.name

            # Structure for saving
            save_data = {
                "direct_comparison": [result]
            }

            # Save the result to the output file
            judge.save_results(save_data, args.output)

            print(f"\n{'='*60}")
            print("DIRECT COMPARISON RESULT")
            print(f"{'='*60}\n")
            print(f"Score: {result['score']}/100")
            print(f"Equivalent Meaning: {result.get('equivalent_meaning', 'N/A')}")
            print(f"Explanation: {result['explanation']}")
            print(f"\n{'='*60}")

        except Exception as e:
            print(f"Error: {e}", file=sys.stderr)
            sys.exit(1)

    elif (args.original_file and not args.run_file) or (not args.original_file and args.run_file):
        print("Error: For direct comparison, both --original-file and --run-file must be provided.", file=sys.stderr)
        sys.exit(1)

    else:
        # Folder-based evaluation mode
        try:
            if args.task:
                # Evaluate single task
                task_folder = args.base_dir / args.task
                if not task_folder.exists():
                    raise FileNotFoundError(f"Task folder not found: {task_folder}")
                
                results = judge.evaluate_task_folder(task_folder)
                all_results = {args.task: results}
            else:
                # Evaluate all tasks
                all_results = judge.evaluate_all_tasks(args.base_dir)
            
            # Save and display results
            if any(all_results.values()):
                judge.save_results(all_results, args.output)
                judge.print_summary(all_results)
                
                # Print detailed results for first few comparisons
                print(f"\n{'='*60}")
                print("DETAILED RESULTS (first 3 comparisons)")
                print(f"{'='*60}\n")
                
                count = 0
                for task_name, task_results in all_results.items():
                    for result in task_results:
                        if count >= 3:
                            break
                        print(f"Task: {result['task']}")
                        print(f"Run: {result['run_file']}")
                        print(f"Score: {result['score']}/100")
                        print(f"Explanation: {result['explanation']}")
                        print(f"{'='*60}\n")
                        count += 1
                    if count >= 3:
                        break
            else:
                print("No comparisons were made.")

        except Exception as e:
            print(f"Error: {e}", file=sys.stderr)
            sys.exit(1)


if __name__ == "__main__":
    main()
