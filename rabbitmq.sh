script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "rabbitmq_appuser_password" ]; then
  echo rabbitmq_appuser_password is missing
  exit 1
fi

func_heading "creating Erlang repo file to support rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
func_heading "creating Rabbitmq repo file"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
func_heading "Install erlang and rabbitmq server"
yum install erlang -y
yum install rabbitmq-server -y
func_heading "Enable&start Rabbitmq"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
func_heading "Start using rabbitmq services with new creds"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
func_heading "Setting the permissions for rabbitmq service for new user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"