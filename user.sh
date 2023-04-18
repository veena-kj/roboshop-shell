pwd
cp user.service /etc/systemd/system/user.service
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
mkdir /app
curl -o /tmp/user.zip /https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
npm install
#cp user.service /etc/systemd/system/user.service
#Ensure you replace <MONGODB-SERVER-IPADDRESS> with IP address of mongodb in catalog service file
systemctl daemon-reload
systemctl enable user
systemctl restart user
cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host mongodb-dev.e-platform.online </app/schema/user.js
