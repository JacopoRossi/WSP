# Exploratory direct LLM-based test

## Prompt

> Using the attached documentation, generate a complete and executable MiniZinc model for the described workload scheduling problem. I want the results to be clear, and directly useful for implementing the proposed solution.

## Model used

- **ChatGPT:** GPT-5.5

## Evaluation outcomes

### Optimal solution

The generated model produces the same output as the reference solution.

### Non-executable output

The generated MiniZinc artifact could not be executed in the target environment due to errors in the code organization.

### Incorrect output

The generated MiniZinc artifact could be executed, but it produced at least one of the following issues:

- a makespan different from the reference value;
- incorrect start or end times assigned to one or more tasks.
