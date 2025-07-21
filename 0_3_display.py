import matplotlib.pyplot as plt
import matplotlib.patches as patches
import re
import sys
import subprocess
import argparse
import numpy as np
from collections import defaultdict

class GanttChartGenerator:
    def __init__(self):
        # Distinctive colors for each task type
        self.base_colors = [
            "#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA726", "#AB47BC", 
            "#66BB6A", "#FF8A65", "#42A5F5", "#FFCA28", "#8D6E63",
            "#A1887F", "#90A4AE", "#F06292", "#7986CB", "#FFB74D",
            "#E57373", "#81C784", "#64B5F6", "#FFD54F", "#F06292"
        ]
        self.task_colors = {}
        self.color_index = 0
    
    def get_color_for_task_type(self, task_type):
        """Assigns a unique color for each task type"""
        if task_type not in self.task_colors:
            self.task_colors[task_type] = self.base_colors[self.color_index % len(self.base_colors)]
            self.color_index += 1
        return self.task_colors[task_type]
    
    def parse_output(self, output_text):
        """Extracts data from the scheduling program output"""
        lines = output_text.strip().split('\n')
        
        tasks = []
        makespan = 0
        resource_data = ""
        
        print("Parsing output...")
        
        # Extract makespan
        for line in lines:
            if line.strip().startswith("Makespan end:"):
                makespan = int(line.split(":")[1].strip())
                print("Makespan found: {}".format(makespan))
                break
        
        # Extract tasks from Schedule section
        in_schedule = False
        task_count = 0
        
        for line in lines:
            original_line = line
            line = line.strip()
            
            if line == "Schedule:":
                in_schedule = True
                print("Starting Schedule section")
                continue
            elif line.startswith("===") or line.startswith("Time:") or line.startswith("Resource:"):
                if in_schedule:
                    print("End Schedule section - Tasks found: {}".format(task_count))
                in_schedule = False
                
            if in_schedule and line:
                # Pattern for tasks with support for parentheses and spaces
                pattern = r'Task\s+"([^"]+)"\s*(\([^)]+\))?\s*:\s*start=(\d+),\s*end=(\d+)'
                match = re.match(pattern, line)
                
                if match:
                    base_name = match.group(1)
                    rep_part = match.group(2) if match.group(2) else ""
                    start_time = int(match.group(3))
                    end_time = int(match.group(4))
                    
                    # Build full name and repetition number
                    if rep_part:
                        full_name = "{} {}".format(base_name, rep_part)
                        # Extract repetition number (Rep2 -> R2, Rep3 -> R3, etc.)
                        rep_match = re.search(r'Rep(\d+)', rep_part)
                        if rep_match:
                            rep_number = "R{}".format(rep_match.group(1))
                        else:
                            rep_number = rep_part.strip("()")
                    else:
                        full_name = base_name
                        rep_number = "1"
                    
                    # Determine base task type
                    task_type = base_name.split()[0] if base_name else "Unknown"
                    
                    task = {
                        "name": full_name,
                        "base_name": base_name,
                        "rep_number": rep_number,
                        "start": start_time,
                        "end": end_time,
                        "type": task_type,
                        "duration": end_time - start_time
                    }
                    
                    tasks.append(task)
                    task_count += 1
                    print("  Task {}: {} ({}-{}) [Rep: {}]".format(task_count, full_name, start_time, end_time, rep_number))
        
        # Extract resource data if present
        for line in lines:
            if line.strip().startswith("Resource:"):
                resource_data = line.split("Resource:")[1].strip()
                print("Resource data found: {}...".format(resource_data[:30]))
                break
        
        print("Total tasks extracted: {}".format(len(tasks)))
        return tasks, makespan, resource_data
    
    def organize_tasks_by_type(self, tasks):
        """Organizes tasks by type, separating concurrent ones on different lines"""
        task_lines = []
        
        # Group by type
        task_groups = defaultdict(list)
        for task in tasks:
            task_groups[task["type"]].append(task)
        
        # For each type, organize tasks in separate lines if concurrent
        for task_type in sorted(task_groups.keys()):
            type_tasks = task_groups[task_type]
            type_tasks.sort(key=lambda x: x["start"])
            
            print("Organizing {}: {} tasks".format(task_type, len(type_tasks)))
            
            # Create lines for this task type
            type_lines = []
            
            for task in type_tasks:
                # Find the first line where this task can be placed
                placed = False
                for line in type_lines:
                    # Check if it can be placed on this line (no overlap)
                    can_place = True
                    for existing_task in line:
                        # Two tasks overlap if one starts before the other ends
                        if not (task["end"] <= existing_task["start"] or task["start"] >= existing_task["end"]):
                            can_place = False
                            break
                    
                    if can_place:
                        line.append(task)
                        placed = True
                        print("  {} -> Existing line {}".format(task['rep_number'], len(type_lines)))
                        break
                
                # If it can't be placed on any existing line, create a new line
                if not placed:
                    type_lines.append([task])
                    print("  {} -> New line {}".format(task['rep_number'], len(type_lines)))
            
            # Add all lines of this type to total lines
            for line in type_lines:
                task_lines.append({
                    'type': task_type,
                    'tasks': line,
                    'line_number': len([l for l in task_lines if l['type'] == task_type]) + 1
                })
        
        return task_lines
    
    def parse_resource_data(self, resource_data, makespan):
        """Converts resource data to numeric array - UPDATED FOR SEPARATORS"""
        if not resource_data:
            return np.zeros(makespan + 1)
        
        resource_values = []
        resource_data_clean = resource_data.strip()
        
        print("Parsing resource data: length={}, makespan={}".format(len(resource_data_clean), makespan))
        print("Raw resource data: {}".format(resource_data_clean))
        
        # Handle both formats with and without separators
        if ';' in resource_data_clean:
            # Format with separators: "1;2;1;2;1;2;..."
            resource_parts = resource_data_clean.split(';')
            print("Format with separators detected: {} values".format(len(resource_parts)))
            
            for part in resource_parts:
                try:
                    value = int(part.strip()) if part.strip() else 0
                    resource_values.append(value)
                except ValueError:
                    resource_values.append(0)
                    print("Invalid value: '{}'".format(part))
        else:
            # Format without separators (backward compatibility): "121212121222..."
            print("Format without separators (legacy)")
            for char in resource_data_clean:
                try:
                    value = int(char)
                    resource_values.append(value)
                except ValueError:
                    resource_values.append(0)
                    print("Invalid character: '{}'".format(char))
        
        result = np.array(resource_values)
        min_val = min(result) if len(result) > 0 else 0
        max_val = max(result) if len(result) > 0 else 0
        print("Resource values parsed: {} values, range: {}-{}".format(len(result), min_val, max_val))
        
        return result
    
    def create_gantt_chart(self, tasks, makespan, resource_data="", title="Task Schedule with Repetitions", save_path=None):
        """Creates the Gantt chart with resource consumption - UPDATED FOR START TIME"""
        if not tasks:
            print("No tasks to visualize!")
            return None
        
        print("\nCreating chart for {} tasks...".format(len(tasks)))
        
        # Calculate the minimum start time
        min_start_time = min(task["start"] for task in tasks)
        max_end_time = max(task["end"] for task in tasks)
        chart_duration = max_end_time - min_start_time
        
        print("Time range: {} to {} (duration: {})".format(min_start_time, max_end_time, chart_duration))
        
        # Organize tasks by type with concurrent separation
        task_lines = self.organize_tasks_by_type(tasks)
        
        # Convert resource data
        resource_values = self.parse_resource_data(resource_data, makespan)
        max_resource = max(resource_values) if len(resource_values) > 0 and max(resource_values) > 0 else 0
        
        # Calculate figure dimensions
        fig_width = max(14, chart_duration * 0.3 + 4)
        fig_height = max(10, len(task_lines) * 0.8 + 6)
        
        # Create subplot: Gantt above, resource below
        fig, (ax_gantt, ax_resource) = plt.subplots(2, 1, figsize=(fig_width, fig_height), 
                                                gridspec_kw={'height_ratios': [3, 1]})
        
        # === GANTT CHART ===
        line_height = 0.8
        
        print("Creating Gantt Chart with {} lines...".format(len(task_lines)))
        
        # Draw tasks
        for line_idx, line_info in enumerate(task_lines):
            y_pos = line_idx
            task_type = line_info['type']
            line_tasks = line_info['tasks']
            line_number = line_info['line_number']
            
            color = self.get_color_for_task_type(task_type)
            
            print("Line {}: {} (Line {}) - {} tasks".format(line_idx + 1, task_type, line_number, len(line_tasks)))
            
            for task in line_tasks:
                # Task bar
                rect = patches.Rectangle(
                    (task["start"], y_pos - line_height/2),
                    task["duration"],
                    line_height,
                    linewidth=1.5,
                    edgecolor='black',
                    facecolor=color,
                    alpha=0.8
                )
                ax_gantt.add_patch(rect)
                
                # Repetition number at the center of the bar
                ax_gantt.text(
                    task["start"] + task["duration"]/2,
                    y_pos,
                    task["rep_number"],
                    ha='center', va='center',
                    fontsize=9,
                    fontweight='bold',
                    color='white' if task["duration"] > 2 else 'black'
                )
        
        # Gantt axes configuration
        ax_gantt.set_xlim(min_start_time, max_end_time)
        ax_gantt.set_ylim(-0.5, len(task_lines) - 0.5)
        
        # Y labels with task names and line number if multiple
        y_labels = []
        for line_info in task_lines:
            task_type = line_info['type']
            line_number = line_info['line_number']
            
            # Count how many lines this task type has
            type_line_count = len([l for l in task_lines if l['type'] == task_type])
            
            if type_line_count > 1:
                y_labels.append("{}_{}".format(task_type, line_number))
            else:
                y_labels.append(task_type)
        
        ax_gantt.set_yticks(range(len(task_lines)))
        ax_gantt.set_yticklabels(y_labels, fontsize=10)
        ax_gantt.invert_yaxis()
        
        # Vertical grid
        for i in range(min_start_time, max_end_time + 1, max(1, chart_duration // 20)):
            ax_gantt.axvline(x=i, color='lightgray', alpha=0.7, linewidth=0.8)
        
        # Remove top and right borders
        ax_gantt.spines['top'].set_visible(False)
        ax_gantt.spines['right'].set_visible(False)
        
        # Titles and labels
        ax_gantt.set_title(title, fontsize=14, fontweight='bold', pad=20)
        ax_gantt.set_xlabel('Time\nResource Utilization', fontsize=12)
        
        # Set X ticks
        if chart_duration <= 25:
            major_ticks = np.arange(min_start_time, max_end_time + 1, 1)
        else:
            step = max(1, chart_duration // 20)
            major_ticks = np.arange(min_start_time, max_end_time + 1, step)
        
        ax_gantt.set_xticks(major_ticks)
        
        # === RESOURCE CONSUMPTION CHART ===
        print("Creating Resource Chart...")
        print("Resource values length: {}, makespan end: {}".format(len(resource_values), makespan))
        
        # Resource data already starts from min_start_time
        print("Resource data interpretation:")
        print("   Resource data starts from time {}".format(min_start_time))
        print("   Resource values length: {}".format(len(resource_values)))
        
        # Debug: Show first few mappings
        print("Time-resource alignment:")
        for i in range(min(10, len(resource_values))):
            actual_time = min_start_time + i
            if actual_time <= max_end_time:
                print("   Time {}: resource = {}".format(actual_time, resource_values[i]))
        
        # Use resource values as-is, they already correspond to the schedule timeframe
        chart_duration = max_end_time - min_start_time + 1
        if len(resource_values) >= chart_duration:
            relevant_resource_values = resource_values[:chart_duration]
        else:
            # Pad with zeros if resource data is shorter than needed
            padding_needed = chart_duration - len(resource_values)
            relevant_resource_values = np.concatenate([resource_values, np.zeros(padding_needed)])
        
        time_points = np.arange(min_start_time, min_start_time + len(relevant_resource_values))
        
        # Bars for resource consumption
        bars = ax_resource.bar(time_points, relevant_resource_values, 
                           width=0.8, color='#4A90E2', alpha=0.7, 
                           edgecolor='black', linewidth=0.5, align='edge')
        
        # Add values above bars for debug/verification
        if chart_duration <= 25:  # Only for small charts
            for i, value in enumerate(relevant_resource_values):
                if value > 0:  # Only if there's consumption
                    ax_resource.text(min_start_time + i, value + 0.1, str(int(value)), 
                                 ha='center', va='bottom', fontsize=8)
        
        # Calculate resource limit intelligently
        if max_resource > 0:
            if max_resource <= 4:
                resource_limit = 6
            elif max_resource <= 6:
                resource_limit = 8
            elif max_resource <= 8:
                resource_limit = 10
            else:
                resource_limit = max_resource + 2
                
            # Highlight any limit violations
            violations = relevant_resource_values > resource_limit
            if np.any(violations):
                violation_times = time_points[violations]
                ax_resource.scatter(violation_times, relevant_resource_values[violations], 
                               color='red', s=50, marker='x', linewidth=3,
                               label='Limit Violations', zorder=5)
        else:
            resource_limit = 6  # Default value if no resource data
        
        # Resource chart configuration
        ax_resource.set_xlim(min_start_time, max_end_time)
        
        # Calculate Y range intelligently
        relevant_max_resource = max(relevant_resource_values) if len(relevant_resource_values) > 0 else 0
        if relevant_max_resource > 0:
            y_max = max(resource_limit + 1, relevant_max_resource + 2)
        else:
            y_max = 7
            
        ax_resource.set_ylim(0, y_max)
        ax_resource.set_xlabel('Time', fontsize=12)
        ax_resource.set_ylabel('Resource Usage', fontsize=12)
        
        # Grid
        ax_resource.grid(True, alpha=0.3, axis='y')
        ax_resource.set_axisbelow(True)
        
        # Remove top and right borders
        ax_resource.spines['top'].set_visible(False)
        ax_resource.spines['right'].set_visible(False)
        
        # Legend for resource limit and any violations
        if relevant_max_resource > 0 and np.any(violations):
            ax_resource.legend(loc='upper right')
        
        # Synchronize X axes perfectly
        ax_resource.set_xticks(major_ticks)
        ax_resource.set_xlim(min_start_time, max_end_time)
        
        # Optimized layout
        plt.tight_layout()
        
        # Save if requested
        if save_path:
            fig.savefig(save_path, dpi=300, bbox_inches='tight')
            print("Chart saved to: {}".format(save_path))
        
        return fig, task_lines
    
    def print_summary(self, tasks, task_lines, makespan, resource_values=None):
        """Prints final summary"""
        print("\n" + "="*60)
        print("GANTT CHART SUMMARY")
        print("="*60)
        
        # Time information
        min_start_time = min(task["start"] for task in tasks)
        max_end_time = max(task["end"] for task in tasks)
        
        for line_idx, line_info in enumerate(task_lines):
            task_type = line_info['type']
            line_tasks = line_info['tasks']
            line_number = line_info['line_number']
            
            # Count how many lines this type has
            type_line_count = len([l for l in task_lines if l['type'] == task_type])
            
            if type_line_count > 1:
                print("\n{} (Line {}) - {} tasks:".format(task_type, line_number, len(line_tasks)))
            else:
                print("\n{} - {} tasks:".format(task_type, len(line_tasks)))
                
            for task in line_tasks:
                print("   |-- {}: {}-{} (duration: {})".format(task['rep_number'], task['start'], task['end'], task['duration']))
        
        # Show concurrent separations
        type_counts = defaultdict(int)
        for line_info in task_lines:
            type_counts[line_info['type']] += 1
        
        print("   * Concurrent separations:")
        for task_type, count in sorted(type_counts.items()):
            if count > 1:
                print("     - {}: {} lines (concurrency detected)".format(task_type, count))
            else:
                print("     - {}: {} line (sequential)".format(task_type, count))

def main():
    parser = argparse.ArgumentParser(description='Generate Gantt Chart with Resource Consumption')
    parser.add_argument('input', nargs='?', help='Input file or command to execute')
    parser.add_argument('-o', '--output', help='Output file for the chart (PNG)')
    parser.add_argument('-t', '--title', default='Task Schedule with Repetitions', help='Chart title')
    parser.add_argument('--exec', action='store_true', help='Execute the provided command')
    parser.add_argument('--stdin', action='store_true', help='Read from stdin')
    
    args = parser.parse_args()
    
    generator = GanttChartGenerator()
    
    # Determine input source
    if args.stdin:
        print("Reading from stdin...")
        input_text = sys.stdin.read()
    elif args.exec and args.input:
        print("Executing command: {}".format(args.input))
        try:
            result = subprocess.run(args.input, shell=True, capture_output=True, text=True, encoding='utf-8')
            if result.returncode != 0:
                print("Execution error: {}".format(result.stderr))
                return
            input_text = result.stdout
        except Exception as e:
            print("Error: {}".format(e))
            return
    elif args.input:
        try:
            with open(args.input, 'r', encoding='utf-8') as f:
                input_text = f.read()
        except FileNotFoundError:
            print("File not found: {}".format(args.input))
            return
        except UnicodeDecodeError:
            try:
                with open(args.input, 'r', encoding='latin-1') as f:
                    input_text = f.read()
            except Exception as e:
                print("Error reading file: {}".format(e))
                return
    else:
        # Use user data as example
        print("Using provided user data...")
        input_text = """Makespan end: 42

Schedule:
Task "Payment_Validation": start=1, end=5
Task "Inventory_Check": start=5, end=9
Task "Inventory_Check" (Rep2): start=5, end=9
Task "Inventory_Check" (Rep3): start=5, end=9
Task "Inventory_Check" (Rep4): start=5, end=9
Task "Shipping_Calculation": start=14, end=24
Task "Shipping_Calculation" (Rep2): start=14, end=24
Task "Shipping_Calculation" (Rep3): start=14, end=24
Task "Shipping_Calculation" (Rep4): start=24, end=34
Task "Order_Confirmation": start=34, end=42

Resource: 4;4;4;4;20;20;20;20;0;0;0;0;0;9;9;9;9;9;9;9;9;9;9;3;3;3;3;3;3;3;3;3;3;2;2;2;2;2;2;2;2;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0"""
    
    # Parse and generate chart
    tasks, makespan, resource_data = generator.parse_output(input_text)
    
    if not tasks:
        print("No tasks found in input!")
        return
    
    # Create chart
    fig, task_lines = generator.create_gantt_chart(tasks, makespan, resource_data, args.title, args.output)
    
    if fig:
        # Parse resource data for summary
        resource_values = generator.parse_resource_data(resource_data, makespan) if resource_data else None
        generator.print_summary(tasks, task_lines, makespan, resource_values)
        
        if not args.output:
            print("\nShowing chart...")
            plt.show()
    
    print("\nCompleted! Makespan end: {}, Tasks: {}, Lines: {}".format(makespan, len(tasks), len(task_lines)))

if __name__ == "__main__":
    main()