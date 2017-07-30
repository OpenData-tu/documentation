# Architecutre

**REFERENCES**

[1]Chatzakis, Andreas. Amazon Web Services. ___Architecting for the Cloud: AWS Best Practices___, 2016
[2]Wolff, Eberhard. Microservices: Grundlagen flexibler Softwarearchitekturen. Dpunkt. verlag, 2015.

**Authoriship**

|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|  0.1  | 2017-07-19 | Oliver, Amer | Working draft |
|  0.2  | 2017-07-28 | Oliver | Tidy up ... + bullet points |
|  0.3  | 2017-07-29 | Oliver | Write actual text from bullet points |

## Overview/ Motivation



* loosely coupled components
* microservice architecture
* independent testing

-- Microservices [2]
* Concept is to have different loosely coupled modules
* Each component has one specific tasks that it performs perfectly
* Change one microservice without affecting another one
* unified interface, can be implemented in any programming language
* contrast is a monolithic application -> deployment of whole application as one
* communication though defined interfaces to reduce dependencies
* easily upgrade to new technologies of single component rather than whole system
* indepedently scalable components
* every single component has to be deployed, monitored and operated
* central log aggregation necessary
* ensure availability of services is crucial
* Necessary to automate deployment with a continuous-delivery-pipeline
  * was requirement from the beginning so suited well
  * not able to implement a test environment -.-
  * huge number of services makes it unfeasable to deploy every service manually
* load-balancing through smart routing of requests
* parallel development of software is easily possible
* organisational division of teams -> perfect in our case
* availability and fast communicatio between services must be ensured
* no single person that understands whole system since several languages, styles etc.
* ensure service discovery through a DNS
* stateless components -> state is stored in central storage/db
* docker to abstract it away from hardware


## Requirements of the whole platform

- scalability [1]
  - define scalability/ our interpretation of this requirement specifically for our platform
  - systems are expected to grow over time
  - growth should benefit from economies of scale
  - rather horizontally than vertically (add new nodes to increase performance)
  - stateless application or at least components -> no knowledge about previous requests or state
  - loose coupling -> reduce interdependencies
  - interact using specific technology-agnostic interfaces
  - asynchronous integration through messaging
  - not point-to-point but through intermediate durable storage layer
    - failure of one component has no effect on the other
    - protect less scalable back end service from front end spikes
  - Scaling relational DB is harder than NoSQL
    - application level awareness of sharding and partitioning
    - nosql since we do not need transactions
    - flexible model that seamlessly scales horizontally
    - most nosql databases are designed to partition and shard the data to increase performance and sacrifice consistency
    - asynchronous replication is enough for us
  - no single point of failure
    - replication and redundancy + loose coupling
  - centrelazed logging to audit infrastructure and handle failures
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

## Existing solutions

- AWS reference architectures
* https://github.com/awslabs?utf8=%E2%9C%93&q=refarch&type=&language=
* https://github.com/awslabs/lambda-refarch-iotbackend
* https://github.com/awslabs/lambda-refarch-streamprocessing
* https://github.com/awslabs/ecs-refarch-batch-processing
* http://media.amazonwebservices.com/architecturecenter/AWS_ac_ra_batch_03.pdf
* https://aws.amazon.com/de/architecture/


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

### Database

- NoSQL -> every source is different with some uniform data

## Evolution of the architecture

- Filebeat got obsolete
- Scheduling handeled by Kubernetes
- Validation and insert into one component
- nature of agile projects that the architecture evolves when the developers learn more and more about the specific requierements and domain

## Critical Analysis

- ???

## Future

- Connection from public API to relational system
- nano services and lambda services
