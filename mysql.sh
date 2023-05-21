script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo mysql_root_password is missing
  exit 1
fi

func_heading "disabling default version MysQL 8"
dnf module disable mysql -y &>>$log_file
func_status_check $?

func_heading "Configuring mysql required version Repo files"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_status_check $?

func_heading "Install mysql server"
yum install mysql-community-server -y &>>$log_file
func_status_check $?

func_heading "Start using mysql services with new root creds- Rest MySQL Password"
mysql_secure_installation --set-root-pass $mysql_root_password  &>>$log_file
func_status_check $?

func_heading "Start & Enable mysqld"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_status_check $?

