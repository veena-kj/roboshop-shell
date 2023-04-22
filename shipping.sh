script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo mysql_root_password is missing
  exit
fi

component=shipping
schema_setup=mysql
func_java
func_schema_setup

