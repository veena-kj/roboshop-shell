echo -e "\e[36m>>>>>>>>>>>> configuring nodejs repos <<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
echo -e "\e[36m >>>>>>>create application directory and user <<<<<<<\e[0m"
useradd roboshop
mkdir /app

echo -e "\e[36m >>>>>>download application content <<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[36m >>>> Install dependencies <<<<<<\e[0m"
npm install

echo -e "\e[36m >>>>>>> copy catalogue systemD file <<<<<<<<<<\e[om"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m >>>>> start the services <<<<<<<\e[0m"

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
echo -e "\e[36m >>>>>> copy the repo file for mongo client<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m >>>> Install mongodb client  <<<<<<<\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[36m >>>> load schema <<<<<<<\e[0m"
mongo --host mongodb-dev.e-platform.online </app/schema/catalogue.js

