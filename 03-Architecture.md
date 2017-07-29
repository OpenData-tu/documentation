# Architecutre

**Authoriship**

|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|  0.1  | 2017-07-19 | Oliver, Amer | Working draft |
|  0.2  | 2017-07-28 | Oliver | Tidy up ... |


* Components Overview/Description (if applicable ___Motivation___)
* Requirements (specific to this component)
* Survey of Existing Solutions (available implementations)
* Evaluation Criteria & Decision-making Process
* Implementation Details
* Evolution of Component during development (Reasons for the Changes)
* Critical Analysis/Limitations
* Future Development/Enhancements

## Requirements of the whole platform

- scalability
  - define scalability/ our interpretation of this requirement specifically for our platform
- extensibility
  - define it!
- objective was to create a whole pipeline
  - Collection data from various sources
  - Process/transform the data
  - Store the data persistently
  - Provide the data through a "single" interface
- no usage of cloud/provider specific solutions

## Design decisions

To tackle all of the mentioned requirements, we decided upon the following architecture [image of architecture].
- We traded consistency for availability. (Harvest over yield {{ref}})
- "Decentralized system": To be able to scale the platform horizontally, it has to be distributed. Thus, smaller pieces of the system have to work on different/separate machines. We omitted bottlenecks by picking components that are distributed by design.

### Importers
- Every source is different! Heterogeneous interfaces, different data formats, different protocols
- Sources have specific limitations, e.g. number of requests per specific time slot
- Size and frequency of data points is heterogeneous
- Availability of sources is different
--> Every importer runs as a independent service. All have specific lifecycles (run-time, frequency of execution). Possibility to schedule them independently.
--> Upon finishing the importing task, the running container is terminated to allow for maximal resource utilization.
--> Every importer manages its state independently from the system. If the importer failed completing the importing task, it continues from the last checkpoint.
--> Every importer has a unique name when scheduled to avoid repetition of the same importing job.

### Messaging System

- Messaging enabled the component to decouple the services from each other. We used queue systems to transport and buffer messages to decouple the components even further.
- Used a distributed messaging systems that is capable of handling millions of concurrent requests and is fault-tolerant.
- Autonomous parts can be deployed independently, such that the platform keeps running without interruption in contrast to deploying a monolithic application.
- Choice of open source solutions to ease portability and make it cross-platform

## Evolution of the architecture

- Filebeat got obsolete
- Scheduling handeled by Kubernetes
- Validation and insert into one component
-

## Limitations

- ???

## Future

- Connection from public API to relational system
-
