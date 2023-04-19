pwd
source common.sh
echo -e "\e[36m*********Configuring NodeJs Repos**************\e[0m"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[36m**********Install NodeJs*************\e[0m"
yum install nodejs -y

echo -e "\e[36m********* Add Application user**************\e[0m"
useradd ${app_user}

echo -e "\e[36m********* Create application directory**************\e[0m"
mkdir /app

echo -e "\e[36m********* Download app content**************\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

echo -e "\e[36m********* go to app directory**************\e[0m"
cd /app
echo -e "\e[36m********* Unzip the app content in app directory**************\e[0m"
unzip /tmp/user.zip


echo -e "\e[36m********* Install dependencies **************\e[0m"
npm install
echo -e "\e[36m******** Create SystemD service ***************\e[0m"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service
#Ensure you replace <MONGODB-SERVER-IPADDRESS> with IP address of mongodb in catalog service file

echo -e "\e[36m********** Enable and start the user service *************\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user

echo -e "\e[36m******** Copy mongodb repo ***************\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m********** Install Mongodb client *************\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[36m********* Load schema **************\e[0m"
mongo --host mongodb-dev.e-platform.online </app/schema/user.js

echo -e "\e[36m***********************\e[0m"
