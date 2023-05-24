app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log
# rm -f $log_file

func_heading(){
   echo -e "\e[33m<<<<<<< $1 >>>>>>>>\e[0m"
   echo -e "\e[33m<<<<<<<<<< $1 >>>>>>>>>>>\e[0m" &>>$log_file
  }

func_status_check(){
  if [ $? -eq 0 ];then
    echo -e "\e[32mSUCCESS\e[0m"
    else
    echo -e "\e[31mFAILURE\e[0m"
    echo refer /tmp/roboshop.log file for details
    exit 1
  fi
}


func_schema_setup(){
  if [ "$schema_setup" == "mongo" ];then

func_heading "copy the repo file for mongo client"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_status_check $?

func_heading "Install mongodb client"
yum install mongodb-org-shell -y &>>$log_file
func_status_check $?

func_heading "load schema"
mongo --host mongodb-dev.e-platform.online </app/schema/${component}.js &>>$log_file
func_status_check $?
fi

 if [ "${schema_setup}" == "mysql" ]; then

 func_heading "copy mysql repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_status_check $?

func_heading "Install mysql client"
yum install mysql -y &>>$log_file
func_status_check $?

func_heading "provide mysql root user passwd to interact with mysql to load schema"
mysql -h mysql.e-platform.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$log_file
func_status_check $?

fi

}
func_app_prereq(){

func_heading "Create application user"

id ${app_user} &>>$log_file
if [ $? -ne 0 ]; then
useradd ${app_user} &>>$log_file
fi
func_status_check $?

func_heading "Create application directory "
rm -rf /app &>>$log_file
mkdir /app &>>$log_file
func_status_check $?

func_heading "Download the application content"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
func_status_check $?

func_heading "change to application directory"
cd /app &>>$log_file
func_status_check $?

func_heading "extract the application content"
unzip /tmp/${component}.zip &>>$log_file
func_status_check $?
}

func_systemd_setup(){

  func_heading "Setup systemD service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  func_status_check $?

  func_heading "Enable & Start ${component} Service"
  systemctl daemon-reload &>>$log_file
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  func_status_check $?
}
func_nodejs(){
  func_heading  "Configuring NodeJs Repo files"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>$log_file
  func_status_check $?

  func_heading "Installing NodeJs Repo files"
  yum install nodejs -y &>>$log_file
 func_status_check $?

  func_app_prereq

  func_heading "Install NodeJs dependencies"
  npm install &>>$log_file
 func_status_check $?

  func_schema_setup
  func_systemd_setup
}

func_java(){
func_heading "Install Maven"
yum install maven -y &>>$log_file
func_status_check $?
func_app_prereq
func_heading "download Dependencies for Maven"
mvn clean package &>>$log_file
func_status_check $?
func_heading "move the file  generated"
mv target/${component}-1.0.jar ${component}.jar &>>$log_file
func_status_check $?
func_schema_setup
func_systemd_setup
}
func_python() {
func_heading "install python"
yum install python36 gcc python3-devel -y &>>$log_file
func_status_check $?
func_app_prereq
func_heading "Install python dependencies"
pip3.6 install -r requirements.txt &>>$log_file
func_status_check $?
func_heading "update password"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/payment.service &>>$log_file
func_stat_check $?
func_systemd_setup
}

func_golang() {
  func_heading "Install golang"
  yum install golang -y &>>$log_file
  func_status_check $?
  func_app_prereq


  func_heading "Install dependencies"
  go mod init dispatch &>>$log_file
  go get  &>>$log_file
  go build &>>$log_file
  func_status_check $?

  func_heading "setup rabbitmq app user password"
  sed -i -e "s|rabbitmq_appuser_password|{rabbitmq_appuser_password}" ${script_path}/dispatch.service  &>>$log_file

  func_status_check $?
  func_systemd_setup

}