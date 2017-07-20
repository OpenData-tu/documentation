|Version|Date|Modified by|Summary of changes
|-------|----|-----------|------------------
|0.1    | 2017-05-16 |Nico Tasche | initial Version
|0.2    | 2017-05-22 |Caffeinated User|Corrected spelling, revised intro paragraph for clarity, added examples, illustrations, and improved layout
|0.3    | 2017-07-17 |Oliver Bruski | Added the toc of the documentation

# documentation

This repo is inteded for documenting project-wide topics that do not belong to a specific repo. The final project documentation deliverable will be generated from the contents of this repo.

## Guidelines

Content which is intended to be included in the final documentation deliverable should be included as a markdown file in this repository. Each file represents a section of the final document, so be cognizant of splitting up work in reasonable sections. Also, partition the work into smaller files in cases where you're going to be collaborating with someone else (unless you really enjoy merging). All changes must be documented (see [editing](#editing)).

Development-only documentation should go in the [wiki](https://github.com/OpenData-tu/documentation/wiki).

## Editing

Every document must begin with a version summary, which states **who** added **what** (e.g. which section) **when**.

The following template is proposed:

**Created by:**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;John Smith  
**Date created:**&nbsp;&nbsp;2017-05-01

See top of document!

1. Introduction
    1. Project description and goal
    1. Short part about the Open Data movement
1. Architecture
    1. Description of components
    1. Evaluation of components and decision process
    1. Architecture evolution & background on those decisions
    1. Limitations/Drawbacks of architecture
1. Infrastructure/ physical architecture
    1. Logging
    1. Deployment
    1. ...
1. Import Framework
    1. Description of requirements/value
    1. Offered modules/libraries
    1. Short tutorial/howto ???
1. Database
    1. Intro to Elasticsearch, what is special about it
    1. Decision process and evaluation !!!
    1. Data model
    1. Query optimization
    1. Limitations
1. Relational Management System
    1. Reasons For being
    1. Offered functionality
    1. Possible/reuqired extensions if it would be integrated as planned
1. Data Sourcing
    1. Research of existing/similar work
    1. EU initiatives that failed
      * Data catalogues like govdata.de
      * How many and what sources did we unlock
      * What data did we collect (temp, pollution...)
1. Benchmarking/Performance tests
    1. How did we benchmark and on what hardware + HW utilization during test
1. Conclusions
    1. Conclusion of project
1. Appendices
    1. How to write a data importer
    1. How to deploy

