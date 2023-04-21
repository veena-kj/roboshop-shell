script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
pwd

echo ${script}
echo ${script_path}

component=catalogue
func_nodejs

echo -e "\e[36m >>>>>> copy the repo file for mongo client<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m >>>> Install mongodb client  <<<<<<<\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[36m >>>> load schema <<<<<<<\e[0m"
mongo --host mongodb-dev.e-platform.online </app/schema/catalogue.js

