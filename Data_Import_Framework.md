|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|  0.1  | 2017-07-20 | Rohullah, Jawid | Working draft |


# Extensible Data Import Framework
## Framework Description
The data import framework which is required for our Open Data Platform shall be in way that covers several use cases such as:
* user can add new data source to import data with minimal effort for coding and configurations.
* providing various functionalities to the user like processing data into customized format/ schema
* many reusable components for reading, processing and writing data
* ideally the framework maybe provided as a start application which doesn't require to build every time from the scratch.     

## Framework Requirement
- Easy to extend
    - add new sources
    - custom process of extracted data
    - Reusable components
      - Modules/ libraries
    - Well known data format support
    - Micro service - not monolithic
    - Logging functionalities
    - Unit Conversion

## Implementation of the Framework
- Comparison of Viable Data Import Frameworks
    - Spring batch
    - Java EE
    - Easy batch
    - Summer Batch
- Why Spring Batch
  - Ready to use
  - popular with large community of users
  - with popular language (Java)
  - familiarity of most project members    
    
## Framework Structure/ Architecture
   - BatchConfiguration
      - Batch jobs
        - Step
          - Reader
          - Processor: create json schema with received object  
          - Writer: write to queue
    - @SpringBootApplication
    - @EnableBatchProcessing
    - @EnableTask
    - Library (Module)
      - ServiceConfiguration: all services are registered as Beans for re-usability
        - ApplicationService
        - JsonItemWriter
        - KafkaRecordProducer


## Framework features  
  - Modules with pre-provide utility classes
  - Utility classes
    - just import and use
  - Independent Cloud Tasks as Micro services
## Framework Strengths
  - Usability
    - Reusable, ready to use functionalities
  - Extensibility
    - Ability to add custom utilities
    - Easy to add new jobs

## Supported Data Formats
  - REST Interface
  - DSV
    - CSV
    - TSV
  - XLS
  - XLXS
