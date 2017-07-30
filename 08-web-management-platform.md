# Data Source Metadata Management System

**Authoriship**
Written by Paul Wille<br/>
*Proofread & edited by Andres*

We decided to have a separate component to manage the metadata about data sources which are imported to the system. This component shall fulfill several tasks that are important for organizing the ETL process. Furthermore, it provides important information to several other system components.

In this chapter we will discuss why we decided to include such a component, what it was built for, and how it was realized and implemented.


## Purpose

The main purpose of the component is to:

* serve as a registry of data sources in the system,
* provide data source metadata to other components in the system,
* provide users with information about units of measurement,
* enable users who want to use the data to see the resources our system contains


### Data Sources Registry

Before data from a given source can be imported, important information about the source must be made available to our system. This information consists of static metainformation and has no direct relation to actual data being provided in the source.

We chose not to store it in the same database as the actual sensor measurement data, but have a separate system instead. This provides isolation between our sources and the database, preventing changes in the choice of database or its schema from having any effect in how we store and maintain data sources.

The metainformation that has to be provided to our system prior to importing mainly consists of:

* Name of the source
* Start date from which the source provides data
* Whether the source is still active (i.e. data is actively being provided by the source).
  * if not, the end date (last date for which data was provided).
* Under what license the data is published

Additionally we ask the user to provide additional information, which is useful for our system:

* If the data source is still active, at what schedule is new data published
* A *slug* that can be used as an id within our pipeline and in Elasticsearch
* The measurements provided by the data source (which actual measurements the data source collects)
* The URL location of the Docker container to be executed to import the data.

![Registering a data source within the Web management platform](images/new_datasource.png)


### Provide information to other system components

#### Validation Schema

As described in the chapter about validation and insertion into Elasticsearch, we have a separate, distinct component that is responsible for validating the output from data importers.

To achieve this, a schema must be provided against which to validate. Since this schema itself is fixed, it could be hardcoded into the validator, without the need to make another HTTP request. We decided that this would be a bad idea for the following reasons:

* Sanity-checks: in addition to schema-only validation, the schema provided by this component can validate data-source-specific values (such as importer IDs, etc.), which could not be validated with a generic validator.
* Version management: schema changes over time would require changing the information hardcoded within the validator, and completely rebuilding and redeploying the validator component itself. Updating a record inside this component is far simpler than redeploying infrastructure, which is inherently more complex in an era where no downtime is expected.

Therefore we needed a place where said validation schema can reside. The web management system seemed to be the right pace for that, as it already carries metainformation about data sources and the data sources are registered there. So it is easy to provide the relevant schema information as well. The management system provides an API call to supply the validation schema to the validators which looks like this:

```
GET /data_sources/:id/getValidationSchema
```

The response looks like as follows (note that the const `source_id` would be replaced by the ID of the data source):

```
{
  "$schema": "http://json-schema.org/schema#",
  "title": "Data Source",
  "description": "A Data Source for Open Sensor Data from the CP project at TU Berlin. ",
  "type": "object",
  "properties": {
    "source_id": {"const": "source_slug"},
    "device": {"type": "string"},
    "timestamp": { "type": "string", "format": "date-time" },
    "timestamp_data": { "type": "string", "format": "date-time" },
    "location": {
      "type": "object",
      "properties": {
        "lat": {"type": "number",
                "exclusiveMaximum": true,
                "exclusiveMinimum": true,
                "maximum": 90,
                "minimum": -90
               },
        "lon": {"type": "number",
                "exclusiveMaximum": true,
                "exclusiveMinimum": true,
                "maximum": 180,
                "minimum": -180,
               }
      },
    "required": ["lat", "lon"]
    },
    "license": {"type": "string"},
    "sensors": {
      "type": "object",
      "items": [
      {
        "type": "object",
        "properties": {
          "sensor": {"type": "string"},
          "observation_type": {"type": "string"},
          "observation_value": {"type": "number"}
        }
      }]
    }
  },
  "required": ["source_id", "timestamp","sensors", "location", "license"]
}
```

#### Provide Information to the Elasticsearch API for query optimization

As described in the data model section, our model is data-source-based and not measurand-based. For queries spanning across measurands, it will be necessary to have further information about the relationship between data sources and measurands.

As there were several possibilities as to where this information could be stored and managed, and how it would be provided, the easiest place to start with in our opinion was with the implementer of an importer, since he or she must provide information to us when registering the data source. The user therefore has to mark what measurements a data source contains upfront. (// TODO ref figure new data source)

In order to optimize querying, this information is provided to the API that wraps the search interface of Elasticsearch via an API itself. The information is stored in an indexed join table that holds the mapping between data source and the measurands it contains. As you can see in the class diagram (//TODO ref figure) of the relational system, queries in both directions are provided: getting all measurands for a data source, and getting all data sources that contain a given measurand. The corresponding routes look like this:

```
GET /data_sources/:id/measurements
```
Example:

```
GET /data_sources/blume_messnetz/measurands

[
	{"id":1,"name":"Air Temperature","desc":"","unit_category_id":"temperature"},
	{"id":3,"name":"Air Humidity","desc":"amount of water vapor present in the air","unit_category_id":"humidity"}
]
```

```
GET /measurements/:id/data_sources
```
An example request would look like following

```
GET /measurements/1/data_sources

[
	{"id":1,"slug":"blume_messnetz","license":""},
	{"id":5,"slug":"german_weather_service","license":""}
]
```

#### Provide configuration information to the deployment component

Since the importer registration the only step in which the implementer has to provide information to our system, it should cover all configuration information needed to get an importer running.


## Requirements

In contrast to nearly every other component we had to implement, the management platform did not have to meet as many criteria as a distributed cloud system in general. The data it contains is quite static and the number of requests that we expect is also quite low.

* Availability to other system components, that require the held information
* Quick response time (for query-optimization within the public search API)
* Ability to run asynchronous background tasks (for scheduling)


## Architectural Details

The system was built using *Ruby on Rails* with *PostgreSQL* as a database. The reasons why we chose to use Rails are:

* Relatively fast development of an MVC web application
* Well established (over a decade), has therefore lots of resources &mdash; also for all kinds of extensions
* Extensive community support
* Very good integrated ORM adapters that could easily be exchanged for ODM adapters for document databases
* Offers the dynamic of Ruby as programming language

As mentioned before, the planning of the extent of the functionality offered by this system, was very vague. Besides managing metadata and providing an API for other components, further features were at least considered to be part of this system, like for example a scheduler that triggers the component that handles the deployment of importers. Therefore we chose to build this system on top of an infrastructure that can be easily extended in many directions and has nice-to-use database adapters instead of a more lightweight system.

While initially we also wanted to model a data source with its sensors grouped in sensor stations, this approach would bring immense overhead for configuring data sources in our system upfront, as a user would have to very exactly model a data source with all its sensors and sensor stations first. For big services like e.g. the German Weather Service this would be an enormous amount of work. Gathering this information would better be done by scraping the information present in Elasticsearch and translating them to geolocated information for all sensors/sensor-stations/datasources. In {//TODO ref figure} you can see the modeling for this approach greyed out.

The main metainformation about the data sources (besides metadata about the source itself) that we still needed within our system (the location of the sensor and the grouping of sensor stations is not essential for our system to work) and had to offer to the user registering a source were then:

* Information about the measurands offered by the data source
* Information about the main unit used for a measurand (see section Unit system // TODO ref section)

![UML Class-Diagram of the Relational Management System.](images/relational_schema.png)


### Future Improvements

#### Caching

There is currently no caching solution implemented since the workloads during development phase were quite manageable. Also including a distributed caching system in our production pipeline seemed to be too high of an effort and would take up significant resources that would actually not be needed during development. We wanted, therefore, to use the limited and expensive resources we had for actual importing.

As the number of data importers grows in production, however, requests to the relational database would increase accordingly. Whereas scaling the database would allow us to avoid the bottleneck, adding a cache in front of the database to serve read requests would be sufficient to ensure performance without incurring the cost and added complexity of scaling. An important consideration, of course, is the frequency with which data is updated (in our case  low to none), thus making it a perfect candidate for caching. As a distributed caching system where read requests are very fast and possible on all nodes, Redis would be a good fit for this use case. Writing is quite expensive due to the replication method used by Redis, but because of the infrequent updates to our data, we are willing to accept the trade-off in exchange for very fast reads.

#### Exchange Scheduling information

Due to not quite being able to reach every goal of our initial plan as to how the architecture should look like, the scheduler had to move to the deployment component (i.e. the deployment to the Kubernetes cluster). While this component should be responsible for deploying data importers, the information about the schedule should actually be provided to the web management system by the user. This is currently not happening. There would be several ways how to manage scheduling and/or deliver the scheduling information from this system to the component handling the scheduling.

* Having a background-processing component that acts as a scheduler within the web management platform. This would require an API to trigger the deploy on the component responsible for that, which we were not able to achieve.
* Having a microservice-like component that is only responsible for scheduling and triggering importers to be deployed. This would as well require an API on the deployment component.
* Leave the scheduling within the deployment component. This would also require an API, but just for receiving the general schedule, not for offering a hook to trigger an import.

The second option seems more granular and conforms better to our general microservice approach but would also require the most configuration and deployment effort. Including a scheduler in the web management platform would somehow violate this approach but still make sense, as this component could easily be integrated within Ruby on Rails and would be a standalone component within it.

## Unit System
When it comes to gather and manage sensor data one topic that directly comes to mind is that of units. Uncountable units exist and while there are international systems like the *International System of Units (SI)* or the *metric system* it is hard to find one system, that fits all possible measurements in our case. Some of the reasons for that are:

* Not for all measurements there exists an standardized unit in unit systems (e.g. parts per million)
* While standardized systems have the advantage of offering *one* standard unit for a category, those do not have to be intuitive (e.g. using Kelvin for outside temperature probably will not be intuitive for many people)

Because of that we had to think of an own way, how units would be chosen, managed and how users would get information about them.

### Further requirements
Deciding on a strategy to model units, was a quite long process and not all requirements could be fullfilled. In this section we will discuss the most important requirements to later on explain for what approach we

1. Allow convertibility and ability to localize
1. It has to be understandable, in what unit a measurement is expressed and in which it was measured
It is absolutely avoidable that measurements exist in the database, with a not understandable unit or even worse with a unit that differs from what the system supposes the measurement is expressed in. It is therefore advisable to enforce the user to handle units carefully
1. Each unit should only exist once. Typos, different expressions etc. shall not lead to confusion

### Implementation
With the requirements in mind we decided to organize units like so:

1. We introduced **Unit Categories**. Units themselves always belong to a unit category. The unit-category describes an entity for which measurements exist, which express their observations with one of the units of that category (See figure for Class Diagram // TODO ref figure).
2. Each unit has a **main unit** that we decide on. By calling the API or visiting the management platform a user can see, which the main unit is. Within our datastore we only use the main unit of a unit-category for expressing measurements.
3. Units are managed by admins receptively users with permit to do so.
4. We therefore have a curated list of the unit-categories and units
5. If there are units, measurements or even categories missing, each user can propose new ones. This proposals are also managed by the group of people managing the units.

Measurements are controlled on the platform itself to allow users to better propose new measurements, as this may happen more often. Units and the Unit categories however are managed in a *.yml* file. The syntax we used looks like following for one entry:

```
From config/constants/units.yml:

pascal:
  id: pressure_pascal
  name: "pascal"
  unit_symbol: "pa"
  unit_category_id: pressure
  notation: "1 <centerdot>
              <mfrac>
                <mrow>
                  kg
                </mrow>
                <mrow>
                  m
                  <msup>
                          <mi>s</mi>
                          <mn>2</mn>
                </mrow>
              </mfrac>"

From config/constants/unit_categories.yml:

pressure:
  id: pressure
  name: Pressure

```
The unit categories are pretty straight forward. For a unit there are some more possibilities. Besides declaring the unit symbol, the category it belongs to, its name you are allowed to use MathML to express what the meaning of a unit is. This is especially helpful with units that can be directly converted to each other. // TODO ref picture

![Screenshot of the units of a unit category on the web management platform. You can see the main unit and have a notation on what the units express.](images/unit_frontend.png)


The API of the web management system also provides calls to a) receive the main unit of a unit category and to b) get a list of all units there are for a unit category. Both of these information are of course aswell accessible from the frontend of the system.

```
GET /unit_categories/:id/getMainUnit
```
Example request:

```
GET /unit_categories/temperature/getMainUnit

{
	"id":"temperature_celsius",
	"name":"celsius",
	"unit_category_id":"temperature",
	"unit_symbol":"°C"
}
```

```
GET /unit_categories/:id/units
```
Example request:

```
GET /unit_categories/temperature/units

[
	{"attributes"
		{"id":"temperature_celsius","name":"celsius","unit_symbol":"°C","unit_category_id":"temperature","notation":""}},
	{"attributes":
		{"id":"temperature_fahrenheit","name":"fahrenheit","unit_symbol":"°F","unit_category_id":"temperature","notation":""}},
	{"attributes":
		{"id":"temperature_kelvin","name":"kelvin","unit_symbol":"K","unit_category_id":"temperature","notation":""}}
	[...]
]
```

### Discussion

This implementation has some advantages but also some disadvantages. In this section we want to take a closer look to both sides.

As we force the user to use our main unit, we can be sure, that all data in the database is of the same unit for a measurement type. Of course we cannot enforce that the user does convert measurements correctly or at all, but this would be considered as a faulty import, which in the end is the responsibility of the user. Of course an assessment of the correctness of data would be nice, but this is also hard to achieve and not within the scope of our project.

Our approach of having a curated list means some management overhead and possible longer implementation effort for the user if a unit conversion he or she needs is not yet available. Given the vast number of units in general and the lack of standardization in the way sensors report their data, giving a lot of latitude to the user to specify the units and the necessary conversions seems like the only reasonable way in which to approach the issue.

As the unit categories should be present after a short testing phase of a system, and a main unit exists with with, as the curators decide on one, the user should most of the time be able to register a source, when he wants to, as he only needs to know the main unit.

A big advantage of our approach is, that we kind of crowd-source the implementation of converters by this, as it happens during the ETL phase while importing (See //TODO ref chapter unit conversion) a source. This gives us a chance to achieve the following:

* Conversions can be reverted, as the converter used is stored with the data.
* Localization within our database can easily be done, as all measurements of a unit category have the same unit and converters are written the moment someone has to convert his source data to our preferred unit.
* By crowd-sourcing the implementation of converters they are also open sourced for reuse by other users. Having our own converters only in the system to convert measurements after they are in the database would not guarantee the reusability as importers and our database frontend depend on totally different things.