echo -e "\e[36m<<<<<<<<< creating Erlang repo file to support rabbitmq >>>>>>>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
echo -e "\e[36m<<<<<<<<< creating Rabbitmq repo file >>>>>>>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
echo -e "\e[36m<<<<<<<<< Install erlang and rabbitmq server >>>>>>>>\e[0m"
yum install erlang -y
yum install rabbitmq-server -y
echo -e "\e[36m<<<<<<<<< Enable&start Rabbitmq >>>>>>>>\e[0m"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
echo -e "\e[36m<<<<<<<<< Start using rabbitmq services with new creds >>>>>>>>\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"