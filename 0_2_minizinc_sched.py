import minizinc
import sys
import json
import traceback
import re
import os

def main():

    if len(sys.argv) < 3:
        print("Usage: python 0_2_minizinc.py <model_file.mzn> <data_file.dzn> [query_time] [output_path]")
        print("Example: python 0_2_minizinc.py 0_model.mzn 777_space.dzn 100")
        print("Example: python 0_2_minizinc.py 0_model.mzn 777_space.dzn 100 /path/to/output.json")
        sys.exit(1)
    

    mzn_file = sys.argv[1]
    dzn_file = sys.argv[2]
    

    query_time = None
    output_path = None
    
    if len(sys.argv) >= 4:
        try:
            query_time = int(sys.argv[3])
        except ValueError:
            print(f"Error: query_time must be an integer, got '{sys.argv[3]}'")
            sys.exit(1)
    
    if len(sys.argv) >= 5:
        output_path = sys.argv[4]
    
    try:
        # Load model and data files
        model = minizinc.Model(mzn_file)
        instance = minizinc.Instance(minizinc.Solver.lookup("gecode"), model)
        
        # Load data from dzn file
        instance.add_file(dzn_file)
        

        if query_time is not None:
            instance["query_time"] = query_time
        else:
            instance["query_time"] = -1
        
        # Solve
        result = instance.solve()
        
        # Parse text output
        output_text = str(result)
        lines = output_text.strip().split('\n')
        
        # Build JSON output structure
        output = {
            "experiment": {
                "data_file": dzn_file,
                "model_file": mzn_file
            },
            "result": {
                "status": None,
                "makespan_end": None
            },
            "schedule": [],
            "resource_utilization": [],
            "resource_summary": {}
        }
        
        # Parse output text
        i = 0
        while i < len(lines):
            line = lines[i].strip()
            
            # Parse status
            if line in ["FEASIBLE", "UNFEASIBLE"]:
                output["result"]["status"] = line
            
            # Parse makespan
            elif line.startswith("Makespan end:"):
                makespan_str = line.split(":")[1].strip()
                output["result"]["makespan_end"] = int(makespan_str)
            
            # Parse schedule
            elif line.startswith("Task"):
                # Extract task info from line like: Task "INIT_CORE": start=0, end=14
                # or: Task "CTRL_EXEC" (Rep2): start=10, end=13
                match = re.match(r'Task "([^"]+)"(?:\s+\(Rep(\d+)\))?: start=(\d+), end=(\d+)', line)
                if match:
                    task_name = match.group(1)
                    rep_num = int(match.group(2)) if match.group(2) else 1
                    start_time = int(match.group(3))
                    end_time = int(match.group(4))
                    
                    output["schedule"].append({
                        "task": task_name,
                        "repetition": rep_num,
                        "start": start_time,
                        "end": end_time
                    })
            
            # Parse resource line
            elif line.startswith("Resource:"):
                resource_values_str = line.split(":", 1)[1].strip()
                resource_values = [int(v) for v in resource_values_str.split(";") if v]
                
                # We'll fill in resource_utilization later
                output["_resource_values"] = resource_values
            
            # Parse resource utilization table
            elif re.match(r'^\d+\s+\d+\s+\d+\s+\d+%\s+[\d\.]+$', line):
                parts = line.split()
                time = int(parts[0])
                used = int(parts[1])
                available = int(parts[2])
                util_pct = int(parts[3].rstrip('%'))
                util_frac = float(parts[4])
                
                output["resource_utilization"].append({
                    "time": time,
                    "used": used,
                    "available": available,
                    "utilization_pct": util_pct,
                    "utilization_fraction": util_frac
                })
            
            # Parse resource summary
            elif "Total Available:" in line:
                output["resource_summary"]["total_available"] = int(line.split(":")[1].strip())
            elif "Peak Usage:" in line:
                match = re.search(r'(\d+)\s+\((\d+)%\)', line)
                if match:
                    output["resource_summary"]["peak_usage"] = {
                        "value": int(match.group(1)),
                        "pct": int(match.group(2))
                    }
            elif "Average Usage:" in line:
                match = re.search(r'(\d+)\s+\((\d+)%\)', line)
                if match:
                    output["resource_summary"]["average_usage"] = {
                        "value": int(match.group(1)),
                        "pct": int(match.group(2))
                    }
            elif "Time Window:" in line:
                match = re.search(r'\[(\d+)\.\.(\d+)\]', line)
                if match:
                    output["resource_summary"]["time_window"] = {
                        "start": int(match.group(1)),
                        "end": int(match.group(2))
                    }
            elif "Active Time Steps:" in line:
                output["resource_summary"]["active_time_steps"] = int(line.split(":")[1].strip())
            
            i += 1
        
        # Clean up temporary data
        if "_resource_values" in output:
            del output["_resource_values"]
        
        # Generate output filename
        if output_path:
            output_filename = output_path
        else:
            base_name = os.path.splitext(os.path.basename(dzn_file))[0]
            output_filename = f"{base_name}_output.json"
        
        # Save JSON to file
        with open(output_filename, 'w') as f:
            json.dump(output, f, indent=2)
        
        print(f"Output saved to: {output_filename}")
        print()
        
        # Output JSON to stdout
        print(json.dumps(output, indent=2))
        
    except FileNotFoundError as e:
        print(f"Error: File not found - {e}")
        print(f"Make sure both '{mzn_file}' and '{dzn_file}' exist in the current directory")
        traceback.print_exc()
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()