echo -e "\e[36m<<<<<<<<< Install Maven >>>>>>>>\e[0m"
yum install maven -y
echo -e "\e[36m<<<<<<<<< Create App user >>>>>>>>\e[0m"
useradd roboshop
echo -e "\e[36m<<<<<<<<< Create app directory >>>>>>>>\e[0m"
mkdir /app
e
echo -e "\e[36m<<<<<<<<< Install Maven >>>>>>>>\e[0m"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[36m<<<<<<<<< Download App content >>>>>>>>\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
echo -e "\e[36m<<<<<<<<< change to app directory >>>>>>>>\e[0m"
cd /app
echo -e "\e[36m<<<<<<<<< Unzip app content >>>>>>>>\e[0m"
unzip /tmp/shipping.zip
echo -e "\e[36m<<<<<<<<< Install Dependencies for Maven >>>>>>>>\e[0m"
cd /app
mvn clean package

echo -e "\e[36m<<<<<<<<< move the file generated >>>>>>>>\e[0m"
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[36m<<<<<<<<< create systemD service file >>>>>>>>\e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service
echo -e "\e[36m<<<<<<<<< Enable & Start shipping Service >>>>>>>>\e"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping
echo -e "\e[36m<<<<<<<<< copy mysql repo file >>>>>>>\e[0m"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[36m<<<<<<<<< Install mysql client >>>>>>>>\e[0m"
yum install mysql -y
echo -e "\e[36m<<<<<<<<< create new user n passwd to interact with mysql client to load schema >>>>>>>>\e[0m"
mysql -h mysqld.e-platform.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
echo -e "\e[36m<<<<<<<<< restart shipping service >>>>>>>>\e[0m"
systemctl restart shipping