# Data Importers

**Authorship**

|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|0.1    | 2017-07-28 | Rohullah & Jawid | Initial version|
|0.2    | 2017-07-29 | Rohullah & Jawid | Removing data production part + adding units|

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

## Data Model

Every importer generates the required data format with the following fields: <br>

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


# 1. Weather Data Importer

[WeatherDataImporter](https://github.com/OpenData-tu/WeatherDataImporter) is part of our extensible ETL framework. In this importer, a specific data source is used to extract data from, process them and write them into the Kafka queue. <br>

**Components**
Basic Components for Weather Data Importer and Producer are the followings:

## Data Source

The data source which is used for this importer is from [luftdaten.info](http://luftdaten.info/). This datasource is part of the **OK Lab Stuttgart** project which includes 300 fine dust sensors. </br>

**Measurement Values with Units:**

 - Humidity
 - Temperature: Celsius (°C)
 - Pressure: Pascal

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

## Sensors with Measurement Values

| No. | Measurement | Sensor |Frequency|
| -------- | -------- | -------- |-------|
| 1     | pressure     | BME280     |Daily|
| 2     | pressureSeaLevel     | BME280     |Daily|
| 3     | temperature     | BME280     |Daily|
| 4     | humidity     | BME280     |Daily|



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

**Measurement Values with Units:**

- Ozone (O₃): µg/m³
- Nitric oxide (NO): µg/m³
- Nitrogen dioxide (NO₂): µg/m³
- Fine dust (PM10): µg/m³
- Fine dust (PM2.5): µg/m³
- Sulfur dioxide (SO₂): µg/m³
- Carbon monoxide (CO): µg/m³

**URL:** https://luftdaten.brandenburg.de/home/-/bereich/aktuell

## Batch Jobs

This importer is Single 'Job' with a single 'Step' which is implemented in Spring Batch framework.

### 1. Spring Batch 'Steps'

a single step for a single job in Spring Batch is contained: Read, Process, Write

**Read:** read data from the source <br>
**Process:** in our case we have processed to change the date into ISO format <br>
**Write:** the importer write the data into our predefined JSON schema <br>

### 2. Spring Cloud Task

this feature of 'Spring' is used in our case to make the whole data import framework as micro services.

## Sensors with Measurement Values

| No. | Measurement |  Sensor | Frequency|
| -------- | -------- | -------- |-----|
| 1     | NO2DailyAverage     | Nitrogen dioxide (NO₂)     |Daily average|
| 2     | NO2Max1hAverage     | Nitrogen dioxide (NO₂)     |Daily maximum one hour average|
| 3     | NODailyAverage      |  Nitric oxide (NO)         |Daily average|
| 4     | NOMax1hAverage     | Nitric oxide (NO)          |Daily maximum one hour average|
| 5     | CODailyAverage     | Carbon monoxide (CO)     |Daily average|
| 6     | COMax8hAverage     | Carbon monoxide (CO)     |Daily maximum eight hour average|
| 7     | FineDustPM10DailyAverage     | Fine dust (PM10)     |Daily average|
| 8     | FineDustPM10Max1hAverage     | Fine dust (PM10)     |Daily maximum one hour average|
| 9     | FineDustPM25DailyAverage     | Fine dust (PM2.5)     |Daily average|
| 10     | FineDustPM25Max1hAverage     | Fine dust (PM2.5)     |Daily maximum one hour average|
| 11     | SO2DailyAverage     | Sulfur dioxide (SO₂)     |Daily average|
| 12     | SO2Max1hAverage     | Sulfur dioxide (SO₂)     |Daily maximum one hour average|
| 13     | O3DailyAverage     | Ozone (O₃)     |Daily average|
| 14     | O3Max8hAverage     | Ozone (O₃)     |Daily maximum eight hour average|


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

**Measurement Values and Units:**

- Fine Dust (PM10): µg/m³
- Sulfur Dioxide: µg/m³
- Ozone: µg/m³
- Nitrogen Dioxide: µg/m³
- Carbon Monoxide: µg/m³

**URL:** https://www.umweltbundesamt.de/

## Batch Jobs

This importer is Single 'Job' with five 'Steps' which is implemented in Spring Batch framework.

### 1. Spring Batch 'Steps'

a single step for a single job in Spring Batch is contained: Read, Process, Write <br>

**Read:** read data from the source <br>
**Process:** in our case we have processed to change the date into ISO format <br>
**Write:** the importer write the data into our predefined JSON schema <br>
**Note:** Every measurement unit had their own schema, because of that we used five steps for the every individual five measurement units. Thus we have five steps in our Batch Job. <br>

### 2. Spring Cloud Task

this feature of 'Spring' is used in our case to make the whole data import framework as micro services.

## Sensors With Measurement Values

| No. | Measurement | Sensor |Frequency|
| -------- | -------- | -------- |-------|
| 1     | PM10DailyAverage     | Particles PM10     |Daily average|
| 2     | SO2DailyAverage     | Sulfur Dioxide    |Daily average|
| 3     | O3Max8hAverage     | Ozone     |Daily maximum eight hour average|
| 4     | NO2Max1hAverage     | Nitrogen Dioxide     |Daily maximum one hour average|
| 5     | COMax8hAverage     | Carbon Monoxide     |Daily maximum eight hour average|

# 4. Pegel Online Water Level Data Importer  

[Pegel Online Water Level   Importer](https://github.com/OpenData-tu/PegelOnlineWaterLevelImporter) is developed as part of the extensible ETL framework. This data importer extracts data from the RESTful API of [Pegel Online](https://www.pegelonline.wsv.de/gast/start), process the data into our own schema then writes these data into Kafka queue.

**Importer Components:** this importer is composite of different components as follow:

## Data source

The datasource used for this importer is about raw values of *Water Level* of internal and coastal levels of waterways of the Germany up to a maximum of 30 days from PEGELONLINE. The data is published every 15 minutes (daily).

**Supported Data Format:** RESTful API <br>

**Measurement Values with Units:**

- Water Level: "cm"

**URL:** https://www.pegelonline.wsv.de/gast/start

## Batch Jobs

This importer is Single 'Job' with a single 'Step' which is implemented in Spring Batch framework.

### 1. Spring Batch 'Steps'

a single step for a single job in Spring Batch is contained: Read, Process, Write

Read: read data from the source <br>
Process: in our case we have processed to change the date into ISO format <br>
Write: the importer write the data into our predefined JSON schema <br>

### 2. Spring Cloud Task

this feature of 'Spring' is used in our case to make the whole data import framework as micro services.

## Sensors with Measurement Values

| No. | Measurement | Sensor |Frequency|
| -------- | -------- | -------- |------|
| 1     | Water Level     | Unknown     | 15 mins. interval|
