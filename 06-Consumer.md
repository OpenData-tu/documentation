## Inserting into Elasticsearch

|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|  0.1  | 2017-07-24 | Paul | initial version |

This section is about our consumer component, that takes data items from a queue and inserts them into the main database. Why we decided to do so and what tasks it fulfills will be discussed.


### Requirements
With our architectural design importers push their results to a queue, in our case *Apache Kafka*. From the queue the data items still must be inserted into Elasticsearch. Besides simply taking data from the queue there are some more requirements. Those mainly are:


##### Validate input before inserting 

While designing the ETL-importing pipeline we had the problem, that the output of data-fragments (JSON documents) that are prepared and processed for insertion must be validated previously to inserting. That task is logically linked to the data storage component and not the importing process itself as 

* the ETL-framework should not validate its own outcome (as it or its creator are biased)
* the database should asure, that it is not importing corrupted data-fragments that will break queries etc.

The then logical place to do the validation was the component that first processes the data items after the importers released them.

##### Ability to scale and adjust the configuration according to Kafka's configuration


##### Achieve high performance to not slow down the importing pipeline


##### Allow parallelism for reading from Kafka


##### Allow concurency for processing data read from Kafka

### Implementation of the Requirements
Because of the named reasons we decided to build one component to validate the output and push it - if valid - to Elasticsearch. There would have been the possibility to do this in seperate steps with another queue inbetween aswell. This would have meant a lot higher configurational effort and more resources required so that it seemed good to join both tasks in one component. 

##### Bulk insertion

The most important decision was on how to handle the insertion to Elasticsearch. These requests require an http-connection. If we open and close one http-connection per item inserted, the overhead would be enormous. Therefore we wanted to use Elasticsearch's bulk-insertion feature. The http-requests should aswell be non-blocking and be processed in the background to not halt the execution of the other important tasks, like listening to the queue and validation the data.

##### Achieve high performance and allow validating

In order to fulfill the requirements we went with *Go* as a programming language. The main reasons for that was the outstanding performance and the build in concurrency features, which directly tackled the main requirements. Parallelism, configuration and scalability was achieved independent from the programming language and the consumer itself by deploying it the right way. This will be described in the paragraphs after this about go-specific advantages. 

Although parallelism can be achieved by simply spawning more consumers (see later) it was still very important to maintain a very fast performance within one importer. While reading from a queue, validating and inserting seemed like a typically task for a scripting language, the performance shortfalls of interpreted languages are too high to use one for this time-sensitive task. Needless to say we also discovered time issues with some test-consumers written e.g. in *ruby*. 

For validating the json-items there is the need for a library that handles validation of the used *jsonschema*-format. There is at least one library present for the most relevant programming languages, so this did not limit us in chosing a programming language. 

##### Allow concurency for processing data read from Kafka
This was another main reason to chose *go* as a programming language as concurrency is very well supported by the build-in go-routines. With this we could achieve a procedure that works like this:

* Continuously listen to the Kafka queue for new item on the topic. 
* Directly validating them with a preloaded schema that is already in memory and therefore takes nearly no time
* Asynchronously passing the validated json to another go-routine, that aggregates the items to bulks until
	* The bulk limit is reached or
	* A timeout is triggered (from outside the routine, needed if importing is very slow, or especially for the last items released by the importer)
* the aggregated json is again asynchronously sent to another go-routine, that handles the http connection to Elasticsearch in the background.


##### Allow parallelism, scaling and configuration

Scaling and configuring the consumer would have been possible in any language: scaling is a job solved by the deployment on a kubernetes cluster and configuring it can be done with environment variables and the same deployment component setting them accordingly. Therefore the parallelism required was also not a requirement directly to the consumer itself. 

There are two possibilities to allow parallelized reading from kafka for a data source:

1. Using Kafka's Consumer Groups to allow several consumers reading from one topic
2. Using a topic per importer instance and not per datasource (e.g. when several importers run for several days for a datasource.)

Both of them have been tested by us and both of them have their advantages. As Elasticsearch was the limiting component in an end-to-end importing pipeline by not being able to insert > 5000 records/second with our configuration, we have not been able to do a proper benchmark on how consumer groups behave performance-wise and if it can reach the same performance than using a consumer per importing instance. 

We could not achieve to run an even bigger configuration of Elasticsearch. The consumer therefore supplied a speed that reaches Elasticsearches limits as soon as two of them are run in parallel, which can be evaluated as a succes and reduces the need of a detailed benchmark, which options would be more effective.

The consumer is able to join a consumer-group, which can be configured by environment variables and therefore by the deployment-component. If a datasource needs several consumers for one importer (e.g. having lots of data for an importing interval - which is typically a day - that is produced faster than a consumer can utilize) several of them can be spawned inside one consumer group for that topic. If one importing interval can be processed by one importer but there are several of them run in parallel we can create a topic per importing instance and run a consumer for each. So the consumer in its current state is capable for both options. 

### Benchmarks
