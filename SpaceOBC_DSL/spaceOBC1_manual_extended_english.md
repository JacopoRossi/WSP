# SpaceOBC1 System Technical Manual
## Operational and Architectural Specification Document

---

## 1. System Introduction

The SpaceOBC1 system represents a complex software architecture specifically designed for the management and control of a space on-board computer (On-Board Computer). This system was conceived to operate in a critical environment where reliability, timing precision, and efficient use of computational resources are fundamental requirements for mission success.

The system architecture is based on a distributed execution model that coordinates multiple specialized services, each responsible for specific operational functions. These services orchestrate the execution of interdependent tasks that must comply with strict timing constraints and well-defined precedence relationships. The critical nature of space operations requires that every system component be designed with particular attention to robustness, redundancy, and the ability to handle anomalous situations.

This document provides a detailed and in-depth description of all aspects of the SpaceOBC1 system, from global parameter configuration to the specification of each individual task, from temporal dependency relationships to resource allocation strategies. The goal is to provide a complete understanding of system behavior, useful both for developers and mission operators.

---

## 2. Global Configuration and Operational Parameters

The SpaceOBC1 system operates within a well-defined time window extending from the initial instant, identified as time zero, up to time unit thirty-three. This operational window of thirty-three time units represents the period during which all scheduled operations must be started, executed, and completed. The choice of this specific duration is closely linked to the requirements of the space mission and the orbital characteristics of the vehicle, ensuring that all critical operations can be completed within the constraints imposed by orbital dynamics and communication windows with ground stations.

From the computational resource perspective, the system has a maximum of eight processing units that can be allocated simultaneously for task execution. This parameter, defined as r_max and set to eight, represents a fundamental constraint for scheduling operations. The availability of eight resources allows a significant degree of parallelism in task execution, enabling the system to effectively exploit the processing capabilities of the on-board computer. However, this constraint also requires careful planning to avoid resource contention situations that could compromise the timely completion of critical operations.

System identification through the name “SpaceOBC1” is not merely nominal, but represents a specific configuration instance within a possible family of on-board control systems. This naming allows this particular configuration to be clearly distinguished from other variants that may be used in different missions or in different operational phases of the same mission.

---

## 3. Modular Service Architecture

The SpaceOBC1 system architecture is structured into seven main services, each designed to manage a specific functional domain of on-board operations. This modular organization enables a clear separation of responsibilities and facilitates both maintenance and system evolution over time.

The **CoreService** represents the foundation of the entire operational architecture. This service, identified with ID 1, has the critical responsibility of managing the system’s fundamental operations through two essential tasks: core initialization (**INIT_CORE**) and communication protocol configuration (**COMM_PROTO**). The importance of this service cannot be underestimated, since virtually all other system operations depend directly or indirectly on the correct completion of its functions. CoreService establishes the necessary operational baseline, configuring essential system components and preparing the communication infrastructure that enables information exchange among subsystems and with ground stations.

The **ControlSyncService**, the second service in the architecture, handles real-time control management and synchronization among system components. Through its two main tasks, **CTRL_EXEC** and **SYNC_PROC**, this service ensures that control operations are executed with the required frequency and precision, and that all subsystems maintain accurate time synchronization. The repetitive nature of these tasks reflects the need for continuous control and periodic synchronization throughout the entire operational window.

The **AnalysisService** represents the third pillar of the architecture and is dedicated to in-depth system data analysis and operational integrity verification. This service coordinates two complementary tasks: **ANALYSIS_FULL**, which performs a complete and detailed analysis of system state, and **VERIFY_QUICK**, which carries out rapid validation checks. Combining deep analysis with quick verification allows the system to maintain an optimal balance between analytical completeness and timely detection of potential anomalies.

The **ProcessingService** manages the entire data processing pipeline through two distinct but closely related phases. The pre-processing phase, handled by the **PREPROCESS_SVC** task, prepares data for subsequent processing by applying transformations, filtering, and normalization. The post-processing phase, handled by **POSTPROCESS_SVC**, completes the process by applying further transformations, aggregations, and preparing final results for use by other subsystems or for transmission to ground.

The **OrbitService** has particular relevance in the context of space operations, as it is responsible for all functions related to orbital control and vehicle orbit management. This service coordinates two specialized tasks: **ORBIT_CTRL**, which performs active orbit control through trajectory calculations and planning of corrective maneuvers, and **ORBIT_MGMT**, which manages broader orbital operations, interfacing with navigation and propulsion systems.

The **MonitorService** provides continuous system status monitoring capabilities through the **MONITOR_SYS** task. The distinctive feature of this service is its ability to run up to three simultaneous instances of the monitoring task, providing redundancy that significantly increases system reliability in detecting and reporting operational anomalies.

Finally, the **SafeService** manages all aspects related to system safety and safe mode procedures through the **SAFE_DIR** task. This service represents the last line of defense in critical situations, implementing the necessary safety directives to protect the spacecraft and ensure mission continuity even in the presence of significant anomalies.

---

## 4. Detailed Description of Operational Tasks

The **INIT_CORE** task, identified by ID 1 and the code “initcor,” represents the starting point of all system operations. With a duration of fourteen time units, this task performs the fundamental initialization of the system core, configuring all essential components required for subsequent operations. During its execution, INIT_CORE prepares the operational environment, initializes core data structures, configures system parameters, and verifies the integrity of critical components. This task requires a single unit of computational resource and can be executed only once, without repetitions, given the one-time nature of its initialization function.

The **COMM_PROTO** task, with ID 2 and the code “comprt,” is responsible for configuring and initializing communication protocols. With a duration of sixteen time units, slightly longer than core initialization, this task establishes all necessary communication channels, configures network protocols, initializes transmission and reception buffers, and verifies connectivity with subsystems and ground stations. Its execution is essential to ensure that the system can reliably exchange information throughout the operational window.

The **CTRL_EXEC** task, identified by ID 3 and the code “ctlexe,” is a critical component for real-time system control. Unlike initialization tasks, CTRL_EXEC has a very short duration of only three time units, but it is configured to execute repeatedly three times with an interval of eight time units between each repetition. This configuration reflects the need to perform periodic control operations throughout the operational window, ensuring that the system continuously monitors critical parameters and can react promptly to deviations from nominal values.

The **SYNC_PROC** task, with ID 4 and the code “synprc,” works in close coordination with CTRL_EXEC to ensure synchronization among subsystems. With an even shorter duration of only two time units, this task is also configured to execute three times at eight time-unit intervals. Its primary function is to ensure that all system components maintain a coherent view of the global state and that distributed operations are effectively coordinated.

The **ANALYSIS_FULL** task, identified by ID 5 and the code “anlful,” performs a complete and in-depth analysis of system state. With a duration of fourteen time units, this task has sufficient time to examine all operational aspects in detail, analyze acquired data, verify subsystem performance, and identify anomalies or deviations from nominal parameters. The full analysis provides a holistic view of system status, essential for informed decision-making regarding subsequent operations.

The **VERIFY_QUICK** task, with ID 6 and the code “verqck,” complements full analysis by providing rapid verification capabilities. With a duration of seven time units, this task performs targeted integrity checks and validation of analysis results, allowing the system to proceed quickly with subsequent operations once data validity and nominal system state are confirmed. VERIFY_QUICK also represents a critical branching point in the operational flow, since its completion enables the start of multiple parallel operations.

The **PREPROCESS_SVC** and **POSTPROCESS_SVC** tasks, with IDs 7 and 8 respectively, form a data processing pipeline. PREPROCESS_SVC, with a duration of thirteen time units, performs all data preparation operations, including filtering, normalization, transformation, and preliminary validation. POSTPROCESS_SVC, with a duration of twelve time units, completes the processing by applying final transformations, aggregations, derived computations, and preparing results in the required format for subsequent use or transmission.

The **ORBIT_CTRL** and **ORBIT_MGMT** tasks, identified by IDs 9 and 10, manage orbit control and orbital operations management respectively. ORBIT_CTRL, with a duration of thirteen time units, focuses on active control aspects, performing trajectory calculations, determining necessary orbital corrections, and planning maneuvers. ORBIT_MGMT, with a duration of fourteen time units, coordinates broader orbit management aspects, interfacing with navigation systems, managing propellant resources, and optimizing overall orbital strategy.

The **MONITOR_SYS** task, with ID 11 and the code “monsys,” provides continuous system monitoring capabilities. With a duration of twelve time units and the ability to run up to three times in parallel, this task is a key element for system robustness. The possibility of running multiple simultaneous instances enables redundant monitoring strategies, significantly increasing the likelihood of timely anomaly detection.

Finally, the **SAFE_DIR** task, identified by ID 12 and the code “safdir,” manages the implementation of safety directives and safe mode procedures. With a duration of twelve time units, this task can be activated when necessary to handle critical situations, implementing safeguarding procedures to protect the spacecraft and ensure mission continuity even under anomalous conditions.

---

## 5. Temporal Constraints and Dependency System

The SpaceOBC1 system implements a sophisticated temporal constraint system based on the concept of start-to-start precedence. This type of constraint specifies that a destination task can begin execution only after a given delay has elapsed since the start of the source task execution. It is important to note that these constraints do not require completion of the source task, but only that the specified time has passed since its start. This feature enables a greater degree of parallelism in execution, optimizing the use of available resources.

The dependency chain begins with the two fundamental initialization tasks: **INIT_CORE** and **COMM_PROTO**. Both tasks act as sources for multiple constraints, reflecting their critical role in system startup. The **CTRL_EXEC** task depends on both INIT_CORE and COMM_PROTO, with a delay of two time units from each. This means that executive control can start only after two time units have elapsed from the start of both initialization tasks, ensuring that the system has had time to configure both core components and communication protocols.

Similarly, the **ANALYSIS_FULL** task also depends on both initialization tasks, but with a longer delay of four time units. This longer delay reflects the fact that full analysis requires the system to reach a more advanced initialization state before starting in-depth analytical operations.

The relationship between CTRL_EXEC and SYNC_PROC illustrates the coordination required between control and synchronization. The **SYNC_PROC** task can start two time units after CTRL_EXEC begins, allowing synchronization to operate in coordination with control operations.

The analysis and verification chain shows a sequential dependency where **VERIFY_QUICK** can start eight time units after ANALYSIS_FULL begins. This substantial delay allows full analysis to progress significantly before rapid verification begins, ensuring that sufficient data is available for verification.

VERIFY_QUICK represents a particularly interesting branching point in the system architecture. Three different tasks depend on its start, all with the same delay of six time units: **PREPROCESS_SVC**, **ORBIT_CTRL**, and **ORBIT_MGMT**. This configuration enables the simultaneous start of three parallel operational paths once quick verification has confirmed data validity and nominal system status. This parallelization is essential to maximize system efficiency and ensure that all critical operations can be completed within the available time window.

The data processing pipeline shows a clear sequential dependency, where **POSTPROCESS_SVC** can start only two time units after PREPROCESS_SVC begins, ensuring that post-processing operates on data already prepared during pre-processing.

Finally, the **MONITOR_SYS** task has a direct dependency on INIT_CORE with a delay of ten time units. This relatively long delay allows the system to complete initial initialization and configuration phases before continuous monitoring begins, ensuring that there is meaningful system state to monitor.

---

## 6. Operational Dynamics and Execution Flow

Execution of the SpaceOBC1 system follows a complex dynamic that can be understood by analyzing the temporal flow of operations. At the initial instant, the system simultaneously starts the two fundamental tasks: **INIT_CORE** and **COMM_PROTO**. These tasks proceed in parallel, each using a single computational resource unit, leaving six resources still available for other operations.

After two time units from the start, the system is ready to launch **CTRL_EXEC**, having satisfied the delay constraints from both initialization tasks. CTRL_EXEC begins its first execution, which will last three time units. Two time units after CTRL_EXEC starts, at time instant four from system start, **SYNC_PROC** can begin its first execution.

Also at time instant four, having satisfied the four time-unit delay constraints from both initialization tasks, **ANALYSIS_FULL** can begin as well. This task, with its significant duration of fourteen time units, will proceed in parallel with subsequent repetitions of CTRL_EXEC and SYNC_PROC.

Repetitions of CTRL_EXEC and SYNC_PROC follow a regular pattern. CTRL_EXEC repeats at time instant ten (2 + 8) and time instant eighteen (2 + 16), while SYNC_PROC repeats at time instants twelve (4 + 8) and twenty (4 + 16). This periodic execution pattern ensures that control and synchronization are maintained throughout the operational window.

At time instant ten from the start, having satisfied the ten time-unit delay constraint from INIT_CORE, **MONITOR_SYS** can begin. Given its ability to run up to three instances in parallel and its duration of twelve time units, monitoring can be configured to provide continuous or redundant coverage depending on operational needs.

Eight time units after ANALYSIS_FULL begins, at time instant twelve, **VERIFY_QUICK** can start. This task, with a duration of seven time units, will complete around time instant nineteen, having verified analysis results and validated system status.

Six time units after VERIFY_QUICK begins, at time instant eighteen, the system can simultaneously start three parallel operational paths. **PREPROCESS_SVC** begins the data processing pipeline, **ORBIT_CTRL** starts orbit control operations, and **ORBIT_MGMT** begins orbit management. This massive parallelization represents a critical moment in system execution, where multiple complex operations proceed simultaneously.

Two time units after PREPROCESS_SVC begins, at time instant twenty, **POSTPROCESS_SVC** can start, completing the data processing pipeline. At this point, the system is operating with a high degree of parallelism, with multiple tasks executing simultaneously.

Toward the end of the operational window, the various tasks complete their executions. POSTPROCESS_SVC, being one of the last tasks in the dependency chain, will complete around time instant thirty-two, shortly before the end of the thirty-three time-unit operational window.

The **SAFE_DIR** task, having no explicit precedence constraints, can be activated at any time during the operational window as needed. This flexibility is intentional, allowing the system to respond quickly to critical situations that may require activation of safety procedures.

---

## 7. Final Considerations

The SpaceOBC1 system represents a sophisticated example of software architecture for critical space applications. Its design reflects a deep understanding of operational requirements, timing constraints, and robustness needs typical of space missions. The balance between parallelism and sequential dependencies, careful management of computational resources, and the presence of monitoring and safety mechanisms demonstrate a mature approach to critical system design.

The modularity of the architecture, with its clear separation into specialized services, facilitates not only system understanding but also future maintenance and evolution. The ability to modify or extend individual services without impacting the entire architecture represents a significant advantage in adapting the system to changing mission requirements or integrating new functionality.
