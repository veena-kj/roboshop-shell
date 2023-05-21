script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "rabbitmq_appuser_password" ]; then
  echo rabbitmq_appuser_password is missing
  exit 1
fi

func_heading "creating Erlang repo file to support rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>log_file
func_status_check $?
func_heading "creating Rabbitmq repo file"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>log_file
func_status_check $?
func_heading "Install erlang and rabbitmq server"
yum install erlang -y &>>$log_file
func_status_check $?
yum install rabbitmq-server -y &>>$log_file
func_status_check $?
func_heading "Enable&start Rabbitmq"
systemctl enable rabbitmq-server  &>>$log_file
systemctl restart rabbitmq-server &>>$log_file
func_status_check $?
func_heading "Start using rabbitmq services with new creds"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}  &>>$log_file
func_status_check $?
func_heading "Setting the permissions for rabbitmq service for new user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$log_file
func_status_check $?