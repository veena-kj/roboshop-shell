script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

func_heading "Creating mongodb repo file"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
func_heading "installing mongodb"
yum install mongodb-org -y

func_heading "update listen address in mongodb config file"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

func_heading "Enable and start services"
systemctl enable mongod
systemctl restart mongod
netstat -lntp
