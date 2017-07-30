# Deployment to a private cloud


**Authorship**<br/>
Writen by Amer<br/>
Proofread & edited by Andres


Taking into the account the requirement to be able to deploy our microservices application to a private cloud, we chose to use Kubernetes as the main platform to deploy and manage our system components. Kubernetes forms an abstraction layer over the cloud provider, so it enabled us to build a system that is truly agnostic to the underlying infrastructure. Kubernetes has extensive tools that make it relatively easy to setup a Kubernetes cluster on the major public cloud platforms such as Amazon Web Services (AWS), Google Container Engine (GKE), and Microsoft Azure. Furthermore, Kubernetes supports OpenStack, which is a free and open source software that can manage hardware resources (storage, networking, and servers) to form a cloud.


## Kops

For this project, we used a modified version of Kops, which is a command line tool that helps to start and manage the network and required nodes on AWS or GKE to run Kubernetes. As we were running on a very limited budget, we had to implement a feature that allowed us to initiate *Spot instances* on AWS, which are considerably cheaper, by passing the maximum price we are willing to pay as a parameter when initiating the infrastructure as follows:

```
    kops create cluster \
    --node-price=0.017 \
    --master-zones=$(MASTER_ZONES) \
    --master-size=r4.large \
    --master-price=0.017 \
    --dns-zone=$(DNS_ZONE)
...
```


# Kops prerequisite to run on AWS

To be able to run Kops against an AWS account, a user name needs to be created and set up with a certain set of permissions (can be found in the official documentation of Kops). Additionally, AWS CLI tools should be installed and setup with the required API credentials using environment variables.
