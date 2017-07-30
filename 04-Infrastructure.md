# Infrastructure

**Authorship**<br/>
Written by Andres

## Overview/Description (if applicable Motivation)

Needless to say, infrastructure plays a critical role in any cloud-based system. Despite the critical nature of the availability of infrastructure to a cloud prototyping

## Requirements

Based on the particular factors discussed, we identified the following points as being important requirements as part of our infrastructure:

1. **Platform agnostic components**: Our infrastructure must be deployable to both public and private clouds. Therefore, making use of provider-specific features was not possible.
1. **Budget**: The choice of cloud provider should allow us to prototype and test in a shoestring budget (US$100 for the whole semester).

In addition, the general requirements for the system with regards to scalability, performance, etc. also apply to this component, as mentioned.

## Survey of Existing Solutions (available implementations)

## Evaluation Criteria & Decision-making Process

###  Cloud Platform

The cloud-agnostic nature of our system would have allowed us to deploy prototypes to any cloud provider to which we had access. Due to the unavailability of cloud resources to our project, however, we had a single choice when it came to deciding on the platform on which to deploy our infrastructure, namely AWS since it was the only platform for which we had credits. Conducting a thorough comparison of cloud platforms which we subsequently wouldn't have been able to use, did not seem like a good use of our time.

### Orchestration



## Implementation Details

### Orchestration

Given its prominence in the cloud arena and the fact that it is open source software, we used Kubernetes for orchestration of cloud components. Having containerized data importers was a requirement from early on in order to accomplish scalability, and Kubernetes supports the creation and monitoring of containers natively. In addition, the building blocks of our architecture such as the queue and the database, which must be guaranteed to be up and running

### Deployment Automation

Due to the very specific constrains that our project found itself in, a disproportionately large portion of the effort went into managing infrastructure. Having no budget meant that whatever infrastructure was deployed had to be immediately torn down after it was no longer needed.

Difficulties notwithstanding, this meant that the automation process for deployemnt got well refined, with robust scripts, and the addition of Kubernetes Operations (kops) and its native support for AWS translated into an even smoother deployment experience.

Spot instances also played an important role in keeping to the budget, and support for these were was integrated into the scripts, which allowed us to monitor and specify the price for spot instances.

## Evolution of Component during development (Reasons for the changes)

## Discussion/Analysis/Limitations



## Future Development/Enhancements
