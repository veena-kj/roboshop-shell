script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_heading "Creating mongodb repo file"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_status_check $?

func_heading "installing mongodb"
yum install mongodb-org -y  &>>$log_file
func_status_check $?

func_heading "update listen address in mongodb config file"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf  &>>$log_file
func_status_check $?

func_heading "Enable and start MongoDB services"
systemctl enable mongod  &>>$log_file
systemctl restart mongod  &>>$log_file
func_status_check $?
