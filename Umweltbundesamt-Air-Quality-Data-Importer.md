|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|0.1    | 2017-07-12 | Rohullah & Jawid | Initial version|
|0.2    | 2017-07-13 | Rohullah & Jawid | JSON schema added + Formating|

# Umweltbundesamt Air Quality Data Importer
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

## Data Producer for Kafka Queue
#### Kafka Producer

- produces the extracted data into Kafka queue with a specified JSON schema
- Kafka Configuration: basic properties for Kafka producer such as 'broker', 'serializer', key and value
- Queue Topic: setting a topic with a specific name for Kafka queue
