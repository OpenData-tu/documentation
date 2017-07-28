|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|0.1    | 2017-06-17 | Rohullah & Jawid | Initial version|
|0.1a    | 2017-06-20 | Rohullah & Jawid | Batch Job 'Steps' Part edited|
|0.1b    | 2017-07-20 | Rohullah & Jawid | JSON Schema added|

# Weather Data Importer
WeatherDataImporter is part of our extensible ETL framework. In this importer, a specific data source is used to extract data from, process them and write them into the Kafka queue.

</br></br> **Components**
Basic Components for Weather Data Importer and Producer are the followings:

## Data Source
**Weather Data for Berlin, Germany** </br>
The data source which is used for this importer is from [luftdaten.info](http://luftdaten.info/). This datasource is part of the **OK Lab Stuttgart** project which includes 300 fine dust sensors. </br>

<i>It’s possible to filter different data such as:
 - Humidity
 - Temperature
 - Pressure

<i>with their locations and timestamps. </br>

**Supported formates:** CSV </br>

**URLs:**
- http://archive.luftdaten.info/
- http://luftdaten.info/

## Batch Jobs
This importer is Single 'Job' with four 'Steps' which is implemented in Spring Batch framework.
### 1. Spring Batch 'Steps'
a single step for a single job in Spring Batch is contained: Read, Process, Write
  - Read: read data from the source
  - Process: in our case we have processed to change the date into ISO format
  - Write: the importer write the data into our predefined JSON schema

**Note:** we used four steps because in current data source there are sensors with different types. Each sensor type requires a schema to be created, each in an individual 'Steps'. Thus we have four steps in our Batch Job.  

### 2. Spring Cloud Task
this feature of 'Spring' is used in our case to make the whole data import framework as micro services.  

## Data Model
   - Schema Validation: in order to write the extracted data into the queue (Kafka), the importer validates the data into our required data format with the fields of:
     - sensorId
     - sensorType
     - location
     - lat
     - lon
     - timestamp
     - pressure
     - altitude
     - pressureSeaLevel
     - temperature
     - humidity </br>

as already documented in: [Open Data APIs for Input Data](https://github.com/OpenData-tu/documentation/wiki/Open-Data-APIs-for-Input-Data) <br>

**Sample JSON Schema for Measurement Units:**
```
{
  "sourceId": "luftdaten_info",
  "device": "2036",
  "timestamp": "2017-07-01T22:40:05.000+02:00",
  "location": {
    "lat": 42.657,
    "lon": 23.349
  },
  "license": "find out",
  "sensors": {
    "pressure": {
      "sensor": "BME280",
      "observation_value": 94267.06
    },
    "altitude": {
      "sensor": "BME280",
      "observation_value": null
    },
    "pressure_sealevel": {
      "sensor": "BME280",
      "observation_value": null
    },
    "temperature": {
      "sensor": "BME280",
      "observation_value": 26.19
    },
    "humidity": {
      "sensor": "BME280",
      "observation_value": 49.8
    }
  },
  "extra": {
    "location": "1023"
  }
```
## Data Producer for Kafka Queue (Writing into Kafka Queue)
  **Kafka Producer**
  - produces the extracted data into Kafka queue with a specified JSON schema
  - Kafka Configuration: basic properties for Kafka producer such as 'broker', 'serializer', key and value  
  - Queue Topic: setting a topic with a specific name for Kafka queue
