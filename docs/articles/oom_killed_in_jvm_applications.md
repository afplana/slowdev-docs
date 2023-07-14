# Understanding and tackling frequent 'OOM Killed' in JVM Applications running on Kubernetes

## Introduction

Recently, we noticed an issue with a Java Virtual Machine (JVM) application running in a Kubernetes environment. The application was experiencing frequent restarts due to an 'Out Of Memory (OOM) Killed' event. This issue was promptly picked up in our dedicated alert channel, necessitating an immediate investigation.

## Understanding the Problem

The first step was to understand the OOM Killed event. This happens when a system process exceeds its memory limit. Memory is one of the resources allocated to a process, and if the process goes over the limit, the kernel kills it to free up memory. In the context of a Kubernetes pod, this leads to its termination, prompting a restart. The OOM Killed state is set by the Linux kernel when a process has been killed due to memory exhaustion.

OOM Killed events present several challenges:

- Unpredictability: The application can run perfectly until it suddenly crashes, creating disruptions, especially for high-availability services.
- System Stability: Frequent OOM errors could impact the stability of the entire system, not just the affected process or application.
- Performance Impact: Running close to the memory limit can cause performance degradation as the system attempts to manage its limited memory resources.
- Data Loss: Depending on the application, an OOM error could result in data loss if data processed in memory hasn't been saved to a persistent store.
- Maintenance Overhead: Frequent crashes create more work for the developer's team, distracting them from focusing on more strategic tasks.

## Detection

Identifying and managing OOM errors can be done through several approaches, each with their unique benefits:

- Application Profiling: Application performance monitoring (APM) tools can help in understanding the memory usage of your applications in real-time. They provide valuable insights into how an application is using resources and where potential issues might lie.
- Alerts: Setting up alerts for critical events such as OOM Killed can help in timely identification and resolution of issues. These alerts can be set up in a variety of channels depending on your organization's preferred communication platform.
- Local Test Execution: Local test executions, particularly under scenarios simulating high memory usage, can help in identifying potential OOM Killed occurrences in a controlled environment before these issues affect the production environment.
- Kubernetes Logs & Events: Kubernetes provides various logging and monitoring facilities that can be used to keep track of pod's resource usage and events. Regular examination of these logs and events can aid in the identification and diagnosis of potential OOM issues.

## Solution: JVM Tuning

JVM Tuning is one way to address OOM Killed events. This involves modifying JVM settings to optimize memory usage. Here's a typical configuration:

- -XX:+UseContainerSupport: Enables improved JVM container support, allowing the JVM to better understand and respect container resource limits.
- -XX:ActiveProcessorCount=2: Sets the number of active processors that the JVM sees, in this case, 2. Despite stating that the number of CPUs is 1, the application can recognize all available in the host.
- -XX:MaxRAMPercentage=45: Specifies that the JVM should use up to 45% of the available RAM as the maximum heap size. This setting helps control the heap size in containerized environments, where the amount of available memory may be limited.
- -XX:G1PeriodicGCInterval=60000: Sets the interval between periodic garbage collections in the G1 garbage collector. Reducing this interval to 1 minute can help manage memory more effectively.
- -XX:MinHeapFreeRatio=15 and -XX:MaxHeapFreeRatio=25: These parameters determine the heap's expansion and reduction in response to the application's memory demand. Adjusting these values can help optimize memory usage.
- -XX:AdaptiveSizePolicyWeight=50: Influences the balance between the time spent in garbage collection (GC) and the time spent in application execution. A higher value (up to 100) means the JVM will favor shorter GC pauses at the expense of application throughput, while a lower value (down to 0) means the JVM will favor application throughput over short GC pauses.
- -XX:InitiatingHeapOccupancyPercent=25: Sets the percentage of heap occupancy at which the G1 garbage collector should start a concurrent marking cycle. In this case, the concurrent marking cycle will start when the heap is 25% occupied.
- -XX:GCTimeRatio=20: Sets the ratio of time spent in garbage collection to the time spent in application execution. In this case, the JVM aims to spend no more than 1/20 (or 5%) of the total time in garbage collection.

## Kubernetes CPU Assignation

In Kubernetes, a CPU allocation corresponds to a virtual CPU (vCPU), which represents the computing power of a single physical core running at full capacity. A pod with a CPU limit can access the computational resources equivalent to one entire core of the host machine. However, the distribution of this CPU allocation could span multiple physical cores due to CPU scheduling managed by Kubernetes and the underlying operating system. Hence, it is critical to correctly assign the CPU resources to your pods to maintain a balance between performance and resource utilization.

## Role of -XX:ActiveProcessorCount

The -XX:ActiveProcessorCount flag informs the JVM of the number of available CPUs. This improves the JVM's ability to manage resources efficiently in a Kubernetes environment, leading to better thread pool strategy, JIT compiler optimizations, and garbage collection tuning, thus reducing the memory footprint.

## Benefits of Tuning GC

Tuning the garbage collection parameters in the JVM can effectively reduce the overall number of threads in use. This not only conserves system resources but also streamlines the application, reducing context-switching overhead and increasing throughput. More efficient memory management, periodic, concurrent garbage collection can lead to smoother, more predictable application performance. The overall effect is a more resilient, efficient, and performant application, better equipped to handle its tasks within its operating environment.

## Conclusion

Dealing with OOM Killed events requires a deep understanding of the application and the environment it's running in, be it a virtual machine, container, or a Kubernetes pod. With this understanding, one can apply various strategies such as application profiling, alerting, local test executions, Kubernetes logs examination, JVM tuning, and proper CPU assignation. These strategies not only help in detecting and addressing OOM Killed events but also contribute to developing a more robust, efficient, and performant application.
