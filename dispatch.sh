script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

func_heading "Install golang"
pwd
yum install golang -y
func_heading "Create App user"
useradd ${app_user}
func_heading "Create app directory"
mkdir /app
pwd
func_heading "Download the app content"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
pwd
func_heading "go to app directory"
cd /app
func_heading "Unzip app content"
unzip /tmp/dispatch.zip
pwd

func_heading "Install dependencies"
go mod init dispatch
go get
go build
func_heading "setup systemD service"
sed -i -e "s|rabbitmq_appuser_password|{rabbitmq_appuser_password}" ${script_path}/dispatch.service
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service
pwd
func_heading Reload Enable and start dispatch servie
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch
pwd