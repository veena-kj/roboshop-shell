script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[36m<<<<<<<<< Configuring mysql required version Repo files >>>>>>>>\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[36m<<<<<<<<< disabling  default version repo files >>>>>>>>\e[0m"
dnf module disable mysql -y
echo -e "\e[36m<<<<<<<<< Install mysql server >>>>>>>>\e[0m"
yum install mysql-community-server -y
echo -e "\e[36m<<<<<<<<< Start&Enable mysqld >>>>>>>>\e[0m"
systemctl enable mysqld
systemctl start mysqld
echo -e "\e[36m<<<<<<<<< Start using mysql servies with new root creds >>>>>>>>\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1

