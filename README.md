# 📚 ReaderStack — Terraform-Based 3-Tier Deployment for Reader App

This project deploys a full-stack application (from [`atenadadkhah/reader`](https://github.com/atenadadkhah/reader.git)) on AWS using Terraform. It sets up a **3-tier architecture**:

- **Frontend** (Next.js) on EC2
- **Backend** (Node.js/Express) on EC2
- **Database** (PostgreSQL via RDS)

---

## 🚀 Features

- Fully automated deployment with Terraform
- VPC, subnets, route tables, and security groups
- EC2 instances for frontend and backend
- PostgreSQL RDS instance
- S3 bucket for storing backups or future enhancements
- User data scripts to automate instance configuration
- Remote state storage and state locking via S3 and DynamoDB (optional)

---

## 📁 Project Structure

ReaderStack/
│
├── modules/
│ ├── ec2/ # EC2 frontend/backend deployment
│ ├── rds/ # RDS PostgreSQL deployment
│ ├── s3/ # S3 bucket setup
│ └── vpc/ # Networking configuration
│
├── main.tf # Root module for calling all submodules
├── variables.tf # Input variables
├── outputs.tf # Output values
├── provider.tf # AWS provider configuration
└── backend.tf # Remote state (optional)


---

## 🧰 Prerequisites

- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
- AWS account with a configured IAM user
- `aws configure` set up locally (or use environment variables)
- Key pair created in AWS EC2 for SSH access (if needed)
- An S3 bucket + DynamoDB table for remote state (optional)

---

## 🛠️ How to Deploy

### 1. Clone the Repository
git clone https://github.com/mzmarci/ReaderStack.git
cd ReaderStack

 ### 2.Initialize Terraform
 terraform init

 ### 3. Customize Variables
 Edit terraform.tfvars or modify variables in variables.tf for:

Instance types

Subnet/VPC CIDRs

RDS config

SSH key pair name

GitHub repo link (default is atenadadkhah/reader)

### 4. Apply the Configuration
terraform apply -auto-approve

Terraform will:

Provision a new VPC with public/private subnets

Launch EC2 instances with user data scripts

Deploy PostgreSQL via RDS

Set up S3 (optional)

### 5. Accessing the App
Frontend: Visit the public IP of the frontend EC2 on port 3000 

Backend: Accessible from frontend only (private IP)

Database: Accessible from backend EC2 (via RDS)

### 6. Teardown
To destroy all resources:
terraform destroy -auto-approve


### About the Application
The app cloned from atenadadkhah/reader is a reading list manager that supports:

Frontend: Next.js (in client/)

Backend: Node.js + Express (in server/)

PostgreSQL DB (via RDS)

### 📜 License
This project is based on an open-source app and is licensed accordingly.


