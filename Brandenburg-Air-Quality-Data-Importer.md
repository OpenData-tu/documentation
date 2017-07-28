|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|0.1    | 2017-07-13 | Rohullah & Jawid | Initial version|

# Brandenburg Air Quality Data Importer
[Brandenburg Importer](https://github.com/OpenData-tu/BrandenburgAirQualityDataImporter) is developed as part of the extensible ETL framework. This data importer reads data from the specific source with the format of xls, process the data into our own schema then writes these data into Kafka queue.

**Importer Components:** this importer is composite of different components as follow:

## Data source
The datasource used for this importer is about air quality data in a daily basis or max 1 hour or max 8 hour from 28 data measuring stations in Brandenburg, Germany.

**Data Measuring Stations:** <br>
there are 28 data measuring stations.
Every station has a unique station code. <br>
The geographic location for data Measuring stations were not provided by the source. We managed to map all the stations with their particular geographic coordinates through Java classes manually.

**Supported Data Format:** xls <br>

**Measurement Units:**
- Ozone (O₃)
- Nitric oxide (NO)
- Nitrogen dioxide (NO₂)
- Fine dust (PM10)
- Fine dust (PM2.5)
- Sulfur dioxide (SO₂)
- Carbon monoxide (CO)

**Note:**
- all measurement units are in (µg/m³).
- Max (8h): means 8th hour maximum value of measurement units. <br>
**URL:** https://luftdaten.brandenburg.de/home/-/bereich/aktuell

## Batch Jobs
This importer is Single 'Job' with a single 'Step' which is implemented in Spring Batch framework.

1. Spring Batch 'Steps'

a single step for a single job in Spring Batch is contained: Read, Process, Write

**Read:** read data from the source <br>
**Process:** in our case we have processed to change the date into ISO format <br>
**Write:** the importer write the data into our predefined JSON schema <br>

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

**Sample JSON Schema for Measurement Units**

```
{
  "source_id": "brandenburg_air_quality_data",
  "device": "Elsterwerda",
  "timestamp": "2017-07-13T22:00:00+02:00",
  "location": {
    "lat": 51.46273,
    "lon": 13.52679
  },
  "license": "find out",
  "sensors": {
    "NO2DailyAverage": {
      "sensor": "Nitrogen dioxide (NO₂)",
      "observation_value": 6
    },
    "NO2Max1hAverage": {
      "sensor": "Nitric oxide (NO)",
      "observation_value": 2
    },
    "NODailyAverage": {
      "sensor": "Nitric oxide (NO)",
      "observation_value": 1
    },
    "CODailyAverage": {
      "sensor": "Carbon monoxide (CO)",
      "observation_value": null
    },
    "COMax8hAverage": {
      "sensor": "Carbon monoxide (CO)",
      "observation_value": null
    },
    "FineDustPM10DailyAverage": {
      "sensor": "Fine dust (PM10)",
      "observation_value": 19
    },
    "FineDustPM10Max1hAverage": {
      "sensor": "Fine dust (PM10)",
      "observation_value": 34
    },
    "FineDustPM25DailyAverage": {
      "sensor": "Fine dust (PM2.5)",
      "observation_value": 16
    },
    "FineDustPM25Max1hAverage": {
      "sensor": "Fine dust (PM2.5)",
      "observation_value": 30
    },
    "SO2DailyAverage": {
      "sensor": "Sulfur dioxide (SO₂)",
      "observation_value": null
    },
    "SO2Max1hAverage": {
      "sensor": "Sulfur dioxide (SO₂)",
      "observation_value": null
    },
    "O3DailyAverage": {
      "sensor": "Ozone (O₃)",
      "observation_value": 65
    },
    "O3Max8hAverage": {
      "sensor": "Ozone (O₃)",
      "observation_value": 91
    }
  }
}

```

## Data Producer for Kafka Queue
#### Kafka Producer

- produces the extracted data into Kafka queue with a specified JSON schema
- Kafka Configuration: basic properties for Kafka producer such as 'broker', 'serializer', key and value
- Queue Topic: setting a topic with a specific name for Kafka queue
