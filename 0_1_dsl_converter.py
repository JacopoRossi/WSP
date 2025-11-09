import re
import sys
import yaml
from typing import Dict, List, Any, Optional

class EnhancedDSLToDZNConverter:
    def __init__(self):
        self.tasks = []
        self.environment_info = {}
        self.precedence_constraints = []
        self.start_constraints = []
        self.services = []
        self.template_values = {}
    
    def set_template_values(self, values: Dict[str, Any]):
        """Set template variable values for substitution"""
        self.template_values = values
    
    def substitute_template(self, text: str) -> str:
        """Substitute template variables in text"""
        if isinstance(text, str):
            for key, value in self.template_values.items():
                text = text.replace(f"{{{{ {key} }}}}", str(value))
        return text
    
    def parse_dsl(self, dsl_content: str) -> Dict[str, Any]:
        """
        Parse DSL content. Supports both YAML-like and custom format.
        Now handles both legacy and new template-based format with services.
        """
        try:
            # Try YAML parsing first
            data = yaml.safe_load(dsl_content)
            
            # Check if it's the new format and normalize it
            if 'wsp' in data:
                data = self._normalize_new_format(data)
            
            return data
        except:
            # Fall back to custom parsing for simpler format
            return self._parse_custom_format(dsl_content)
    
    def _normalize_new_format(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Convert new format to internal representation compatible with DZN generation
        """
        normalized = {
            'project': {},
            'tasks': [],
            'services': [],
            'precedence_constraints': data.get('precedence_constraints', []),
            'start_constraints': data.get('start_constraints', []),
        }
        
        # Handle environment section
        if 'wsp' in data:
            env = data['wsp']
            
            # Extract template values or use defaults
            project_name = self.substitute_template(env.get('name', 'Default Project'))
            h_start = self._extract_numeric_value(env.get('h_start', 0))
            h_end = self._extract_numeric_value(env.get('h_end', 100))
            r_max = self._extract_numeric_value(env.get('r_max', 10))
            
            # Convert to legacy format - only h_start and h_end
            normalized['project'] = {
                'name': project_name,
                'h_start': h_start,
                'h_end': h_end,
                'max_resource': r_max
            }
        
        # Handle tasks section
        if 'tasks' in data:
            for task_data in data['tasks']:
                normalized_task = self._normalize_task(task_data)
                normalized['tasks'].append(normalized_task)
        
        # Handle services section (supports both 'services' and 'machines' keywords)
        services_data = data.get('services', data.get('machines', []))
        if services_data:
            for service_data in services_data:
                normalized_service = self._normalize_service(service_data)
                normalized['services'].append(normalized_service)
        
        return normalized
    
    def _normalize_task(self, task_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Convert new task format to internal representation
        """
        # Extract and substitute template values
        task_id = self._extract_numeric_value(task_data.get('id'))
        name = self.substitute_template(task_data.get('name', f'Task_{task_id}'))
        signature = self.substitute_template(task_data.get('sig', ''))
        duration = self._extract_numeric_value(task_data.get('dur', task_data.get('duration', 1)))
        resource_consumption = self._extract_numeric_value(task_data.get('res_q', task_data.get('resource_requirement', 1)))
        max_concurrency = self._extract_numeric_value(task_data.get('max_c', task_data.get('max_concurrency', 1)))
        repetition_count = self._extract_numeric_value(task_data.get('rc', task_data.get('repetitions', 0)))
        repetition_delay = self._extract_numeric_value(task_data.get('rd', task_data.get('repetition_delay', 0)))
        
        return {
            'id': task_id,
            'name': name,
            'signature': signature,  # New field
            'duration': duration,
            'resource_requirement': resource_consumption,
            'repetitions': repetition_count,
            'repetition_delay': repetition_delay,
            'max_concurrency': max_concurrency
        }
    
    def _normalize_service(self, service_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Convert service data to internal representation
        """
        service_id = self._extract_numeric_value(service_data.get('id'))
        name = self.substitute_template(service_data.get('name', f'Service_{service_id}'))
        tasks_set = service_data.get('tasks_set', [])
        
        # Ensure tasks_set is a list of integers
        if isinstance(tasks_set, list):
            tasks_set = [self._extract_numeric_value(task_id) for task_id in tasks_set]
        else:
            tasks_set = []
        
        return {
            'id': service_id,
            'name': name,
            'tasks_set': tasks_set
        }
    
    def _extract_numeric_value(self, value: Any) -> int:
        """
        Extract numeric value from template string or return as-is if already numeric
        """
        if isinstance(value, str):
            # Try to substitute template first
            substituted = self.substitute_template(value)
            
            # Try to extract number from the result
            if substituted.isdigit() or (substituted.startswith('-') and substituted[1:].isdigit()):
                return int(substituted)
            else:
                # If still contains templates, try to extract from original
                match = re.search(r'\d+', str(value))
                return int(match.group()) if match else 0
        
        return int(value) if value is not None else 0
    
    def _parse_custom_format(self, content: str) -> Dict[str, Any]:
        """
        Parse custom DSL format for backward compatibility
        """
        data = {
            'project': {'h_start': 0, 'h_end': 100, 'max_resource': 10},
            'tasks': [],
            'services': [],
            'precedence_constraints': [],
            'start_constraints': [],
        }
        
        lines = content.split('\n')
        current_task = None
        
        for line in lines:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
                
            # Project/Environment parameters - only h_start, h_end, and max_resource
            if 'h_start:' in line:
                value = self._extract_numeric_value(re.search(r'(\d+)', line).group(1))
                data['project']['h_start'] = value
            elif 'h_end:' in line:
                value = self._extract_numeric_value(re.search(r'(\d+)', line).group(1))
                data['project']['h_end'] = value
            elif any(keyword in line for keyword in ['max_resource:', 'r_max:']):
                value = self._extract_numeric_value(re.search(r'(\d+)', line).group(1))
                data['project']['max_resource'] = value
            
            # Task parsing (support both old and new field names)
            elif line.startswith('- id:') or line.startswith('-id:'):
                if current_task:
                    data['tasks'].append(current_task)
                current_task = {'id': self._extract_numeric_value(re.search(r'(\d+)', line).group(1))}
            elif current_task and 'name:' in line:
                current_task['name'] = re.search(r'"([^"]+)"', line).group(1)
            elif current_task and 'sig:' in line:
                current_task['signature'] = re.search(r'"([^"]+)"', line).group(1)
            elif current_task and ('duration:' in line or 'dur:' in line):
                current_task['duration'] = self._extract_numeric_value(re.search(r'(\d+)', line).group(1))
            elif current_task and ('resource_requirement:' in line or 'res_q:' in line):
                current_task['resource_requirement'] = self._extract_numeric_value(re.search(r'(\d+)', line).group(1))
            elif current_task and ('repetitions:' in line or 'rc:' in line):
                current_task['repetitions'] = self._extract_numeric_value(re.search(r'(\d+)', line).group(1))
            elif current_task and ('repetition_delay:' in line or 'rd:' in line):
                current_task['repetition_delay'] = self._extract_numeric_value(re.search(r'(\d+)', line).group(1))
            elif current_task and ('max_concurrency:' in line or 'max_c:' in line):
                current_task['max_concurrency'] = self._extract_numeric_value(re.search(r'(\d+)', line).group(1))
        
        if current_task:
            data['tasks'].append(current_task)
            
        return data
    
    def validate_data(self, data: Dict[str, Any]) -> bool:
        """
        Validate the parsed DSL data
        """
        if 'tasks' not in data or not data['tasks']:
            print("Error: No tasks found in DSL file")
            return False
            
        required_fields = ['id', 'name', 'duration', 'resource_requirement']
        for task in data['tasks']:
            for field in required_fields:
                if field not in task:
                    print(f"Error: Task {task.get('id', '?')} missing required field: {field}")
                    return False
        
        # Validate time window
        project = data.get('project', {})
        h_start = project.get('h_start', 0)
        h_end = project.get('h_end', 100)
        if h_start >= h_end:
            print(f"Error: h_start ({h_start}) must be less than h_end ({h_end})")
            return False
        
        # Validate services if present
        if 'services' in data and data['services']:
            task_ids = {task['id'] for task in data['tasks']}
            for service in data['services']:
                for task_id in service.get('tasks_set', []):
                    if task_id not in task_ids:
                        print(f"Error: Service {service.get('name', '?')} references non-existent task ID: {task_id}")
                        return False
                        
        return True
    
    def calculate_expanded_tasks(self, tasks: List[Dict]) -> tuple:
        """
        Calculate expanded task arrays for repetitions
        """
        original_task = []
        repetition_number = []
        
        for task in tasks:
            task_id = task['id']
            reps = task.get('repetitions', 0)
            
            # Original task
            original_task.append(task_id)
            repetition_number.append(0)
            
            # Repetitions
            for rep in range(1, reps + 1):
                original_task.append(task_id)
                repetition_number.append(rep)
        
        return original_task, repetition_number
    
    def calculate_task_to_service_mapping(self, tasks: List[Dict], services: List[Dict]) -> List[int]:
        """
        Calculate which service each task belongs to (0 if no service)
        """
        task_to_service = [0] * len(tasks)  # Default to 0 (no service)
        
        # Create mapping from task ID to task index
        task_id_to_index = {task['id']: i for i, task in enumerate(tasks)}
        
        # For each service, mark its tasks
        for service in services:
            service_id = service['id']
            for task_id in service.get('tasks_set', []):
                if task_id in task_id_to_index:
                    task_index = task_id_to_index[task_id]
                    task_to_service[task_index] = service_id
        
        return task_to_service
    
    def generate_dzn(self, data: Dict[str, Any]) -> str:
        """
        Generate DZN content from parsed DSL data
        """
        if not self.validate_data(data):
            raise ValueError("Invalid DSL data")
        
        tasks = data['tasks']
        services = data.get('services', [])
        project = data.get('project', {})
        precedence = data.get('precedence_constraints', [])
        start_constraints = data.get('start_constraints', [])
        
        # Sort tasks by ID to ensure consistent output
        tasks.sort(key=lambda x: x['id'])
        services.sort(key=lambda x: x['id'])
        
        # Basic parameters - use only h_start and h_end
        n_tasks = len(tasks)
        n_services = len(services)
        h_start = project.get('h_start', 0)
        h_end = project.get('h_end', 100)
        max_resource = project.get('max_resource', project.get('r_max', 10))
        
        # Task properties
        task_names = [f'"{task["name"]}"' for task in tasks]
        durations = [task['duration'] for task in tasks]
        resource_reqs = [task['resource_requirement'] for task in tasks]
        rep_counts = [task.get('repetitions', 0) for task in tasks]
        rep_delays = [task.get('repetition_delay', 0) for task in tasks]
        max_concurrency = [task.get('max_concurrency', 1) for task in tasks]
        
        # Service properties
        service_names = [f'"{service["name"]}"' for service in services]
        task_to_service = self.calculate_task_to_service_mapping(tasks, services)
        
        # Calculate expanded tasks
        original_task, repetition_number = self.calculate_expanded_tasks(tasks)
        n_expanded = len(original_task)
        
        # Build DZN content
        dzn_lines = []
        
        # Header with enhanced info
        dzn_lines.append('% Task Scheduling Data File with Services')
        dzn_lines.append('% Generated from Enhanced DSL format')
        dzn_lines.append('% Uses h_start and h_end time window instead of horizon')
        if 'name' in project:
            dzn_lines.append(f'% Project: {project["name"]}')
        dzn_lines.append('')
        dzn_lines.append('')
        
        # Basic parameters
        dzn_lines.append('% Basic parameters')
        dzn_lines.append('')
        dzn_lines.append(f'n_tasks = {n_tasks};')
        dzn_lines.append('')
        
        # Time window parameters (h_start and h_end instead of horizon)
        dzn_lines.append('% Time window')
        dzn_lines.append(f'h_start = {h_start};  % Planning window start time')
        dzn_lines.append(f'h_end = {h_end};      % Planning window end time')
        dzn_lines.append('')
        
        dzn_lines.append(f'max_resource = {max_resource};')
        dzn_lines.append('')
        dzn_lines.append('')
        
        # Service information
        if n_services > 0:
            dzn_lines.append('% Service information')
            dzn_lines.append('')
            dzn_lines.append(f'n_services = {n_services};')
            dzn_lines.append('')
            dzn_lines.append(f'service_names = [{", ".join(service_names)}];')
            dzn_lines.append('')
            dzn_lines.append(f'task_to_service = {task_to_service};  % Which service each task belongs to (0 = no service)')
            dzn_lines.append('')
            
            # Add service details as comments
            dzn_lines.append('% Service composition:')
            for service in services:
                task_list = ", ".join([f"T{tid}" for tid in service.get('tasks_set', [])])
                dzn_lines.append(f'% Service {service["id"]} ({service["name"]}): Tasks [{task_list}]')
            dzn_lines.append('')
        else:
            dzn_lines.append('% No services defined')
            dzn_lines.append('')
            dzn_lines.append('n_services = 0;')
            dzn_lines.append('service_names = [];')
            dzn_lines.append('task_to_service = [];')
            dzn_lines.append('')
        
        dzn_lines.append('')
        
        # Task properties
        dzn_lines.append('% Task properties')
        dzn_lines.append('')
        dzn_lines.append(f'task_names = [{", ".join(task_names)}];')
        dzn_lines.append('')
        dzn_lines.append(f'durations = {durations};')
        dzn_lines.append('')
        dzn_lines.append(f'resource_reqs = {resource_reqs};')
        dzn_lines.append('')
        dzn_lines.append(f'rep_counts = {rep_counts};')
        dzn_lines.append('')
        dzn_lines.append(f'rep_delays = {rep_delays};')
        dzn_lines.append('')
        
        # Max concurrency (always include)
        dzn_lines.append(f'max_concurrency = {max_concurrency};')
        dzn_lines.append('')
        
        # Add signature information if available
        signatures = [f'"{task.get("signature", "")}"' for task in tasks]
        if any(sig != '""' for sig in signatures):
            dzn_lines.append(f'task_signatures = [{", ".join(signatures)}];')
            dzn_lines.append('')
        
        dzn_lines.append('')
        
        # Expanded tasks mapping
        dzn_lines.append('% Set up expanded tasks mapping')
        dzn_lines.append('')
        total_reps = sum(rep_counts)
        dzn_lines.append(f'n_expanded = {n_expanded};  % {n_tasks} original tasks + {total_reps} repetitions')
        dzn_lines.append('')
        dzn_lines.append('')
        dzn_lines.append('original_task = [')
        
        # Format original_task array with enhanced comments
        self._format_expanded_array(dzn_lines, tasks, original_task, 'original_task')
        
        dzn_lines.append('];')
        dzn_lines.append('')
        dzn_lines.append('')
        dzn_lines.append('repetition_number = [')
        
        # Format repetition_number array with enhanced comments
        self._format_expanded_array(dzn_lines, tasks, repetition_number, 'repetition_number', original_task)
        
        dzn_lines.append('];')
        dzn_lines.append('')
        dzn_lines.append('')
        
        # Precedence constraints
        dzn_lines.append('% Finish-to-start precedence constraints (id: 1 for {}, 2 for {}, etc.)'.format(
            tasks[0]['name'], tasks[1]['name'] if len(tasks) > 1 else 'N/A'))
        dzn_lines.append('')
        n_pred = len(precedence)
        dzn_lines.append(f'n_pred = {n_pred};')
        
        if n_pred > 0:
            pred_from = [p['from'] for p in precedence]
            pred_to = [p['to'] for p in precedence]
            pred_wait_all = [str(p.get('wait_all', False)).lower() for p in precedence]
            
            dzn_lines.append(f'pred_from = {pred_from};')
            dzn_lines.append(f'pred_to = {pred_to};')
            dzn_lines.append(f'pred_wait_all = [{", ".join(pred_wait_all)}];  % Don\'t wait for all repetitions')
        else:
            dzn_lines.append('pred_from = [];')
            dzn_lines.append('pred_to = [];')
            dzn_lines.append('pred_wait_all = [];')
        
        dzn_lines.append('')
        dzn_lines.append('')
        
        # Start-to-start constraints
        dzn_lines.append('% Start-to-start precedence constraints')
        dzn_lines.append('')
        n_start_pred = len(start_constraints)
        dzn_lines.append(f'n_start_pred = {n_start_pred};')
        
        if n_start_pred > 0:
            start_pred_from = [p['from'] for p in start_constraints]
            start_pred_to = [p['to'] for p in start_constraints]
            start_pred_wait_all = [str(p.get('wait_all', False)).lower() for p in start_constraints]
            start_pred_delays = [p.get('delay', 0) for p in start_constraints]
            
            dzn_lines.append(f'start_pred_from = {start_pred_from};')
            dzn_lines.append(f'start_pred_to =   {start_pred_to};')
            dzn_lines.append(f'start_pred_wait_all = [{", ".join(start_pred_wait_all)}];')
            dzn_lines.append(f'start_pred_delays = {start_pred_delays};')
        else:
            dzn_lines.append('start_pred_from = [];')
            dzn_lines.append('start_pred_to = [];')
            dzn_lines.append('start_pred_wait_all = [];')
            dzn_lines.append('start_pred_delays = [];')
        
        dzn_lines.append('')
        dzn_lines.append('')
        
        return '\n'.join(dzn_lines)
    
    def _format_expanded_array(self, dzn_lines: List[str], tasks: List[Dict], 
                              array_data: List[int], array_type: str, 
                              original_task_array: Optional[List[int]] = None) -> None:
        """
        Format expanded arrays (original_task or repetition_number) with proper comments
        """
        if array_type == 'original_task':
            # Group by task and format with comments
            dzn_lines.append('  % For each task, list all its repetitions (original + additional)')
            i = 0
            for task in tasks:
                task_id = task['id']
                task_name = task['name']
                reps = task.get('repetitions', 0)
                
                if reps > 0:
                    # Multiple instances
                    values = []
                    for r in range(reps + 1):  # +1 for original
                        values.append(str(task_id))
                    
                    if i + len(values) == len(array_data):  # Last task
                        dzn_lines.append(f'  {", ".join(values[:-1])},       % {task_name} (original + {reps} repetitions)')
                        dzn_lines.append(f'  {values[-1]}                % {task_name}')
                    else:
                        dzn_lines.append(f'  {", ".join(values)},       % {task_name} (original + {reps} repetitions)')
                else:
                    # Single instance
                    if i == len(array_data) - 1:  # Last item
                        dzn_lines.append(f'  {task_id}                % {task_name}')
                    else:
                        dzn_lines.append(f'  {task_id},                % {task_name} (1 instance)')
                
                i += reps + 1
                
        elif array_type == 'repetition_number':
            # Group by task with repetition numbers
            i = 0
            for task in tasks:
                task_id = task['id']
                task_name = task['name']
                reps = task.get('repetitions', 0)
                
                if reps > 0:
                    # Multiple instances with repetition numbers
                    values = []
                    for r in range(reps + 1):  # +1 for original
                        values.append(str(r))
                    
                    if i + len(values) == len(array_data):  # Last task
                        dzn_lines.append(f'  {", ".join(values[:-1])},       % {task_name} (original + reps)')
                        dzn_lines.append(f'  {values[-1]}                % {task_name} (original)')
                    else:
                        dzn_lines.append(f'  {", ".join(values)},       % {task_name} (original + reps)')
                else:
                    # Single instance (original)
                    if i == len(array_data) - 1:  # Last item
                        dzn_lines.append(f'  0                % {task_name} (original)')
                    else:
                        dzn_lines.append(f'  0,                % {task_name} (original)')
                
                i += reps + 1

def main():
    """Main function for command-line use"""
    if len(sys.argv) < 3:
        print("Usage: python enhanced_dsl_to_dzn.py input.dsl output.dzn [template_values.yaml]")
        print("\nExample new DSL format with services (uses h_start/h_end instead of horizon):")
        print("  wsp:")
        print("    name: '{{ project_name }}'")
        print("    h_start: {{ time_start }}")
        print("    h_end: {{ time_end }}")
        print("    r_max: {{ max_resource }}")
        print("  services:")
        print("    - id: {{ service.id }}")
        print("      name: '{{ service.name }}'")
        print("      tasks_set: {{ service.tasks }}")
        print("  tasks:")
        print("    - id: {{ task.id }}")
        print("      name: '{{ task.name }}'")
        print("      sig: '{{ task.signature }}'")
        print("      dur: {{ task.duration }}")
        print("      res_q: {{ task.resource_consumption }}")
        print("      max_c: {{ task.concurrency }}")
        print("      rc: {{ task.repetition_count }}")
        print("      rd: {{ task.repetition_delay }}")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    template_file = sys.argv[3] if len(sys.argv) > 3 else None
    
    try:
        # Read input file
        with open(input_file, 'r') as f:
            dsl_content = f.read()
        
        # Initialize converter
        converter = EnhancedDSLToDZNConverter()
        
        # Load template values if provided
        if template_file:
            with open(template_file, 'r') as f:
                template_values = yaml.safe_load(f)
                converter.set_template_values(template_values)
        
        # Convert
        data = converter.parse_dsl(dsl_content)
        dzn_content = converter.generate_dzn(data)
        
        # Write output file
        with open(output_file, 'w') as f:
            f.write(dzn_content)
        
        print(f"Successfully converted {input_file} to {output_file}")
        # print(f"Generated {len(data['tasks'])} tasks with {len([t for t in data['tasks'] if t.get('repetitions', 0) > 0])} having repetitions")
        
        # if data.get('services'):
        #     print(f"Generated {len(data['services'])} services")
        #     for service in data['services']:
        #         task_list = ", ".join([f"T{tid}" for tid in service.get('tasks_set', [])])
        #         print(f"  - {service['name']}: Tasks [{task_list}]")
        
        # # Show time window info
        # project = data.get('project', {})
        # h_start = project.get('h_start', 0)
        # h_end = project.get('h_end', 100)
        # print(f"Time window: {h_start} to {h_end} (duration: {h_end - h_start})")
        
        # if 'name' in project:
        #     print(f"Project: {project['name']}")
    
    except Exception as e:
        print(f"Error: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()