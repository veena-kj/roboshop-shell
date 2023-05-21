script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_heading "Install Redis repos"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>>log_file
func_heading "Install Redis"
dnf module enable redis:remi-6.2 -y &>>log_file
yum install redis -y &>>$log_file
func_status_check $?

func_heading  "update listen address Redis"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf  &>>$log_file
func_status_check $?

#Usually Redis opens the port only to localhost(127.0.0.1), meaning this service can be accessed by the application that is hosted on this server only. However, we need to access this service to be accessed by another server, So we need to change the config accordingly.
#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf
func_heading "Enable and start Redis service"
systemctl enable redis &>>log_file
systemctl start redis &>>log_file
func_status_check $?