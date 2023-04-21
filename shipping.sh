script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "mysql_root_password" ] then
  echo mysql_root_password is missing
  exit
fi

func_heading "Install Maven"
pwd
yum install maven -y
func_heading "Create App user"
useradd ${app_user}
func_heading "Create app directory"
rm -rf /app
mkdir /app

func_heading "Install Maven"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
func_heading "Download App content"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
func_heading "change to app directory"
cd /app
func_heading "extract app content"
unzip /tmp/shipping.zip
func_heading "Install Dependencies for Maven"
cd /app
mvn clean package

func_heading "move the file  generated"
mv target/shipping-1.0.jar shipping.jar
func_heading "create systemD service file"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

func_heading "copy mysql repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
func_heading "Install mysql client"
yum install mysql -y
func_heading "provide mysql root user passwd to interact with mysql client to load schema"
mysql -h mysqld.e-platform.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
func_heading "Enable & Start shipping Service"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping