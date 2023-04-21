script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[36m<<<<<<<<< Install Maven >>>>>>>>\e[0m"
pwd
yum install maven -y
echo -e "\e[36m<<<<<<<<< Create App user >>>>>>>>\e[0m"
useradd ${app_user}
echo -e "\e[36m<<<<<<<<< Create app directory >>>>>>>>\e[0m"
mkdir /app

echo -e "\e[36m<<<<<<<<< Install Maven >>>>>>>>\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[36m<<<<<<<<< Download App content >>>>>>>>\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
echo -e "\e[36m<<<<<<<<< change to app directory >>>>>>>>\e[0m"
cd /app
echo -e "\e[36m<<<<<<<<< extract app content >>>>>>>>\e[0m"
unzip /tmp/shipping.zip
echo -e "\e[36m<<<<<<<<< Install Dependencies for Maven >>>>>>>>\e[0m"
cd /app
mvn clean package

echo -e "\e[36m<<<<<<<<< move the file  generated >>>>>>>>\e[0m"
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[36m<<<<<<<<< create systemD service file >>>>>>>>\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m<<<<<<<<< copy mysql repo file >>>>>>>\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[36m<<<<<<<<< Install mysql client >>>>>>>>\e[0m"
yum install mysql -y
echo -e "\e[36m<<<<<<<<< create new user n passwd to interact with mysql client to load schema >>>>>>>>\e[0m"
mysql -h mysqld.e-platform.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
echo -e "\e[36m<<<<<<<<< Enable & Start shipping Service >>>>>>>>\e"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping