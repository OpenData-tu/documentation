# Authorship

|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|  0.1  | 2017-07-20 | Paul | initial version|

# Relational Web Management Platform

We decided to have a separate system component to manage the metadata of data-sources that shall be imported and that already have been or are ongoingly imported. This system shall fulfill several tasks that are important for organizing the importing/ETL-process. Furthermore it provides imortant information to several other system components. 

In this chapter we will discuss why we decided to include such a system, what it was build for and how we achieved this. 


## Purpose of the System

This main purposes of the system are: 

* The user registering and describing a datasources that is going to be imported
* Providing this metadata information regarding the datasources to other system-components 
* Provide users that want to import data with information about units
* Enabling visitors or users, that want to use the data that exists (and not import new data), to see the listed resources our system contains

### Registering Sources
To each datasource there is important information and metadata that must be known to our system before importing the datasource. This information must be known upfronta, does only contain metainformation about the sources and has no direct relation to actual measurement-data and is quite static and does not change over time. Therefore we chose not to manage it in the same database as the saved extraced and transformed datapoints of the sensor-data-sources, but have a separate system. With this we can tweak the data-storage component for providing and fullfilling its main tasks and do not mix up meta-information and actual sensordata in one place.

Meta-Information that has to be provided to our system prior to importing for several reasons are mainly:

* Name of source
* The startdate, from which on the source provides data
* if the source is still active (data is being appended to the source in the future). 
  * If not so: the end date of measurements
* Under what license the data is published

Additionally we ask the user to give additional information, that is useful for our system

* If the datasource is still active: At what schedule is new data published
* A *slug* that can be used as an id within our pipeline and in ElasticSearch
* Which measurements the data source provides (which actual measurements the data-sources collects)
* The location of the docker container as URL

### Provide information to other system-components

#### Provide Validation Schema
As described in the chapter about validation and inserting to ElasticSearch we have a distinct component, seperated from the importers, that will handle the validation of the outcome of those. This schema has to be provided. The actual schema itself is fixed and could be hardcoded to the validator, without need to make another http-request. 

Because of two reasons we decided that this would be a bad idea:

* In order to validate datasource-dependent information in the outcome is correct as well, there are dynamic contents within the validation schema (mostly the id of the data source to prevent insertion with the wrong id)
* If the schema changes over time, correcting information hardcoded within the validator would need a complete redeploy and change of the validator as such

Therefore we needed a place where said validation-schema can reside. The web management system seemed to be the right pace for that, as it caries metainformation about datasources anyways and the datasources are registered there and so it would be easy to provide the relevant information aswell. So the management system provides an api call to supply the validation schema to the validators that looks like this:

```
GET /data_sources/:id/validation_schema
```



#### Provide Information to Elastic Search API for query optimization

Like desdcribed in the section about our data model and Elasticsearch as a data-storga-component our data-model is datasource-based and not measurement based. For certain types of queries that tackle measurements it will though be important to have further information on the connection between data sources and measurements.

As there where several possibilities where this information could be stored and managed, the easiest to start with was in our opinion, that the implementer of an importer provides this information to us, when registering his datasource. The user therefore has to mark what measurements a datasource contains upfront. 

In order to optimize querying our data this information is provided to the API that wraps the search interface of Elasticsearch via an API itself. The information is stored in an indexed join table that holds this n-to-n mapping between measurements and datasources. As you can see in the class diagram of the relational system, queries in both directions are provided: getting all measurements, a datasource provides and getting all datasources that have aa given measurement. The corresponding roues look like this:

```
GET /data_sources/:id/measurements
```

```
GET /measurements/:id/data_sources
```
// TODO: example response



#### Provide configuration information to the importer-deployment-component
As the registering should be at best the only step, in which the implementer has to provide information to our system besides providing the importer itself it should preferably cover all information needed to get an importer running. 

## Architectural Details


### Future Improvements


## Unit System

### Units 

### Measurements


### Managing units and measurements
