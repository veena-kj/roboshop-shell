script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_heading "Install nginx"
yum install nginx -y &>>$log_file
func_status_check $?
func_heading "copy roboshop config file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_status_check $?
func_heading "Clean old app content"
rm -rf /usr/share/nginx/html/*  &>>$log_file
func_status_check $?

func_heading "Download the app content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>> $log_file
func_status_check $?

func_heading "navigate to content location & Extract app content"
cd /usr/share/nginx/html  &>>$log_file
unzip /tmp/frontend.zip &>>log_file
func_status_check $?

#func_heading "Configure reverse proxy"
#cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf

func_heading "Enable & Start nginx"
systemctl enable nginx &>>$log_file
systemctl start nginx &>>$log_file
func_status_check $?
