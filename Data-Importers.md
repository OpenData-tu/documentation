|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|0.1    | 2017-07-28 | Rohullah & Jawid | Initial version|

# Data Importers
According to the requirements for unlocking various data sources (environmental data) we have built importers to do this task. Every importer used to extract data from different kinds of sources with vary in implementation. However the data producer component of the importer will remain with the same implementation for most of the importers. There is a unified data model which every data importer write the data into the queue according to it. <br>
The current chapter explains data importers with all their details.
Firstly, every single data importers are described with varies in data sources, implementation with sample generated JSON schema.
Secondly, the unified data model and a producer for putting data into the queue is explained as well.  <br>

Each importer composed from individual components which is stated below: <br>

**Basic Components of Importers:**
- Data sources
- implementation
  * Batch Jobs
- Data Model
- Data Producer

# 1. Weather Data Importer
[WeatherDataImporter](https://github.com/OpenData-tu/WeatherDataImporter) is part of our extensible ETL framework. In this importer, a specific data source is used to extract data from, process them and write them into the Kafka queue.

</br> **Components**
Basic Components for Weather Data Importer and Producer are the followings:

## Data Source
**Weather Data for Berlin, Germany** </br>
The data source which is used for this importer is from [luftdaten.info](http://luftdaten.info/). This datasource is part of the **OK Lab Stuttgart** project which includes 300 fine dust sensors. </br>

<i> It’s possible to filter different data such as:
 - Humidity
 - Temperature
 - Pressure

<i> with their locations and timestamps. </br>

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

# 2. Brandenburg Air Quality Data Importer
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

# 3. Umweltbundesamt Air Quality Data Importer
[Umweltbundesamt importer](https://github.com/OpenData-tu/UmweltbundesamtDeAirQualityImporter) is developed as part of the extensible ETL framework. This data importer reads data from the specific source with the format of Comma Separated Values, process the data into our own schema then writes these data into Kafka queue.

**Importer Components:** this importer is composite of different components as follow:

## Data source
The datasource used for this importer is about air quality data (Current Air Data) in a daily basis from about 500 data measuring stations of the federal states and the Federal Environmental Agency in over 16 states and cities throughout Germany.

**States**
- Brandenburg
- Berlin
- Hesse
- Hamburg
- Baden-Wurttemberg
- Bavaria
- Bremen
- Mecklenburg-Vorpommern
- Lower Saxony
- North Rhine-Westphalia
- Rheinland-Pfalz
- Saarlan
- Schleswig-Holstein
- Saxony
- Saxony-Anhalt
- Thuringia
- UBA

**Data Measuring Stations:**
- there are about 500 data measuring stations for all above states.
- Every station has a unique station code. <br>

**Note:** the geographic location for data measuring stations were not provided by the source. We managed to map all the stations with their particular geographic coordinates through Java classes manually.

**Supported Data Format:** CSV <br>

**Measurement Units:**
- Fine Dust (PM10)
- Sulfur Dioxide
- Ozone
- Nitrogen Dioxide
- Carbon Monoxide

**Note:**
- all measurement units are in (µg/m³).
- Max (8h): means 8th hour maximum value of measurement units. <br>

**URL:** https://www.umweltbundesamt.de/


## Batch Jobs
This importer is Single 'Job' with five 'Steps' which is implemented in Spring Batch framework.

1. Spring Batch 'Steps'

a single step for a single job in Spring Batch is contained: Read, Process, Write <br>

**Read:** read data from the source <br>
**Process:** in our case we have processed to change the date into ISO format <br>
**Write:** the importer write the data into our predefined JSON schema <br>
**Note:** Every measurement unit had their own schema, because of that we used five steps for the every individual five measurement units. Thus we have five steps in our Batch Job. <br>

2. Spring Cloud Task

this feature of 'Spring' is used in our case to make the whole data import framework as micro services.

## Data Model
**Sample Json Schema for Fine Dust (PM10) Measurement Unit**
```
 {
"source_id": "umweltbundesamt_de",
 "device": "Elsterwerda",
 "timestamp": "2017-07-12T22:00:00Z",
 "location": {
   "lat": 51.462734,
   "lon": 13.526796
 },
 "license": "find out",
 "sensors": {
   "PM10DailyAverage": {
     "sensor": "Particles PM10",
     "observation_value": 11.0
   }
 },
 "extra": {
   "pollutant": "Feinstaub (PM10)",
   "network": "BB",
   "dataType": "Tagesmittel (1TMW)",
   "stationCode": "DEBB007"
 }
}
```
**Other measurements**
```
 "sensors": {
   "SO2DailyAverage": {
     "sensor": "Sulfur Dioxide",
     "observation_value": 1.0
   }
```
```
 "sensors": {
   "O3Max8hAverage": {
     "sensor": "Ozone",
     "observation_value": 72.0
   }
```
```
 "sensors": {
   "NO2Max1hAverage": {
     "sensor": "Nitrogen Dioxide",
     "observation_value": 19.0
   }
```
```
 "sensors": {
   "COMax8hAverage": {
     "sensor": "Carbon Monoxide",
     "observation_value": 300.0
   }
```

# 4. Pegel Online Water Level Data Importer  
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

**Note:** the following components are common through all importers.

## Data Model
In order to write the extracted data into the queue (Kafka), this importer generates the required data format with the fields of: <br>
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

## Data Producer
#### Kafka Producer

- produces the extracted data into Kafka queue with a specified JSON schema
- Kafka Configuration: basic properties for Kafka producer such as 'broker', 'serializer', key and value
- Queue Topic: setting a topic with a specific name for Kafka queue
