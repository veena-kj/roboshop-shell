script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[36m*******Install Redis repos******\e[0m "
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
echo -e "\e[36m*******Install Redis*****\e[0m"
dnf module enable redis:remi-6.2 -y
yum install redis -y
echo -e "\e[36m*******update listen address Redis*****\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf
#Usually Redis opens the port only to localhost(127.0.0.1), meaning this service can be accessed by the application that is hosted on this server only. However, we need to access this service to be accessed by another server, So we need to change the config accordingly.
#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf
echo -e "\e[36m*******Enable and start Redis service*****\e[0m"
systemctl enable redis
systemctl start redis