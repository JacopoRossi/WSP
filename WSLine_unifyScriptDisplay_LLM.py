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

def run_command_save_to_temp_file(cmd, description):
    """Run a command, show real-time output, and save its output to a temporary file"""
    print(f"\n {description}")
    print(f"   Command: {cmd}")
    print("   " + "="*50)
    print()  # Empty line for better readability
    
    try:
        # Set environment to handle Unicode properly
        env = os.environ.copy()
        env['PYTHONIOENCODING'] = 'utf-8'
        
        # Run with real-time output but also capture it
        result = subprocess.run(cmd, shell=True, check=True, 
                              capture_output=True, text=True, env=env)
        
        # Show output in real-time (display what was captured)
        output_content = ""
        if result.stdout and result.stdout.strip():
            output_content = result.stdout.strip()
            print(output_content)  # Display the output
            print()
        elif result.stderr and result.stderr.strip():
            output_content = result.stderr.strip()
            print(output_content)  # Display the output
            print()
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
        
        print(f"💾 Output saved to temporary file: {temp_file.name}")
        print(f"✅ {description} completed successfully!")
        
        return temp_file.name, output_content
        
    except subprocess.CalledProcessError as e:
        print()
        print(f"❌ Error in {description}:")
        print(f"   Return code: {e.returncode}")
        
        # Try to capture output even if command failed
        output_content = ""
        if e.stdout and e.stdout.strip():
            output_content = e.stdout.strip()
            print(output_content)
        if e.stderr and e.stderr.strip():
            try:
                stderr_clean = e.stderr.encode('utf-8', errors='replace').decode('utf-8')
                print(stderr_clean)
                if not output_content:
                    output_content = stderr_clean
            except:
                print(f"   [Unicode encoding error in error message]")
        
        # Save output to temp file even if command failed (sometimes useful)
        if output_content:
            try:
                temp_file = tempfile.NamedTemporaryFile(mode='w', encoding='utf-8', 
                                                       suffix='.txt', prefix='minizinc_error_', 
                                                       delete=False)
                temp_file.write(output_content)
                temp_file.close()
                print(f"💾 Output saved to temporary file despite error: {temp_file.name}")
                return temp_file.name, output_content
            except Exception as file_error:
                print(f"  Could not save output to temporary file: {file_error}")
        
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
        description="Automate the complete task scheduling pipeline with DSL generation and display",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python unifyScriptDisplay_LLM.py SpaceOBC_document/SpaceOBC1_Technical_Manual.pdf myDSL/Space11_1.dsl model.mzn
  python unifyScriptDisplay_LLM.py ./docs/manual.pdf ./output/generated.dsl ./models/scheduling.mzn
        """
    )
    parser.add_argument("documentation_file", help="Path to the PDF documentation file")
    parser.add_argument("dsl_file", help="Path to the output DSL file (will be generated)")
    parser.add_argument("model_file", help="Path to the MiniZinc model file")
    parser.add_argument("--verbose", "-v", action="store_true", 
                       help="Enable verbose output")
    parser.add_argument("--keep-temp", action="store_true",
                       help="Keep temporary file after completion")
    
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
    
    print(" TASK SCHEDULING PIPELINE AUTOMATION WITH DISPLAY")
    print("="*60)
    print(f" Input documentation file: {args.documentation_file}")
    print(f" Output DSL file: {args.dsl_file}")
    print(f" Input model file: {args.model_file}")
    print(f" Output DZN file: {dzn_output}")
    print(f" Base name: {file_stem}")
    print(f" Using temporary file for MiniZinc results")
    
    # Create output directories if they don't exist
    dzn_dir = Path("temp_dzn_data")
    dzn_dir.mkdir(exist_ok=True)
    
    # Create DSL output directory if it doesn't exist
    dsl_dir = dsl_path.parent
    if dsl_dir != Path('.'):
        dsl_dir.mkdir(parents=True, exist_ok=True)
    
    temp_file_path = None
    
    try:
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
        display_cmd = f"python 0_3_display.py {temp_file_path}"
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
        print(f" Documentation processed: {args.documentation_file}")
        print(f" DSL file generated: {args.dsl_file}")
        print(f" DZN file generated: {dzn_output}")
        print(f" MiniZinc execution completed")
        print(" Gantt chart displayed")
        
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