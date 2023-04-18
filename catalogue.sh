
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.repo /etc/yum.repos.d/mongo.repo
useradd roboshop
mkdir /app
curl -o /tmp/catalogue.zip /https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
npm install

#Ensure you replace <MONGODB-SERVER-IPADDRESS> with IP address of mongodb in catalog service file
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

yum install mongodb-org-shell -y
mongo --host mongodb-dev.e-platform.online </app/schema/catalogue.js
