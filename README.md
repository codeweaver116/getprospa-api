# getprospa-api

1.	Come up with an Architecture based on AWS which should include;
a.	We have Web App which is public facing, Mobile App on Playstore and Appstore. Both these apps are public facing and they consume services from the Backend App which interacts with the database. Both the Backend App and Database are private.
b.	Load balancers and web security implementation
c.	Developer, Staging and Production environments
d.	Implement also Terraform for IaC and how it will be used to manage the environment created.
2.	Come up with a CI/CD pipeline which includes;
a.	Docker and Kubernertes  
b.	Bitbucket/Github
c.	Code Pipeline
d.	Helm Charts for Deployment (Will work on top of Kubernertes to shorten the deployment time)
3.	Database Management on AWS (MySQL v8)
4.	How would you handle migration from Digital Ocean to AWS


# Technical Challenge

 Tools
 ######

1. Used Github for Version control and github actions for  deployment
2. Datadogs for monitoring
3. Terraform and Terraform cloud for clean IAC deployment
4. Docker for containerization
5. AWS ECS fargate instead of kubernetes
6. AWS Cloud
7. Python and python flask for a test api.py app
8. aws rds mysql for database [not connected to app]


Architecture
************




Design Considerations:
***********************
1. Security
2. High Availability
3. operational overhead
4. operational cost
5. Automation: terraform & terraform cloud
6. Monitoring and observability: datadogs 



Production ready Suggestions
****************************
1. Integration
2. Caching
3. API Monitization: throttling, client security, developers portal, metering, documentation etc
4. Authentication: jwt, aws cognito


Proposed Production Ready Architecture
**************************************

