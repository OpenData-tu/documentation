## Inserting into Elasticsearch

|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|  0.1  | 2017-07-24 | Paul | initial version |


### Requirements

* Validate input before insert
* Ability to adjust according to Kafka's configuration
* Achieve high performance to not slow down the importing pipeline
* Allow parallelism for reading from Kafka
* Allow concurency for processing data read from Kafka

### Functionality

#### Reading From Kafka

#### Validation

#### Insertion

##### Bulk insertion

### Benchmarks

#### Speed of one consumer

#### Having several consumers