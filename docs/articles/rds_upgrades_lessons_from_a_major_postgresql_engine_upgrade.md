# Navigating the Complex Terrain of AWS RDS Upgrades: Lessons from a Major PostgreSQL Engine Upgrade

## Introduction

In the evolving landscape of microservices and cloud-native architecture, data management stands as a significant player. When it comes to relational databases, AWS RDS (Amazon Web Services Relational Database Service) offers a managed PostgreSQL service that has made it easier for us to focus on application logic rather than database management. However, like any other managed service, it comes with its set of challenges, particularly when undergoing a major engine version upgrade. This article aims to provide a comprehensive understanding of the technical aspects, lessons learned, and how to mitigate issues during a critical RDS engine upgrade process.

## The Challenge: Upgrading from PostgreSQL 10.11 to 14.7

The major PostgreSQL upgrade on AWS RDS was triggered on my software engineering team after AWS announced deprecation of its PostgreSQL major version 10, starting April 17, 2023. However, the upgrade process was far from smooth for one of our instances that had in fact that engine version; multiple issues surfaced, leading to a compelling need for deeper understanding and preventive strategies.

### Version and Instance Class Compatibility

Our initial attempt to upgrade PostgreSQL from version 10.11 to 14.7 hit a roadblock. AWS RDS threw an error, indicating that our current instance class (db.t2.small) was incompatible with the new PostgreSQL engine 14.7.

*What is an Instance Class (db.t2.small)?*
An instance class in AWS RDS defines the computational and memory capacity of an RDS instance. For the specific db.t2.small instance, it belongs to the T2 class, which is designed to provide a baseline level of CPU performance with the ability to burst to a higher level when needed. This class is generally suitable for low to moderate traffic database use cases. A db.t2.small instance comes with 1 vCPU and 2 GB of RAM, and is often chosen for its balance between cost and performance. However, not all RDS engine versions are compatible with every instance class, hence our initial issue.

*Resolution:*
To resolve this, we searched for compatible versions with engine 14.7 and as a result we switched our instance class to db.t3.micro, which was supose to be fully compatible with PostgreSQL 14.7 according to the AWS documentation. The change was prompted after examining CloudWatch metrics to ensure that CPU and memory usage would remain within optimal levels after the switch, trying to optimize in costs and resources.

### CPU Credit Balancing

After the instance switch to `db.t3.micro`, we experienced some CPU-related issues, specifically concerning CPU credits. AWS T3 instances operate on a CPU credit model, which can lead to throttling when credits are exhausted.

*Let's understand better how credits works in RDS's T-series*
In AWS RDS's T-series instances, CPU credits play a pivotal role in regulating CPU performance. Instances accrue these credits at a consistent rate over time. These accumulated credits can then be expended when the CPU experiences higher activity. If CPU usage remains under a certain baseline level, these credits are banked and remain available for use for up to 24 hours.
Regarding vCPUs, they gather CPU credits at a predetermined rate and utilize them during periods of activity. It's important to note that one "burstable" vCPU doesn't translate into a fixed time period; instead, it varies based on the actual CPU workload encountered.

*The Root Cause of the Issue*
Upon restarting the RDS instance for the modification to `db.t3.micro`, the CPU credit balance was reset. During the initialization phase, our instance consumed CPU slightly over the threshold for accumulating credits. This meant that we didn't actually start accruing credits until a few minutes after the instance had fully initialized. The absence of accumulated credits left us temporarily vulnerable to CPU-related exceptions. Although this issue resolved itself over time as CPU credits began to accumulate, it raised an important consideration for future instance modifications: always factor in CPU credit behavior, especially when restarting instances. In hindsight, closely monitoring the credit balance during the changeover period would have provided a clearer picture of what to expect in terms of CPU performance.

Understanding CPU credit balancing, how it was impacted by instance restarting, and its overall behavior was a key takeaway from this exercise. It's an often-overlooked aspect that can have a substantial impact on the performance and reliability of your RDS instances.

### Service Latency and Downtime

Both the instance class modification and the major PostgreSQL engine update led to a cascade of issues affecting our services. We observed latencies spiking up to 5 seconds in services that were data consumers of the affected database. Complicating matters further, the database was offline for approximately two minutes, causing Kubernetes pods to exceed memory and CPU limits, which subsequently led them to fail. This downtime activated a series of alarms and led to message backlog within our RabbitMQ system.

*Mitigation:*
For latency-sensitive applications, it's essential to design services to operate gracefully during database downtimes. Employing the circuit breaker pattern, as was done by my team, can help isolate failures and prevent them from cascading. It's also wise to configure appropriate timeout settings for your database calls, so your services can exit bad states more quickly. Prepare for the ability to horizontally scale your Kubernetes pods dynamically based on CPU and memory usage metrics.

*Communication*
On-Call Team Alert: Ensure that your on-call team is aware of the planned changes and understands the potential issues.
Product Team Engagement: Involve the product team in the process and brief them on the possible impacts during downtime. This enables them to prepare for customer inquiries and to evaluate the impact more accurately.

## Performance Optimization and Monitoring

### PGHero

After the upgrade, we lost visibility in PGHero. PGHero is a performance dashboard for Postgres that enables you to monitor your database's performance. The issue was due to the fact that during a major PostgreSQL upgrade, extensions and indexes aren't automatically updated so that has to be done manually afterwards.

*Resolution:*
After running a series of SQL commands to update extensions and perform a full table analysis, PGHero was back online and the database performance restored.

## Lessons Learned

- Thorough Planning: Understand version and instance class compatibility before undertaking a significant upgrade.
- Resource Monitoring: Continuously monitor CPU and Memory metrics.
- Failover Strategies: Implement robust error-handling and failover mechanisms.
- Update Related Components: Remember to update extensions, indexes, and other dependent components after major database upgrades.
- Testing: Always run comprehensive tests on a staging environment similar to production before carrying out major upgrades.
- Communication: Never skip communication of changes that might affect customer by simple they look.

## Conclusion

Upgrading a managed PostgreSQL instance on AWS RDS involves navigating through a maze of instance types, CPU credit balances, and application-level issues. A meticulous approach, grounded in understanding and planning, can make the journey far less daunting. Happy upgrading!
