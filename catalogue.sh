script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
pwd

echo ${script}
echo ${script_path}

component=catalogue
func_nodejs
func_heading "copy the repo file for mongo client"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

func_heading "Install mongodb client"
yum install mongodb-org-shell -y
func_heading "load schema"
mongo --host mongodb-dev.e-platform.online </app/schema/catalogue.js

