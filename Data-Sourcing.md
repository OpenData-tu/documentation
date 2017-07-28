# Authorship

|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|  0.1  | 2017-07-19 | Oliver, Andres | Working draft |
|  0.2  | 2017-07-28 | Rohullah, Jawid | discovered data sources |

# Data Sourcing

- Decided early on that we would focus our data sourcing efforts on Germany and Europe. Having more localized data would later enable us to more easily use them in the application, as geographically disparate data would be difficult to integrate into a single app.

- Went through catalogs, used Google

-- Appendix

Data sources we looked up and were unusable (and why)

# Discovered Data Sources

|  No. | Name  | Description  | Measurement Values  | Supported Data Format  | URL  |
|---|---|---|---|---|---|
|  1 | Weather Data Stuttgart | The source is part of the **OK Lab Stuttgart** project which includes 300 fine dust sensors.  | Humidity, Temperature, Pressure  | csv  | luftdaten.info  |
|  2 | Luftdaten Brandenburg  | Air quality data from 28 data measuring stations in Brandenburg, Germany.  | O₃, NO, NO₂, PM10, PM2.5, SO₂, CO  | xls  | luftdaten.brandenburg.de  |
| 3  | Umweltbundesamt  | Current air quality data from about 500 data measuring stations for 16 states and cities of Germany.  | PM10, SO₂, O₃, NO₂, CO | csv  | umweltbundesamt.de  |
| 4  | Pegel Online Water Level | Raw values of *Water Level* for internal and coastal levels of waterways of the Germany up to a maximum of 30 days  | Water Level | REST, SOAP, HTTP  | pegelonline.wsv.de  |
