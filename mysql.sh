script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "mysql_root_password" ]; then
  echo mysql_root_password is missing
  exit
fi

func_heading "disabling  default version"
dnf module disable mysql -y
func_heading "Configuring mysql required version Repo files"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
func_heading "Install mysql server"
yum install mysql-community-server -y

func_heading Start using mysql servies with new root creds
mysql_secure_installation --set-root-pass ${mysql_root_password}
func_heading "Start&Enable mysqld"
systemctl enable mysqld
systemctl restart mysqld

