script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

component=user
func_nodejs

func_heading "Copy mongodb repo"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

func_heading "Install Mongodb client"
yum install mongodb-org-shell -y
func_heading "Load schema"
mongo --host mongodb-dev.e-platform.online </app/schema/user.js

func_heading "check listening ports for mongod service "
netstat -lntp
