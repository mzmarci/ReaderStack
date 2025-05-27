#!/bin/bash
# Update packages
yum update -y
sudo yum install git -y
# Install Node.js 16
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install nodejs -y


# Set working directory
cd /home/ec2-user

# Clone the repository
git clone https://github.com/atenadadkhah/reader.git app

# Change ownership to ec2-user just in case
chown -R ec2-user:ec2-user /home/ec2-user/app
cd app
cd client
#/home/ec2-user/app/client/package.json
#/home/ec2-user/app/server/package.json

# Install dependencies and build the frontend
npm install
npm run build      # builds the production version
npm run start      # starts Next.js server on port 3000 by default





#!/bin/bash ensures it's treated as a shell script.

# nohup ensures the process keeps running after initialization.

# Logs are written to /home/ec2-user/serve.log for troubleshooting.

# chown ensures the right permissions if needed when run from root context.
