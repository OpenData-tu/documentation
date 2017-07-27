# documentation

This repo is inteded for documenting project-wide topics that do not belong to a specific repo. The final project documentation deliverable will be generated from the contents of this repo.

## Guidelines

Content which is intended to be included in the final documentation deliverable should be included as a markdown file in this repository. Each file represents a section of the final document, so be cognizant of splitting up work in reasonable sections. Also, partition the work into smaller files in cases where you're going to be collaborating with someone else (unless you really enjoy merging). All changes must be documented (see [editing](#editing)).

Development-only documentation should go in the [wiki](https://github.com/OpenData-tu/documentation/wiki).

## Editing

Every document must begin with a version summary, which states **who** added **what** (e.g. which section) **when**.

The following template is proposed:

**Authoriship**

|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|0.1    | 2017-05-16 |Nico Tasche | initial Version
|0.2    | 2017-05-22 |Caffeinated User|Corrected spelling, revised intro paragraph for clarity, added examples, illustrations, and improved layout

# Standadised Structure for Component Chapters

In order to make the documentation look like a single uniform document rather than a collection of 10 documents and after consultation with __Dr. Pallas__, we decided upon a standardised approach to strcture the chapters about the building blocks (components) of our architecture:

* Components Overview/Description (if applicable ___Motivation___)
* Requirements (specific to this component)
* Survey of Existing Solutions (available implementations)
* Evaluation Criteria & Decision-making Process
* Implementation Details
* Evolution of Component during development (Reasons for the Changes)
* Critical Analysis/Limitations
* Future Development/Enhancements


# Documentation Outline

1. Introduction
    1. Project description and goal
    1. Short part about the Open Data movement
1. Competitor Analysis -- rename it to something less business oriented
    * Data Sources
    * EU initiatives
    * Data catalogues like govdata.de
1. Architecture
    1. Description of components -- components = building blocks
    1. Evaluation of components and decision process
    1. Architecture evolution & background on those decisions
1. Infrastructure/ physical architecture
    1. Logging
    1. Deployment
    1. Scheduling (requirements and actual solution)
    1. ...
1. Import Framework
    1. Description of requirements/value
    1. Offered modules/libraries
1. Validation
    1. Reasons for and thoughts about validation
    1. Role of consumer
    1. Architecture
        1. Go Consumer
        2. Logstash
1. Database
    1. Intro to Elasticsearch, what is special about it
    1. Decision process and evaluation !!!
    1. Data model
    1. Query optimization
    1. Limitations
1. Relational Management System -- rename
    1. Reasons For being
    1. Offered functionality
    1. Possible/required extensions if it would be integrated as planned
1. Public-facing API
    1. Perhaps as part of database chapter
    1. Requirements: RESTful, scalable...
1. Data Sourcing
    * How many and what sources did we unlock
    * What data did we collect (temp, pollution...)
1. Benchmarking/Performance tests
    1. How did we benchmark and on what hardware + HW utilization during test
    1. actual numbers, bottlenecks
1. Conclusions
    1. Conclusion of project
    1. Limitations/Drawbacks of architecture
1. Appendices
    1. How to write a data importer
    1. How to deploy
