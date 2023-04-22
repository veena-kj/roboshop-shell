script=$(realpath $0)
script_path=$(dirname $script)
app_user=roboshop

func_heading(){
   echo -e "\e[33m<<<<<<<<<< $1 >>>>>>>>>>>\e[0m"
  }

func_status_check(){
  if [ $? -eq 0 ];then
    echo -e "\e[32mSUCCESS\e[0m"
    else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi
}


func_schema_setup(){
  if [ "$schema_setup" == "mongo" ];then

func_heading "copy the repo file for mongo client"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
func_heading "Install mongodb client"
yum install mongodb-org-shell -y
func_heading "load schema"
mongo --host mongodb-dev.e-platform.online </app/schema/${component}.js
func_status_check $?
fi

 if [ "$schema_setup" == "mysql" ]; then
 func_heading "copy mysql repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
func_heading "Install mysql client"
yum install mysql -y
func_heading "provide mysql root user passwd to interact with mysql to load schema"
mysql -h mysqld.e-platform.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
func_status_check $?
fi

}
func_app_prereq(){

func_heading "Create application user"
useradd ${app_user}
func_heading "Create application directory "
rm -rf /app
mkdir /app
func_heading "Download the application content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
func_heading "change to application directory"
cd /app
func_heading "Download the application content"
unzip /tmp/${component}.zip
func_status_check $?
}

func_systemd_setup(){
  func_heading "create systemD service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  func_status_check $?
  func_schema_setup
  func_heading "Enable & Start ${component} Service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
  func_status_check $?
}



func_nodejs(){
  func_heading  "Configuring NodeJs Repo files"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  func_heading "Installing NodeJs Repo files"
  yum install nodejs -y
 func_status_check $?
  func_app_prereq

  func_heading "Install NodeJs dependencies"
  npm install
 func_status_check $?
  func_schema_setup
  func_systemd_setup
}


func_java(){
func_heading "Install Maven"
yum install maven -y
rm -rf /app
func_status_check $?
func_app_prereq
func_heading "Install Dependencies for Maven"
mvn clean package
func_status_check $?
func_heading "move the file  generated"
mv target/${component}-1.0.jar ${component}.jar
func_status_check $?
func_schema_setup
func_systemd_setup
pwd
}
