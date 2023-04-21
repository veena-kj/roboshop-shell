script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

func_heading "disabling  default version"
dnf module disable mysql -y
func_heading "Configuring mysql required version Repo files"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
func_heading "Install mysql server"
yum install mysql-community-server -y
func_heading "Start&Enable mysqld"
systemctl enable mysqld
systemctl start mysqld
func_heading Start using mysql servies with new root creds
mysql_secure_installation --set-root-pass RoboShop@1

