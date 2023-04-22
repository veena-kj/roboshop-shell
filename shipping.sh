script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "mysql_root_password" ]; then
  echo mysql_root_password is missing
  exit
fi
func_java
pwd
component=shipping
schema_setup=mysql
func_schema_setup

