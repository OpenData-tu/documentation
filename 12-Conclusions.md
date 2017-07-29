# Conclusions

**Authoriship**

|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
|  0.1  | 2017-07-19 | Oliver, Andres | Working draft |


## Is Open Data really open?

* What sources did we "unlock"
 - Data source types (ftp, http, REST)
 - Different data formats (CSV, XLS, HTML)
 - Different measurands (Temperature, air pollution, etc)

//`TODO` look into https://www.wired.com/1994/11/agre-if-2/ as a possible reference

## Lessons learned

* Maslow's hammer: “when you have a hammer,
everything looks like a nail”
* Database choice: Start with use cases & (types of) queries
* Test your ideas on real infrastructure rather  conjecturing
* Balance using existing knowledge vs. investing time in learning new technologies
* Never underestimate overhead of cloud resource  procurement, configuration & deployment
* Availability of “open” data is virtually  inexistent for automated agents
* Most provide a GUI, but not the data

### Team & Process
* Because English was not the native language of the majority of the team members, this led to difficulties with preciseness when having discussions and reaching consensus/conclusions
* Cultural differences (indirect speech, etc.) also contributed to protracted discussions and difficulties reaching agreement, in general.
* Team members tended to work separately. This in itself is not generally a problem, but in our case, due to lack of communication & synchronization with the rest of the team, led to end-products which sometimes did not work together well, or required significant efforts to integrate and harmonize. bugs or issues in the individual components were not discovered until quite late in the process (until deployment). Further, because the infrastructure deployment rested on the shoulders of a single member, this created a bottleneck and excessive load on this person.
* Development tools were established from the get-go, but somewhere around the midpoint of the project timeline most stopped using Trello to keep track of tasks and TODOs. Obviously this led to lack of visibility as to what was to be done, and contributed to the general displacement of  team members into silos.


## Future improvements
-- What are the problems with the architecture as it is today
-- What was *not* implemented and WHY

* Postprocessing of indices/data into measurand-based hierarchy
* Optimize queries with metadata from relational database
* Ability to recover importer from failure via checkpointing
* User-defined time schedule for importers
* Auto-scaling of importers based on resource requirements
