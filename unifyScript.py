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
    
    try:
        # Set environment to handle Unicode properly on Windows
        env = os.environ.copy()
        env['PYTHONIOENCODING'] = 'utf-8'
        
        result = subprocess.run(cmd, shell=True, check=True, 
                              capture_output=True, text=True, env=env)
        if result.stdout:
            print(result.stdout)
        
        print(f"✅ {description} completed successfully!")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f" Error in {description}:")
        print(f"   Return code: {e.returncode}")
        
        if e.stdout:
            print(f"   Stdout: {e.stdout}")
        if e.stderr:
            # Try to decode stderr safely to avoid Unicode errors
            try:
                stderr_clean = e.stderr.encode('utf-8', errors='replace').decode('utf-8')
                print(f"   Stderr: {stderr_clean}")
            except:
                print(f"   Stderr: [Unicode encoding error in error message]")
        
        return False

def main():
    parser = argparse.ArgumentParser(
        description="Automate the task scheduling pipeline",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python pipeline_auto.py model.mzn .\\dsl_base\\22_space.dsl
  python pipeline_auto.py model.mzn ./dsl_base/22_space.dsl
        """
    )
    parser.add_argument("model_file", help="Path to the MiniZinc model file")
    parser.add_argument("dsl_file", help="Path to the DSL input file")
    parser.add_argument("--verbose", "-v", action="store_true", 
                       help="Enable verbose output")
    
    args = parser.parse_args()
    
    # Validate input files
    dsl_path = Path(args.dsl_file)
    if not dsl_path.exists():
        print(f" Error: DSL file '{args.dsl_file}' not found!")
        sys.exit(1)
    
    model_path = Path(args.model_file)
    if not model_path.exists():
        print(f" Error: Model file '{args.model_file}' not found!")
        sys.exit(1)
    
    if not dsl_path.suffix == '.dsl':
        print(f"  Warning: Input file doesn't have .dsl extension")
    
    # Extract filename without extension and directory
    file_stem = dsl_path.stem  # e.g., "22_space" from "22_space.dsl"
    
    # Build paths
    dzn_output = f".\\dzn_experiments\\{file_stem}.dzn"
    
    print(" TASK SCHEDULING PIPELINE AUTOMATION")
    print("="*60)
    print(f" Input model file: {args.model_file}")
    print(f" Input DSL file: {args.dsl_file}")
    print(f" Output DZN file: {dzn_output}")
    print(f" Base name: {file_stem}")
    
    # Create dzn_experiments directory if it doesn't exist
    dzn_dir = Path("dzn_experiments")
    dzn_dir.mkdir(exist_ok=True)
    
    # Step 1: Convert DSL to DZN
    cmd1 = f"python .\\0_1_dsl_converter.py {args.dsl_file} {dzn_output}"
    success1 = run_command(cmd1, "DSL to DZN Conversion")
    
    if not success1:
        print("\n Pipeline failed at step 1!")
        sys.exit(1)
    
    # Verify DZN file was created
    if not Path(dzn_output).exists():
        print(f" Error: Expected output file '{dzn_output}' was not created!")
        sys.exit(1)
    
    # Step 2: Run MiniZinc and generate Gantt chart
    cmd2 = f'python 0_2_minizinc.py {model_path} {dzn_output}'
    success2 = run_command(cmd2, "MiniZinc Execution & Gantt Chart Generation")
    
    # If it fails, try alternative approach
    if not success2:
        print("\n Trying alternative approach...")
        
        # Run MiniZinc directly
        minizinc_cmd = f"python 0_2_minizinc.py {model_path} {dzn_output}"
        success2 = run_command(minizinc_cmd, "MiniZinc Execution (Direct)")
        
        if success2:
            print("\n MiniZinc completed successfully!")
            print("   Note: Gantt chart generation might have encoding issues on Windows")
            print("   You can run the Gantt generation manually if needed:")
            print(f"   python 0_2_minizinc.py {model_path} {dzn_output}")
    
    if not success2:
        print("\n Pipeline failed at step 2!")
        sys.exit(1)
    
    # Summary
    print("\n" + "="*60)
    print(" PIPELINE COMPLETED SUCCESSFULLY!")
    print("="*60)
    print(f" DSL file processed: {args.dsl_file}")
    print(f" DZN file generated: {dzn_output}")
    print(" MiniZinc execution completed")
    print(" Gantt chart generated")
    print("\n Check the output for your scheduling results!")

if __name__ == "__main__":
    main()