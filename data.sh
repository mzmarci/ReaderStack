#!/bin/bash
yum update -y
yum install -y python3 git
pip3 install --upgrade pip

# Clone the backend app
cd /home/ec2-user
git clone https://github.com/atenadadkhah/reader.git app
cd app
cd server

# Install Python dependencies
pip3 install -r requirements.txt

# Export environment variable for PostgreSQL
export DATABASE_URL="postgresql://${db_username}:${db_password}@${rds_endpoint}:5432/${db_name}"

# Start the backend server
nohup uvicorn main:app --host 0.0.0.0 --port 8000 > /home/ec2-user/backend.log 2>&1 &
