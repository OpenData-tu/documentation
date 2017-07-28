|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|0.1    | 2017-07-15 | Rohullah & Jawid | Initial version|

# Pegel Online Water Level Data Importer  
[Pegel Online Water Level   Importer](https://github.com/OpenData-tu/PegelOnlineWaterLevelImporter) is developed as part of the extensible ETL framework. This data importer extracts data from the RESTful API of [Pegel Online](https://www.pegelonline.wsv.de/gast/start), process the data into our own schema then writes these data into Kafka queue.

**Importer Components:** this importer is composite of different components as follow:

## Data source
The datasource used for this importer is about raw values of *Water Level* of internal and coastal levels of waterways of the Germany up to a maximum of 30 days from PEGELONLINE. The data is published every 15 minutes (daily).

**Supported Data Format:** RESTful API <br>

**Measurement Units:**
- Water Level

**URL:** https://www.pegelonline.wsv.de/gast/start

## Batch Jobs
This importer is Single 'Job' with a single 'Step' which is implemented in Spring Batch framework.

1. Spring Batch 'Steps'

a single step for a single job in Spring Batch is contained: Read, Process, Write

Read: read data from the source <br>
Process: in our case we have processed to change the date into ISO format <br>
Write: the importer write the data into our predefined JSON schema <br>

2. Spring Cloud Task

this feature of 'Spring' is used in our case to make the whole data import framework as micro services.

## Data Model
in order to write the extracted data into the queue (Kafka), this importer generates the required data format with the fields of: <br>
```
sensor_id
device
timestamp
location
sensors
extras
[height]
license
```
as already documented in: [Open Data APIs for Input Data](https://github.com/OpenData-tu/documentation/wiki/Open-Data-APIs-for-Input-Data)

**Sample JSON Schema for Water Level Measurement Unit**

```
{
  "source_id": "pegelonline_wsw_de",
  "device": "EITZE",
  "timestamp": "2017-07-15T18:45:00+02:00",
  "location": {
    "lat": 52.90406541008721,
    "lon": 9.27676943537587
  },
  "license": "find out",
  "sensors": {
    "waterLevel": {
      "sensor": "",
      "observation_value": 283
    }
  },
  "extra": {
    "measurementUnit": "cm",
    "equidistance": 15,
    "trend": 0,
    "stateMnwMhw": "normal",
    "stateNswHsw": "unknown",
    "gaugeZero": {
      "gaugeZeroUnit": "m. ü. NN",
      "gaugeZeroValue": 8,
      "gaugeZeroValidForm": "1985-03-13"
    }
  }
}

```

## Data Producer for Kafka Queue
#### Kafka Producer

- produces the extracted data into Kafka queue with a specified JSON schema
- Kafka Configuration: basic properties for Kafka producer such as 'broker', 'serializer', key and value
- Queue Topic: setting a topic with a specific name for Kafka queue
