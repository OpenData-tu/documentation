# Authorship

|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|  0.1  | 2017-07-19 | Oliver, Amer, Andres | Working draft |
|  0.11  | 2017-07-20 | Paul | Motivation |

# Introduction

## Summary/Overview/Abstract

## What was the purpose of the project

* Economic & social value "through creative and innovative combination, analytics, visualization,"
* "Just drop your data"
* Accessible through a uniform interface

## Motivation
In times of a completely connected world, the internet and public access to much information there is also an increasing number of open source projects and open data sources, available to the world. Besides the big amount of available open data, in the same time knowledge-sharing has increased. Many groups of technically interested people gathered together to exchange their ideas and knowledge to produce data themselves decentralized and share that information with the world. 

While there is lots and lots data available of all different types and sources, from official authorities to independent enthusiasts, there is a lack of a standardization to define a certain way, how data should be measured, processed, represented, saved and made available for the public. While there are efforts by authorities to achieve such things, e.g. by the EU with different approaches, none of them has yet become an actual used standard. Often it is only with very much effort achievable to find open data that is there, although it shall be accesible. In addition most of the time the data you can find is scoped to e.g. the area/region/state/country where it was raised, it's research area/subject it is part of etc. 

We therefore wanted to build a prototype, that tries to implement these issues. 

* Providing a platform, that saves and manages all type of open (sensor-)data.
* Providing a framework alongside with it, that offers an easy extensible way, to unlock new datasources and import them to the system
* Providing an interface to insert new data, if not using our framework, aswell
* Offer easy to access interfaces for accessing the data in all possible ways

All of this with the prerequisite that all of this can be also deployed on a private cloud by everyone. Therefore the system shall not rely on proprietary systems e.g. of cloud providers, nor make use of arbitrary systems 


(initial notes:

  - Interfaces, data formats vary greatly, making it prohibitively expensive for new projects to tackle
  - Just a prototype)

## Requirements
* Backend (DB + APIs)
* Extensible framework for importing data from multiple sources, following multiple approaches (connectors, repeated import, ad-hoc upload) platform
* Infra
  - Portability: Deployable on public and private clouds
* Scalability + Performance
  - Cloud means no monolith
  - Ability to handle extremely high demands on the database (cross-index queries)
    * Imagine the app will become so successful that everyone in the world will be on it
    * Create your own Applications against our REST API
  - In sort, THINK BIG

## What is Open Data

> “Open means anyone can freely access, use, modify, and share for any purpose (subject, at most, to requirements that preserve provenance and openness).”

> “Open data and content can be freely used, modified, and shared by anyone for any purpose”
http://opendefinition.org/

> * Availability and Access: the data must be available as a whole and at no more than a reasonable reproduction cost, preferably by downloading over the internet. The data must also be available in a convenient and modifiable form.
* Re-use and Redistribution: the data must be provided under terms that permit re-use and redistribution including the intermixing with other datasets.
* Universal Participation: everyone must be able to use, re-use and redistribute - there should be no discrimination against fields of endeavour or against persons or groups. For example, ‘non-commercial’ restrictions that would prevent ‘commercial’ use, or restrictions of use for certain purposes (e.g. only in education), are not allowed.
http://opendatahandbook.org/guide/en/what-is-open-data/

### Non-static environmental data
- The large majority of open data out there is static.
Lots of environmental data on discrete datasets, but there is no connection between data "snapshots" from different time periods, which nonetheless belong to the same dataset or are semantically equivalent.

> Living data are data that are in use of that are (re-) usable for human beings and machines. In other words, living data are information with a distinct semantics in a considered context, that are valid within a distinct period, that are available and accessible, and hence, that are (re-) usable {{ref}}"Living Data is the Future" Dankwort, Werner; Hoschek, Josef

## Time, Team, Technologies

* Kickoff: Apr 27
* /1 feedback session
* Interim presentation: Jun 1
* /2 feedback sessions
* Final presentation: Jul 13

Total working days (minus holidays)

### Team

Highly diverse team of 7 master's students. Diversity and heterogeneity on many factors: nationality (and by extension native languages), amount of previous professional experience,
* English was the lingua franca for team communication

### Development processes
* stripped-down Scrum approach
* Sprint on every Thursday
* Interim meetings on Mondays
* Everyone holds the role of a product owner
* Populate backlog on the fly

### Tools
* Source Control
* Issue tracking
* Communication
* Calendar
* Document Sharing
