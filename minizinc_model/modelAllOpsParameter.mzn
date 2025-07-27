% Task Scheduling Model using CSP in MiniZinc - UNIFIED COMPLETE VERSION

include "globals.mzn";

% Parameters
int: n_tasks;                          % Number of tasks
int: h_start;                          % Start of time window
int: h_end;                            % End of time window
int: max_resource;                        % Maximum resource available at any time

% 
int: query_time;                       % Specific time to analyze (set to -1 to disable)

% Service information (from model.mzn)
int: n_services;                       % Number of services
array[1..n_services] of string: service_names;  % Service names
array[1..n_tasks] of int: task_to_service;       % Which service each task belongs to

% Task properties
array[1..n_tasks] of string: task_names;        % Task names
array[1..n_tasks] of int: durations;            % Task durations
array[1..n_tasks] of int: resource_reqs;           % resource requirements
array[1..n_tasks] of int: rep_counts;           % Number of repetitions
array[1..n_tasks] of int: rep_delays;           % Delay between repetitions
array[1..n_tasks] of int: max_concurrency;      % Maximum concurrent executions
array[1..n_tasks] of string: task_signatures;   % Task signatures (from model.mzn)

% Number of expanded tasks (including repetitions)
int: n_expanded;

% Mapping from expanded to original tasks
array[1..n_expanded] of int: original_task;     % Maps expanded_idx -> original_idx
array[1..n_expanded] of int: repetition_number; % Maps expanded_idx -> repetition number

% Precedence constraints
int: n_pred;                           % Number of finish-to-start precedence constraints
array[1..n_pred] of int: pred_from;    % Predecessor task index
array[1..n_pred] of int: pred_to;      % Successor task index
array[1..n_pred] of bool: pred_wait_all; % Whether to wait for all repetitions

% Start-to-start precedence constraints
int: n_start_pred;                               % Number of start-to-start precedence constraints
array[1..n_start_pred] of int: start_pred_from;  % Predecessor task index
array[1..n_start_pred] of int: start_pred_to;    % Successor task index
array[1..n_start_pred] of bool: start_pred_wait_all; % Whether to wait for all repetitions
array[1..n_start_pred] of int: start_pred_delays; % Delay between start times


% Decision variables
array[1..n_expanded] of var h_start..h_end: start;  % Start time of each expanded task
array[1..n_expanded] of var h_start..h_end: end;    % End time of each expanded task

% Objective: minimize makespan
var h_start..h_end: makespan;

% Feasibility tracking variable
var bool: is_feasible;

% We'll set is_feasible to false if any constraint violations are detected
constraint is_feasible <-> (
  % Check basic feasibility conditions
  forall(i in 1..n_expanded)(
    durations[original_task[i]] <= (h_end - h_start) /\
    end[i] <= h_end /\
    start[i] >= h_start
  ) /\
  % Check if makespan is reasonable
  makespan <= h_end /\
  % Check resource constraints are not violated
  forall(t in h_start..h_end-1)(
    sum(i in 1..n_expanded where start[i] <= t /\ t < end[i])(
      resource_reqs[original_task[i]]
    ) <= max_resource
  )
);

% Constraints
% 1. End time calculation
constraint forall(i in 1..n_expanded)(
  end[i] = start[i] + durations[original_task[i]]
);

% 2. Makespan calculation
constraint makespan = max(i in 1..n_expanded)(end[i]);

% 3. Finish-to-start precedence constraints
constraint forall(p in 1..n_pred)(
  let {
    int: from = pred_from[p],
    int: to = pred_to[p],
    bool: wait_all = pred_wait_all[p]
  } in
  if wait_all then
    % Find the last repetition of the predecessor
    let {
      int: last_rep_idx = max([i | i in 1..n_expanded where original_task[i] = from])
    } in
    % First repetition of successor must wait for last repetition of predecessor
    let {
      int: first_succ_idx = min([i | i in 1..n_expanded where original_task[i] = to])
    } in
    start[first_succ_idx] >= end[last_rep_idx]
  else
    % First repetition of successor must wait for first repetition of predecessor
    let {
      int: first_pred_idx = min([i | i in 1..n_expanded where original_task[i] = from]),
      int: first_succ_idx = min([i | i in 1..n_expanded where original_task[i] = to])
    } in
    start[first_succ_idx] >= end[first_pred_idx]
  endif
);

% 4. Start-to-start precedence constraints with exact delays
constraint forall(p in 1..n_start_pred)(
  let {
    int: from = start_pred_from[p],
    int: to = start_pred_to[p],
    bool: wait_all = start_pred_wait_all[p],
    int: delay = start_pred_delays[p]
  } in
  if wait_all then
    % Wait for the LAST repetition of predecessor, then apply delay to ALL successor repetitions
    let {
      int: last_pred_idx = max([i | i in 1..n_expanded where original_task[i] = from])
    } in
    forall(succ_idx in 1..n_expanded where original_task[succ_idx] = to)(
      start[succ_idx] >= start[last_pred_idx] + delay
    )
  else
    % Wait for the FIRST repetition of predecessor, apply delay to ALL successor repetitions
    let {
      int: first_pred_idx = min([i | i in 1..n_expanded where original_task[i] = from])
    } in
    forall(succ_idx in 1..n_expanded where original_task[succ_idx] = to)(
      start[succ_idx] >= start[first_pred_idx] + delay
    )
  endif
);

% 5. Repetition constraints
constraint forall(task in 1..n_tasks where rep_counts[task] > 0)(
  % Find indices of all repetitions for this task, stored in a 1-based array
  let {
    array[1..(rep_counts[task]+1)] of int: task_rep_indices = [
      min([i | i in 1..n_expanded where original_task[i] = task /\ repetition_number[i] = rep]) 
      | rep in 0..rep_counts[task]
    ]
  } in
  % Each repetition must start at least rep_delays after the previous one starts
  forall(r in 1..rep_counts[task])(
    start[task_rep_indices[r+1]] >= start[task_rep_indices[r]] + rep_delays[task]
  )
);

% 6. Resource (resource) constraints
constraint forall(t in 0..(h_end - h_start)-1)(
  sum(i in 1..n_expanded where start[i] <= t /\ t < end[i])(
    resource_reqs[original_task[i]]
  ) <= max_resource
);

% 7. Concurrent repetition constraints
constraint forall(task in 1..n_tasks, t in 0..(h_end - h_start)-1)(
  sum(i in 1..n_expanded where original_task[i] = task /\ start[i] <= t /\ t < end[i])(1) <= max_concurrency[task]
);

% Objective - but allow solutions even if not optimal
solve minimize makespan;

% Clean Output
output [
  % Feasibility status - this will always be printed
  if fix(is_feasible) then
    "FEASIBLE\n"
  else
    "UNFEASIBLE\n"
  endif,
  
  % Makespan - only show if feasible
  if fix(is_feasible) then
    "Makespan end: \(makespan)\n\n" ++
    "Schedule:\n"
  else
    "Makespan: UNDEFINED (unfeasible)\n\n" ++
    "=== CONSTRAINT VIOLATIONS DETECTED ===\n"
  endif
] ++
% Show schedule only if feasible
(if fix(is_feasible) then [
  "Task \(task_names[original_task[i]])" ++
  (if repetition_number[i] > 0 then " (Rep\(repetition_number[i]+1))" else "" endif) ++
  ": start=\(fix(start[i])), end=\(fix(end[i]))\n"
  | i in 1..n_expanded
] else [
  "Schedule cannot be generated due to constraint violations.\n" ++
  "Check: time_window=[\(h_start)..\(h_end)], max_resource=\(max_resource)\n" ++
  "Total task durations: \(sum(i in 1..n_expanded)(durations[original_task[i]]))\n"
] endif) ++
["\n\nResource: " ++ concat(t in h_start..h_end)(show(fix(sum(i in 1..n_expanded where 
    fix(start[i]) <= t /\ t < fix(end[i]))(resource_reqs[original_task[i]]))) ++ if t < (h_end) then ";" else "" endif) ++ "\n\n"]++
(if fix(is_feasible) then [
  "\n=== RESOURCE UTILIZATION ===\n",
  "Time\tresource Used\tresource Available\tUtilization (%)\tUtilization (fraction)\n"
] ++
[
  let {
    int: resource_used = fix(sum(i in 1..n_expanded where fix(start[i]) <= t /\ t < fix(end[i]))(resource_reqs[original_task[i]])),
    int: util_percent = if max_resource > 0 then (resource_used * 100) div max_resource else 0 endif,
    int: util_fraction_scaled = if max_resource > 0 then (resource_used * 1000) div max_resource else 0 endif
  } in
  "\(t)\t\(resource_used)\t\(max_resource)\t\(util_percent)%\t0.\(util_fraction_scaled)\n"
  | t in h_start..min(h_end-1, fix(makespan))
] ++
  
[
  "\n=== OVERALL RESOURCE STATISTICS ===\n"
] ++
[
  let {
    int: total_time_steps = min(h_end - h_start, fix(makespan) - h_start + 1),
    int: total_resource_used = sum(t in h_start..h_start+total_time_steps-1)(
      fix(sum(i in 1..n_expanded where fix(start[i]) <= t /\ t < fix(end[i]))(resource_reqs[original_task[i]]))
    ),
    int: max_resource_used = max(t in h_start..h_start+total_time_steps-1)(
      fix(sum(i in 1..n_expanded where fix(start[i]) <= t /\ t < fix(end[i]))(resource_reqs[original_task[i]]))
    ),
    int: avg_resource_used = if total_time_steps > 0 then total_resource_used div total_time_steps else 0 endif,
    int: max_util_percent = if max_resource > 0 then (max_resource_used * 100) div max_resource else 0 endif,
    int: avg_util_percent = if max_resource > 0 then (avg_resource_used * 100) div max_resource else 0 endif
  } in
  "resource Resource Summary:\n" ++
  "  Total Available: \(max_resource)\n" ++
  "  Peak Usage: \(max_resource_used) (\(max_util_percent)%)\n" ++
  "  Average Usage: \(avg_resource_used) (\(avg_util_percent)%)\n" ++
  "  Time Window: [\(h_start)..\(h_end)]\n" ++
  "  Active Time Steps: \(total_time_steps)\n"
] else [
  "\n=== PROBLEM DIAGNOSIS ===\n",
  "Cannot generate resource utilization - problem is unfeasible.\n",
  "Check these potential issues:\n",
  "- Time window too small: [\(h_start)..\(h_end)] (duration: \(h_end - h_start))\n",
  "- resource limit too low: \(max_resource)\n", 
  "- Conflicting precedence constraints\n",
  "- Impossible concurrency requirements\n"
] endif) ++
(if query_time >= h_start /\ query_time < h_end /\ fix(is_feasible) then 
  [
    "\n=== TIME POINT ANALYSIS (t=\(query_time)) ===\n",
    "Active Tasks at time \(query_time):\n"
  ] ++
  [
    let {
      array[int] of int: active_tasks = [i | i in 1..n_expanded where fix(start[i]) <= query_time /\ query_time < fix(end[i])]
    } in
    if length(active_tasks) > 0 then
      concat([
        "  - \(task_names[original_task[i]])" ++
        (if repetition_number[i] > 0 then " (Rep\(repetition_number[i]+1))" else "" endif) ++
        " [\(service_names[task_to_service[original_task[i]]])]" ++
        " [start=\(fix(start[i])), end=\(fix(end[i])), resource=\(resource_reqs[original_task[i]])]\n"
        | i in active_tasks
      ])
    else
      "  No active tasks at this time.\n"
    endif
  ] ++
  [
    let {
      int: total_resource_at_time = fix(sum(i in 1..n_expanded where fix(start[i]) <= query_time /\ query_time < fix(end[i]))(resource_reqs[original_task[i]])),
      int: util_percent_at_time = if max_resource > 0 then (total_resource_at_time * 100) div max_resource else 0 endif,
      int: available_resource = max_resource - total_resource_at_time,
      array[int] of int: active_original_tasks = [original_task[i] | i in 1..n_expanded where fix(start[i]) <= query_time /\ query_time < fix(end[i])],
      array[int] of int: active_services = [task_to_service[t] | t in active_original_tasks]
    } in
    "\nResource Status at time \(query_time):\n" ++
    "  resource Used: \(total_resource_at_time)/\(max_resource) (\(util_percent_at_time)%)\n" ++
    "  resource Available: \(available_resource)\n" ++
    "  Active Task Types: \(length([t | t in 1..n_tasks where t in active_original_tasks]))/\(n_tasks)\n" 
  ]
else 
  if query_time >= h_start /\ not fix(is_feasible) then
    [
      "\n=== TIME POINT ANALYSIS ===\n",
      "Can't analyze time \(query_time) - solution is unfeasible.\n"
    ]
  else 
    if (query_time < h_start \/ query_time >= h_end) then
      if query_time != -1 then
        [
          "\nCan't analyze the proposed time point"
        ]
      else
        [""]
      endif
    else 
      [""]
    endif
  endif
endif);