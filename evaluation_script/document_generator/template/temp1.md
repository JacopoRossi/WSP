# TECHNICAL DOCUMENT
# SpaceOBC1
# Space On-Board Computer System

## Technical Operations Manual
### Architectural and Operational Specification

**Document Code:** DOC-SPACEOBCtemplate-001  
**Version:** 1.0  
**Date:** January 20, 2026  
**Classification:** INTERNAL - COMPANY USE ONLY  
**Status:** APPROVED  
**KNOWLEDGE TRANSFER DOCUMENT**

---

## Revision History

| Version | Date | Author | Change Description |
|---------|------|--------|-------------------|
| 1.0 | 01/20/2026 | Engineering Team | Initial document release |

## Approval Register

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Prepared by | | | |
| Reviewed by | | | |
| Approved by | | | |

---

## Table of Contents

---

## 1. System Introduction

### 1.1 Document Purpose

This document constitutes the complete technical operational specification for the SpaceOBC1 (Space On-Board Computer) system. Its primary purpose is to provide a detailed description of the software architecture, configuration parameters, temporal dependencies, and operational dynamics of the system, in order to support development, maintenance, testing, and mission operations activities.

This document has been prepared with particular attention to knowledge transfer, thus representing a fundamental resource for onboarding new technical personnel and ensuring operational continuity of the system.

### 1.2 Scope of Application

The SpaceOBC1 system represents a complex software architecture specifically designed for the management and control of a space on-board computer (On-Board Computer). The system was conceived to operate in a critical environment where reliability, timing precision, and efficient use of computational resources are fundamental requirements for mission success.

The system architecture is based on a distributed execution model that coordinates multiple specialized services, each responsible for specific operational functions. These services orchestrate the execution of interdependent tasks that must comply with strict timing constraints and well-defined precedence relationships.

### 1.3 Intended Audience

This document is intended for: software engineers responsible for system development and maintenance, mission operators responsible for operational monitoring and control, quality assurance teams for verification and validation activities, training personnel for knowledge transfer programs, and technical management for project activity supervision.

---

## 2. Global Configuration and Operational Parameters

### 2.1 Operational Time Window

The SpaceOBC1 system operates within a well-defined time window extending from the initial instant, identified as time zero, up to time unit thirty-three. This operational window of thirty-three time units represents the period during which all scheduled operations must be started, executed, and completed.

The choice of this specific duration is closely linked to the requirements of the space mission and the orbital characteristics of the vehicle, ensuring that all critical operations can be completed within the constraints imposed by orbital dynamics and communication windows with ground stations.

### 2.2 System Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| System Name | SpaceOBC1 | Unique instance identifier |
| Operational Window (t_max) | 33 t.u. | Maximum operational cycle duration |
| Max Resources (r_max) | 8 | Simultaneous processing units |
| Active Services | 7 | Number of service modules |
| Total Tasks | 12 | Number of operational tasks |

The availability of eight resources allows a significant degree of parallelism in task execution, enabling the system to effectively exploit the processing capabilities of the on-board computer. However, this constraint also requires careful planning to avoid resource contention situations that could compromise the timely completion of critical operations.

---

## 3. Modular Service Architecture

### 3.1 Architecture Overview

The SpaceOBC1 system architecture is structured into seven main services, each designed to manage a specific functional domain of on-board operations. This modular organization enables a clear separation of responsibilities and facilitates both maintenance and system evolution over time.

| ID | Service | Primary Responsibility |
|----|---------|------------------------|
| 1 | CoreService | Fundamental operations management and system initialization |
| 2 | ControlSyncService | Real-time control and component synchronization |
| 3 | AnalysisService | Data analysis and operational integrity verification |
| 4 | ProcessingService | Data processing pipeline (pre/post processing) |
| 5 | OrbitService | Orbital control and vehicle orbit management |
| 6 | MonitorService | Continuous system status monitoring |
| 7 | SafeService | Safety management and safe mode procedures |

### 3.2 Detailed Service Descriptions

#### 3.2.1 CoreService (ID: 1)

The CoreService represents the foundation of the entire operational architecture. This service has the critical responsibility of managing the system's fundamental operations through two essential tasks: core initialization (INIT_CORE) and communication protocol configuration (COMM_PROTO).

The importance of this service cannot be underestimated, since virtually all other system operations depend directly or indirectly on the correct completion of its functions. CoreService establishes the necessary operational baseline, configuring essential system components and preparing the communication infrastructure. INIT_CORE operates for 14 time units while COMM_PROTO extends to 16 time units, both requiring a single computational resource.

#### 3.2.2 ControlSyncService (ID: 2)

The ControlSyncService handles real-time control management and synchronization among system components. Through its two main tasks, CTRL_EXEC and SYNC_PROC, this service ensures that control operations are executed with the required frequency and precision, and that all subsystems maintain accurate time synchronization.

Both tasks are configured for repetitive operation with 3 repeat cycles at 8 time unit intervals. CTRL_EXEC has a brief duration of 3 time units, while SYNC_PROC requires only 2 time units per execution. This repetitive nature reflects the need for continuous control and periodic synchronization throughout the entire operational window.

#### 3.2.3 AnalysisService (ID: 3)

The AnalysisService is dedicated to in-depth system data analysis and operational integrity verification. This service coordinates two complementary tasks: ANALYSIS_FULL, which performs a complete and detailed analysis of system state with a duration of 14 time units, and VERIFY_QUICK, which carries out rapid verification checks in 7 time units.

This combination of deep analysis and quick verification provides a comprehensive monitoring capability, ensuring both thoroughness and responsiveness in detecting potential anomalies. Both tasks require a single computational resource, demonstrating efficient resource utilization.

#### 3.2.4 ProcessingService (ID: 4)

The ProcessingService manages the data processing pipeline through two sequential tasks: PREPROCESS_SVC and POSTPROCESS_SVC. This service implements a classic preprocessing-postprocessing architecture where data undergoes initial preparation before final processing.

PREPROCESS_SVC handles initial data preparation with a duration of 13 time units, while POSTPROCESS_SVC performs final processing operations requiring 12 time units. The pipeline architecture ensures efficient data flow from initial collection through final processing stages, with strict temporal dependencies maintaining proper sequencing. Each task requires a single computational resource.

#### 3.2.5 OrbitService (ID: 5)

The OrbitService is responsible for all aspects of orbital control and spacecraft orbit management through two specialized tasks: ORBIT_CTRL, which performs active orbital control operations, and ORBIT_MGMT, which manages broader orbital operations.

ORBIT_CTRL operates for 13 time units, while ORBIT_MGMT extends to 14 time units, making it one of the longest-duration single-execution tasks in the system. Both tasks require a single computational resource but play critical roles in maintaining the spacecraft's correct orbital position and attitude.

#### 3.2.6 MonitorService (ID: 6)

The MonitorService provides continuous system status monitoring capabilities through the MONITOR_SYS task. The distinctive feature of this service is its ability to run up to three simultaneous instances of the monitoring task, providing redundancy that significantly increases system reliability in detecting and reporting operational anomalies.

With a task duration of 12 time units and requiring only 1 resource per instance, the monitoring function can maintain comprehensive system oversight through parallel execution while consuming minimal computational resources.

#### 3.2.7 SafeService (ID: 7)

The SafeService manages all aspects related to system safety and safe mode procedures through the SAFE_DIR task. This service represents the last line of defense in critical situations, implementing the necessary safety directives to protect the spacecraft and ensure mission continuity even in the presence of significant anomalies.

The SAFE_DIR task has a duration of 12 time units and requires a single computational resource, ensuring that safety procedures can be executed promptly without competing excessively for system resources during critical scenarios.

---

## 4. Detailed Description of Operational Tasks

### 4.1 Complete Task Registry

| ID | Task Code | Service | Duration | Resources | Max Concur. | Rep |
|----|-----------|---------|----------|-----------|-------------|-----|
| 1 | INIT_CORE | initcor | 1 | 14 | 1 | 1 | 0/0 |
| 2 | COMM_PROTO | comprt | 1 | 16 | 1 | 1 | 0/0 |
| 3 | CTRL_EXEC | ctlexe | 2 | 3 | 1 | 1 | 3/8 |
| 4 | SYNC_PROC | synprc | 2 | 2 | 1 | 1 | 3/8 |
| 5 | ANALYSIS_FULL | anlful | 3 | 14 | 1 | 1 | 0/0 |
| 6 | VERIFY_QUICK | verqck | 3 | 7 | 1 | 1 | 0/0 |
| 7 | PREPROCESS_SVC | presvc | 4 | 13 | 1 | 1 | 0/0 |
| 8 | POSTPROCESS_SVC | pstsvc | 4 | 12 | 1 | 1 | 0/0 |
| 9 | ORBIT_CTRL | orbctl | 5 | 13 | 1 | 1 | 0/0 |
| 10 | ORBIT_MGMT | orbmgt | 5 | 14 | 1 | 1 | 0/0 |
| 11 | MONITOR_SYS | monsys | 6 | 12 | 1 | 3 | 0/0 |
| 12 | SAFE_DIR | safdir | 7 | 12 | 1 | 1 | 0/0 |

**Legend:** Duration = time units; Resources = required computational units; Max Concur. = maximum concurrent executions; Rep = repetitions (rc/rd format where rc = repeat count, rd = repeat delay)

A notable characteristic of this system configuration is the uniform resource requirement: all tasks require exactly one computational resource per execution. This homogeneous resource allocation simplifies scheduling and ensures predictable resource consumption patterns. The system can theoretically support up to 8 concurrent task executions, limited only by the maximum concurrency constraints of individual tasks.

---

## 5. Temporal Constraints and Dependency System

### 5.1 Start-to-Start Precedence Model

The SpaceOBC1 system implements a sophisticated temporal constraint system based on the concept of start-to-start precedence. This type of constraint specifies that a destination task can begin execution only after a given delay has elapsed since the start of the source task execution.

It is important to note that these constraints do not require completion of the source task, but only that the specified time has passed since its start. This feature enables a greater degree of parallelism in execution, optimizing the use of available resources. All constraints in this system configuration have wait_all set to false, meaning that dependent tasks can begin after the specified delay from the first execution of repetitive tasks, without waiting for all repetitions to complete.

### 5.2 Dependency Matrix

| Source Task | Destination Task | Delay (t.u.) | Type |
|-------------|-----------------|--------------|------|
| INIT_CORE (1) | CTRL_EXEC (3) | 2 | SS |
| COMM_PROTO (2) | CTRL_EXEC (3) | 2 | SS |
| INIT_CORE (1) | ANALYSIS_FULL (5) | 4 | SS |
| COMM_PROTO (2) | ANALYSIS_FULL (5) | 4 | SS |
| CTRL_EXEC (3) | SYNC_PROC (4) | 2 | SS |
| ANALYSIS_FULL (5) | VERIFY_QUICK (6) | 8 | SS |
| VERIFY_QUICK (6) | PREPROCESS_SVC (7) | 6 | SS |
| VERIFY_QUICK (6) | ORBIT_CTRL (9) | 6 | SS |
| VERIFY_QUICK (6) | ORBIT_MGMT (10) | 6 | SS |
| PREPROCESS_SVC (7) | POSTPROCESS_SVC (8) | 2 | SS |
| INIT_CORE (1) | MONITOR_SYS (11) | 10 | SS |

**Legend:** SS = Start-to-Start (destination task can start after the specified delay from source task start)

### 5.3 Critical Dependency Analysis

The dependency chain begins with the two fundamental initialization tasks: INIT_CORE and COMM_PROTO. Both tasks act as sources for multiple constraints, reflecting their critical role in system startup. INIT_CORE directly enables CTRL_EXEC (after 2 time units), ANALYSIS_FULL (after 4 time units), and MONITOR_SYS (after 10 time units).

COMM_PROTO provides alternative activation paths for CTRL_EXEC and ANALYSIS_FULL, creating redundancy in the initialization sequence.

VERIFY_QUICK represents a particularly interesting branching point in the system architecture. Three different tasks depend on its start, all with the same delay of six time units: PREPROCESS_SVC, ORBIT_CTRL, and ORBIT_MGMT. This configuration enables the simultaneous start of three parallel operational paths once quick verification has confirmed data validity and nominal system status.

The processing pipeline demonstrates tight coupling through the PREPROCESS_SVC to POSTPROCESS_SVC constraint with a minimal 2 time unit delay, ensuring rapid progression through the data processing stages. The control-synchronization relationship between CTRL_EXEC and SYNC_PROC also exhibits this tight coupling with a 2 time unit delay, reflecting the closely coordinated nature of control and synchronization operations.

---

## 6. Final Considerations and Recommendations

### 6.1 Architecture Summary

The SpaceOBC1 system represents a sophisticated example of software architecture for critical space applications. Its design reflects a deep understanding of operational requirements, timing constraints, and robustness needs typical of space missions.

The balance between parallelism and sequential dependencies, careful management of computational resources, and the presence of monitoring and safety mechanisms demonstrate a mature approach to critical system design. The uniform single-resource requirement for all tasks simplifies resource management while the availability of 8 processing units provides substantial capacity for parallel execution.

### 6.2 Modular Architecture Benefits

The modularity of the architecture, with its clear separation into specialized services, facilitates not only system understanding but also future maintenance and evolution. The ability to modify or extend individual services without impacting the entire architecture represents a significant advantage in adapting the system to changing mission requirements or integrating new functionality.

The consistent use of wait_all=false for all temporal constraints provides maximum scheduling flexibility, enabling efficient parallel execution patterns. This design choice reflects a focus on optimizing throughput and responsiveness within the operational window.

### 6.3 Knowledge Transfer Recommendations

For effective knowledge transfer, it is recommended to follow a structured training path that includes: understanding global parameters and the operational window, studying the service architecture starting from CoreService, detailed analysis of individual tasks and their characteristics with emphasis on the uniform resource requirements, mapping temporal dependencies and understanding the start-to-start model with wait_all=false semantics, simulation of operational flow with particular attention to parallelization points enabled by the three-way branching at VERIFY_QUICK, understanding the repetitive nature of CTRL_EXEC and SYNC_PROC and their implications for system behavior, and finally studying safety procedures and the role of SafeService in system protection.

---

## Appendix A: Glossary

| Term | Definition |
|------|------------|
| OBC | On-Board Computer - Spacecraft on-board computer |
| t.u. | Time Unit - Base unit for time measurement in the system |
| r_max | Maximum number of computational resources allocable simultaneously |
| t_max | Maximum duration of operational window in time units |
| Start-to-Start (SS) | Type of precedence constraint based on task start rather than completion |
| wait_all | Constraint flag that when false allows dependent tasks to start after delay from first source execution; when true requires all repetitions to complete |
| Safe Mode | Safety operational mode activated in case of critical anomalies |
| Periodic Task | Task configured to execute multiple repetitions at regular intervals |
| rc | Repeat Count - Number of repetitions for a repetitive task |
| rd | Repeat Delay - Time delay between repetitions of a repetitive task |
| max_c | Maximum Concurrency - Maximum number of concurrent executions allowed for a task |
| Pipeline | Processing sequence where output of one phase becomes input of the next |

---

## Appendix B: Reference Documents

| Code | Document Title | Version |
|------|----------------|---------|
| REF-001 | SpaceOBC1 System Requirements Specification | [To be filled] |
| REF-002 | Interface Control Document - Ground Segment | [To be filled] |
| REF-003 | Verification and Validation Plan | [To be filled] |
| REF-004 | Mission Operations Manual | [To be filled] |

---

**END OF DOCUMENT**
