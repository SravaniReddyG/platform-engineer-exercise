# platform-engineer-exercise
## Overview
This project demonstrates monitoring, automation, and infrastructure deployment using:

- Sumo Logic (Monitoring & Alerting)
- AWS Lambda (Automation)
- EC2 (Server)
- SNS (Notifications)
- Terraform (Infrastructure as Code)

## Task 1 — Sumo Logic Monitoring

In this task, I implemented API latency monitoring using Sumo Logic.

### Configuration Performed
- Created Hosted Collector in Sumo Logic
- Added Log Source using HTTP Logs
- Generated HTTP Source Endpoint URL
- Inserted sample logs by sending HTTP POST requests using curl

### Log Simulation
Sample API latency logs were inserted by running the HTTP endpoint URL multiple times to simulate slow API responses.

### Monitoring Logic
The Sumo Logic query detects high API latency.

Trigger Condition:
- More than 5 requests
- Response time > 3 seconds
- Within 10 minutes

Query is stored in:
sumo_logic_query.txt

---

## Task 2 — Automated Remediation

In this task, I implemented automated infrastructure recovery and alerting.

### Resources Created
- EC2 Instance (API Server)
- SNS Topic (Email Notifications)
- AWS Lambda Function (Automation Logic)

### Additional Configuration
- Configured Lambda Function URL
- Created Webhook Connection in Sumo Logic
- Attached Webhook to Sumo Logic Monitor

### End-to-End Workflow
1. Sumo Logic detects high API latency from logs
2. Monitor triggers alert when:
   - More than 5 slow requests
   - Over 3 seconds latency
   - Within 10 minutes window
3. Alert triggers Webhook
4. Webhook invokes AWS Lambda via Function URL
5. Lambda:
   - Restarts EC2 instance
   - Sends notification via SNS email

This demonstrates automated detection, remediation, and notification.

---

## Task 3 — Terraform Infrastructure Deployment

In this task, I used Terraform to provision AWS infrastructure and automate resource creation.

### Local Environment Setup
- Installed Terraform on local machine
- Installed AWS CLI
- Created AWS Access Key and Secret Key from AWS IAM
- Configured AWS locally using:
  aws configure

### Project Setup
- Created local project folder:
  pacer-terraform

### Development Setup
Using Visual Studio Code, I created the following files:

- main.tf
- variables.tf
- outputs.tf
- lambda-function.py

### Lambda Packaging
- Compressed lambda-function.py into:
  lambda.zip

This zip file was used by Terraform to deploy the Lambda function.

### Terraform Configuration
Terraform was configured to create:

- EC2 Instance (API Server)
- SNS Topic (Notifications)
- AWS Lambda Function (Automation)

### Terraform Execution Steps
Terraform commands executed:

terraform init  
terraform plan  
terraform apply  

### Additional Configuration
- Generated AWS Lambda Function URL
- Configured Lambda Function URL in Sumo Logic Webhook Connection
- Attached Webhook to Sumo Logic Monitor

### End-to-End Validation
- Triggered Sumo Logic alert using simulated API latency logs
- Verified webhook invocation to Lambda
- Verified Lambda execution:
  - EC2 instance restart triggered
  - SNS email notification received

### Result
Terraform successfully provisioned AWS infrastructure and enabled automated monitoring, remediation, and notification workflow.

