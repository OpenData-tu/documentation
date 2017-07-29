# Authorship

|Version|Date|Modified by|Summary of changes|
|-------|----|-----------|------------------|
| 0.0.1 | 2017-07-19 | Andres, Oliver | Sections and initial outline |
| 0.1.0 | 2017-07-27 | Oliver | Outline & first written draft |
| 0.2.0 | 2017-07-28 | Oliver | Rephrasing & extended team section |


# Project Management & Organization

The main challenge of project management is to achieve specific results within a given scope, time, quality and budget. At the end of every successful project, stands a unique product meeting the specified requirements. This chapter elaborates on the available resources and the development process and chosen approach. The resources that this chapter will focus on are the heterogeneous team and a limited budget.

## The Team

The project team consisted of seven masters students majoring in computer science, computer engineering and information systems management. Moreover, the team members are native of five different countries with different cultural backgrounds and native languages. Due to varying English skills and professional experience  some discussion resulted to be time consuming.  Furthermore, most members follow a profession, hence time schedules had to be formed accordingly.

The group consisted of same level members and a project manager in a coordinative position. Thus, a hierarchy was formed within the group which added discrepancies especially for the project manager. In addition, the group was divided into expert teams for the different building blocks. In the beginning, two teams had been formed; one that was responsible for the importing framework and data sources and one for the database and infrastructure. Throughout the project period the roles of several members shifted. In the end, the importer team consistet of three persons, another team focused on the modelling and administration of data sources, the third focused on the infrastructure provisioning and deployment lastly, one team worked on the backend.

## Constraints

Like every other project, this one was subject to several constraints. The very nature of a project makes it a temporary endeavor. Thus, the product had to be finished within eleven weeks starting on April 27th and ending on July 30th. Additionally, towards the end of the first half on June 1st, an interim meeting was held. During these eleven weeks three feedback sessions were held,one of them before the interim meeting and two after.

Moreover, monetary restrictions added an extra level of difficulty. While developing software consisting of several disparate building blocks, it is crucial to deploy and test the components individually and collectively. Due to lack of an own infrastructure, the only feasible way to conduct testing - in functionality and performance - was to use a cloud provider. Owing to no available budget the decision for the 100$ student grant offered by Amazon Webservices (AWS) was made. Nevertheless, this added even more effort to receive access to the student grant and, furthermore, to also be able to use all of the services provided. Some members did not receive any free credit from AWS.

Moreover, the budget constraints forced the team to start and terminate the whole infrastructure every time a test was conducted. In other words, a significant amount of time was necessary to create the test environment each time, which put additional straints to compensation of the already strict time limit. Hence, a significant effort was put into automating processes in order to provision the infrastructure and deployment of components.

Having dedicated infrastructure from the beginning would have allowed to focus more on the actual challenges of the project itself.

## Development Process & Approach

To best commence the given requirements and challenges, we decided for an agile development process. To be more specific, we used a stripped-down Scrum approach.

In our approach, the distinction between the different roles was not very strict. Every team member held simultaneously the role of a product owner and developer for his specific building block of the global architecture. The same is applicable for the roleof the Scrum Master that was shared among the whole team, though was mainly the responsibility of the Project Manager. Specifically this means that every team member was encouraged to ensure an agile process and administrate issues. Further, the workflow was adapted to our specific flow of work so that we convened a sprint meeting weekly with an additional interim meeting and omitted the daily scrum.

To keep track of all issues and the global progress, we used Trello. Trello follows the kanban model and arranges the issues into lists. The first list represented the product backlog, which was populated continously as the project progressed. The tasks that were up next were arranged in the list for the current sprint. Finally, a list to display the currently worked on issues and a list for the finished tasks existed.

Communication between meetings was done on Slack. Several channels were created to allow for a separation of the topic discussed. Additionally, a shared calendar and drive were used to remeber deadlines and store the produced documents. Besides that we used GitHub to store the code written during the project, where every componenet received an own repository. 

In order to intergrate the tools we used as well as to automate workflows a service called Zapier was used. We used it to receive notifications about changes on Github and Google Drive and progress on the Trello board. Though, after the trial ended the functionality was limited so that only notifications about Github updates were send.