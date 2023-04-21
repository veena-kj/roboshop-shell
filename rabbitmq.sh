script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[36m<<<<<<<<< creating Erlang repo file to support rabbitmq >>>>>>>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
echo -e "\e[36m<<<<<<<<< creating Rabbitmq repo file >>>>>>>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
echo -e "\e[36m<<<<<<<<< Install erlang and rabbitmq server >>>>>>>>\e[0m"
yum install erlang -y
yum install rabbitmq-server -y
echo -e "\e[36m<<<<<<<<< Enable&start Rabbitmq >>>>>>>>\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
echo -e "\e[36m<<<<<<<<< Start using rabbitmq services with new creds >>>>>>>>\e[0m"
rabbitmqctl add_user roboshop roboshop123
echo -e "\e[36m<<<<<<<<< Setting the permissions for rabbitmq service for new user >>>>>>>>\e[0m"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"