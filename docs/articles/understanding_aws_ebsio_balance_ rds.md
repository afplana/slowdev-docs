# Understanding AWS EBSIOBalance% for RDS

During an unfortunate incident where one of my company's services EBSIOBalance% plummeted to 0%, questions arose about how exactly AWS calculates this critical metric for RDS. What seemed like a straightforward issue turned out to be far more complex, underscoring the need for a deep dive into this topic.

## What is EBSIOBalance%?

Firstly, it's important to understand that EBSIOBalance% is an AWS metric that represents the available I/O credits for an Elastic Block Store (EBS) volume. These I/O credits are consumed when reading or writing data to an EBS volume and are replenished over time. When the EBSIOBalance% drops significantly, it signals that the available I/O credits are being used up rapidly, leading to degraded performance. The EBSIOBalance% metric reports state information, not a rate of change. 100% indicates a full bucket of I/O credits, while 0% signifies an empty bucket.

## Delving Deeper

Further exploration revealed that even when the total IOPS (input/output operations per second) utilised by the workload do not exceed the provisioned IOPS limit, the IO balance can still drop to 0% due to uneven workload distribution or bursty I/O patterns. When I/O operations are concentrated in a specific range of the EBS volume's provisioned IOPS capacity, leaving other areas underutilised, the IO balance can deplete to 0%. This scenario means a portion of the provisioned IOPS capacity is idle while another portion is heavily utilised, leading to IO balance issues.

This issue, often termed as 'IO Hotspots,' can cause significant performance degradation. Unfortunately, mitigating this issue is not straightforward. It requires optimisation of the storage use to avoid such EBS IO Hotspots, but a direct and foolproof method to achieve this is not readily available.

Interestingly, it was noticed that upgrading the instance type seemed to mitigate the issue, at least temporarily. This fact raised more questions than it answered. How does upgrading the instance alleviate the problem if it was due to IO Hotspots?

## Key Insights from AWS

In response to these questions, AWS provided crucial insights. The service provider clarified that a database's baseline IOPS are determined by the instance level baseline and the volume level. In the incident under discussion, the IOPS were hitting almost 8K, depleting the instance level IOPS, not the 12K IOPS at the volume level as was previously thought.

The confounding factor here is that one might assume from looking at the current Read/Write IOPS that the 12K provisioned IOPS, or even the 10K instance IOPS, is excessive. Yet, in reality, the situation shifted from 8K IOPS to 2K IOPS due to a larger instance size.

## Navigating Confusion

The relationship between the instance size and IOPS can be tricky. Larger instances can handle more IOPS, but they also produce less IOPS due to their greater RAM. This inverse relationship can cause confusion when it comes to configuring and understanding the performance metrics.

One suggestion to alleviate this confusion would be for AWS to display the instance's IOPS in the RDS configuration panel alongside the volume's Provisioned IOPS. This information would help users make more informed decisions about their infrastructure and avoid potential pitfalls related to IOPS and instance size.

In summary, understanding AWS's calculation of EBSIOBalance% for RDS requires a deep understanding of the relationship between instance sizes, provisioned IOPS, and workload distribution. Awareness of these nuances can help users better optimise their AWS infrastructure and ensure the smooth functioning of their services.
