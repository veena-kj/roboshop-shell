script_path = $(dirname $0)
source ${script_path}/common.sh
pwd
echo -e "\e[36m ************ Creating mongodb repo file*******************\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m ************ installing mongodb *******************\e[0m"
yum install mongodb-org -y

echo -e "\e[36m ************ update listen address in mongodb config file*******************\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

echo -e "\e[26m ***********Enable and start services **********\e[0m"
systemctl enable mongod
systemctl restart mongod

netstat -lntp
