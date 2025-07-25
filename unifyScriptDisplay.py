import sys
import os
import subprocess
import argparse
import tempfile
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
        
        print(f" {description} completed successfully!")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f" Error in {description}:")
        print(f"   Return code: {e.returncode}")
        
        if e.stdout:
            print(f"   Stdout: {e.stdout}")
        if e.stderr:
            try:
                stderr_clean = e.stderr.encode('utf-8', errors='replace').decode('utf-8')
                print(f"   Stderr: {stderr_clean}")
            except:
                print(f"   Stderr: [Unicode encoding error in error message]")
        
        return False

def run_command_save_to_temp_file(cmd, description):
    """Run a command and save its output to a temporary file"""
    print(f"\n {description}")
    print(f"   Command: {cmd}")
    print("   " + "="*50)
    
    try:
        # Set environment to handle Unicode properly on Windows
        env = os.environ.copy()
        env['PYTHONIOENCODING'] = 'utf-8'
        
        result = subprocess.run(cmd, shell=True, check=True, 
                              capture_output=True, text=True, env=env)
        
        # Get output content
        output_content = ""
        if result.stdout and result.stdout.strip():
            output_content = result.stdout.strip()
            print(" Output captured from stdout")
        elif result.stderr and result.stderr.strip():
            output_content = result.stderr.strip()
            print(" Output captured from stderr")
        else:
            print("  No output captured")
            return None, None
        
        # Create temporary file
        temp_file = tempfile.NamedTemporaryFile(mode='w', encoding='utf-8', 
                                               suffix='.txt', prefix='minizinc_result_', 
                                               delete=False)
        
        # Write to temporary file
        temp_file.write(output_content)
        temp_file.close()
        
        print(f" Output saved to temporary file: {temp_file.name}")
        print(f" Content preview: {output_content[:100]}...")
        print(f" {description} completed successfully!")
        
        return temp_file.name, output_content
        
    except subprocess.CalledProcessError as e:
        print(f" Error in {description}:")
        print(f"   Return code: {e.returncode}")
        
        # Try to capture output even if command failed
        output_content = ""
        if e.stdout and e.stdout.strip():
            output_content = e.stdout.strip()
            print(f"   Stdout: {output_content}")
        if e.stderr and e.stderr.strip():
            try:
                stderr_clean = e.stderr.encode('utf-8', errors='replace').decode('utf-8')
                print(f"   Stderr: {stderr_clean}")
                if not output_content:
                    output_content = stderr_clean
            except:
                print(f"   Stderr: [Unicode encoding error in error message]")
        
        # Save output to temp file even if command failed (sometimes useful)
        if output_content:
            try:
                temp_file = tempfile.NamedTemporaryFile(mode='w', encoding='utf-8', 
                                                       suffix='.txt', prefix='minizinc_error_', 
                                                       delete=False)
                temp_file.write(output_content)
                temp_file.close()
                print(f" Output saved to temporary file despite error: {temp_file.name}")
                return temp_file.name, output_content
            except Exception as file_error:
                print(f" Could not save output to temporary file: {file_error}")
        
        return None, None

def cleanup_temp_file(temp_file_path):
    """Clean up temporary file"""
    if temp_file_path and Path(temp_file_path).exists():
        try:
            os.unlink(temp_file_path)
            print(f" Temporary file cleaned up: {temp_file_path}")
        except Exception as e:
            print(f"  Could not clean up temporary file {temp_file_path}: {e}")

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
    parser.add_argument("model_file", help="Path to the model file")
    parser.add_argument("dsl_file", help="Path to the DSL input file")
    parser.add_argument("--verbose", "-v", action="store_true", 
                       help="Enable verbose output")
    parser.add_argument("--keep-temp", action="store_true",
                       help="Keep temporary file after completion")
    
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
    print(f" Using temporary file for MiniZinc results")
    
    # Create dzn_experiments directory if it doesn't exist
    dzn_dir = Path("dzn_experiments")
    dzn_dir.mkdir(exist_ok=True)
    
    temp_file_path = None
    
    try:
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
        
        # Step 2: Run MiniZinc and save result to temporary file
        minizinc_cmd = f"python 0_2_minizinc.py {model_path} {dzn_output}"
        temp_file_path, output_content = run_command_save_to_temp_file(minizinc_cmd, "MiniZinc Execution")
        
        if not temp_file_path:
            print("\n Pipeline failed at step 2 (MiniZinc execution)!")
            sys.exit(1)
        
        # Step 3: Generate Gantt chart using the temporary file
        display_cmd = f"python .\\0_3_display.py {temp_file_path}"
        success3 = run_command(display_cmd, "Gantt Chart Generation")
        
        if not success3:
            print("\n Pipeline failed at step 3 (Gantt chart generation)!")
            print(f" Try running manually: {display_cmd}")
            print(f" MiniZinc result is in temporary file: {temp_file_path}")
            if args.keep_temp:
                print(f"  Temporary file kept as requested")
            sys.exit(1)
        
        # Summary
        print("\n" + "="*60)
        print(" PIPELINE COMPLETED SUCCESSFULLY!")
        print("="*60)
        print(f" Model file processed: {args.model_file}")
        print(f" DSL file processed: {args.dsl_file}")
        print(f" DZN file generated: {dzn_output}")
        print(f" MiniZinc execution completed")
        print(" Gantt chart generated")
        
        print("\n Check the output for your scheduling results!")
        
        # Keep temporary file if requested
        if args.keep_temp:
            print(f"  Temporary file kept as requested: {temp_file_path}")
            temp_file_path = None  # Don't clean up
        
    finally:
        # Clean up temporary file unless --keep-temp was specified
        if temp_file_path and not args.keep_temp:
            cleanup_temp_file(temp_file_path)

if __name__ == "__main__":
    main()