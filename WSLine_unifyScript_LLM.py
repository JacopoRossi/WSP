import sys
import os
import subprocess
import argparse
from pathlib import Path

def run_command(cmd, description):
    """Run a command and handle errors"""
    print(f"\n {description}")
    print(f"   Command: {cmd}")
    print("   " + "="*50)
    print()  # Empty line for better readability
    
    try:
        # Set environment to handle Unicode properly
        env = os.environ.copy()
        env['PYTHONIOENCODING'] = 'utf-8'
        
        # Run without capturing output - shows in real-time
        result = subprocess.run(cmd, shell=True, check=True, env=env)
        
        print()  # Empty line after output
        print(f"✅ {description} completed successfully!")
        return True
        
    except subprocess.CalledProcessError as e:
        print()  # Empty line after output
        print(f"❌ Error in {description}:")
        print(f"   Return code: {e.returncode}")
        return False

def main():
    parser = argparse.ArgumentParser(
        description="Automate the complete task scheduling pipeline with DSL generation",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python unifyScript_LLM.py SpaceOBC_document/SpaceOBC1_Technical_Manual.pdf myDSL/Space11_1.dsl model.mzn
  python unifyScript_LLM.py ./docs/manual.pdf ./output/generated.dsl ./models/scheduling.mzn
        """
    )
    parser.add_argument("documentation_file", help="Path to the PDF documentation file")
    parser.add_argument("dsl_file", help="Path to the output DSL file (will be generated)")
    parser.add_argument("model_file", help="Path to the MiniZinc model file")
    parser.add_argument("--verbose", "-v", action="store_true", 
                       help="Enable verbose output")
    
    args = parser.parse_args()
    
    # Validate input files
    doc_path = Path(args.documentation_file)
    if not doc_path.exists():
        print(f" Error: Documentation file '{args.documentation_file}' not found!")
        sys.exit(1)
    
    model_path = Path(args.model_file)
    if not model_path.exists():
        print(f" Error: Model file '{args.model_file}' not found!")
        sys.exit(1)
    
    dsl_path = Path(args.dsl_file)
    
    if not dsl_path.suffix == '.dsl':
        print(f"  Warning: Input file doesn't have .dsl extension")
    
    # Extract filename without extension and directory
    file_stem = dsl_path.stem  # e.g., "22_space" from "22_space.dsl"
    
    # Build paths
    dzn_output = Path("temp_dzn_data") / f"{file_stem}.dzn"
    
    print(" TASK SCHEDULING PIPELINE AUTOMATION")
    print("="*60)
    print(f" Input documentation file: {args.documentation_file}")
    print(f" Output DSL file: {args.dsl_file}")
    print(f" Input model file: {args.model_file}")
    print(f" Output DZN file: {dzn_output}")
    print(f" Base name: {file_stem}")
    
    # Create output directories if they don't exist
    dzn_dir = Path("temp_dzn_data")
    dzn_dir.mkdir(exist_ok=True)
    
    # Create DSL output directory if it doesn't exist
    dsl_dir = dsl_path.parent
    if dsl_dir != Path('.'):
        dsl_dir.mkdir(parents=True, exist_ok=True)
    
    # Step 0: Generate DSL from documentation
    cmd0 = f"python dsl_generator/generate_dsl.py {args.documentation_file} -o {args.dsl_file}"
    success0 = run_command(cmd0, "DSL Generation from Documentation")
    
    if not success0:
        print("\n Pipeline failed at DSL generation step!")
        sys.exit(1)
    
    # Verify DSL file was created
    if not dsl_path.exists():
        print(f" Error: Expected DSL file '{args.dsl_file}' was not created!")
        sys.exit(1)
    
    # Step 1: Convert DSL to DZN
    cmd1 = f"python 0_1_dsl_converter.py {args.dsl_file} {dzn_output}"
    success1 = run_command(cmd1, "DSL to DZN Conversion")
    
    if not success1:
        print("\n Pipeline failed at step 1!")
        sys.exit(1)
    
    # Verify DZN file was created
    if not dzn_output.exists():
        print(f" Error: Expected output file '{dzn_output}' was not created!")
        sys.exit(1)
    
    # Step 2: Run MiniZinc and generate Gantt chart
    cmd2 = f'python 0_2_minizinc_sched.py {model_path} {dzn_output}'
    success2 = run_command(cmd2, "MiniZinc Execution & Gantt Chart Generation")
    
    # If it fails, try alternative approach
    if not success2:
        print("\n Trying alternative approach...")
        
        # Run MiniZinc directly
        minizinc_cmd = f"python 0_2_minizinc_sched.py {model_path} {dzn_output}"
        success2 = run_command(minizinc_cmd, "MiniZinc Execution (Direct)")
        
        if success2:
            print("\n MiniZinc completed successfully!")
            print("   Note: Gantt chart generation might have encoding issues on Windows")
            print("   You can run the Gantt generation manually if needed:")
            print(f"   python 0_2_minizinc_sched.py {model_path} {dzn_output}")
    
    if not success2:
        print("\n Pipeline failed at step 2!")
        sys.exit(1)
    
    # Summary
    print("\n" + "="*60)
    print(" PIPELINE COMPLETED SUCCESSFULLY!")
    print("="*60)
    print(f" Documentation processed: {args.documentation_file}")
    print(f" DSL file generated: {args.dsl_file}")
    print(f" DZN file generated: {dzn_output}")
    print(" MiniZinc execution completed")
    print(" Gantt chart generated")
    print("\n Check the output for your scheduling results!")

if __name__ == "__main__":
    main()