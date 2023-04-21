script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[36m<<<<<<<<< Install golang >>>>>>>>\e[0m"
pwd
yum install golang -y
echo -e "\e[36m<<<<<<<<< Create App user >>>>>>>>\e[0m"
useradd ${app_user}
echo -e "\e[36m<<<<<<<<< Create app directory >>>>>>>>\e[0m"
mkdir /app
pwd
echo -e "\e[36m<<<<<<<<< Download the app content >>>>>>>>\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
pwd
echo -e "\e[36m<<<<<<<<< go to app directory >>>>>>>>\e[0m"
cd /app
echo -e "\e[36m<<<<<<<<< Unzip app content >>>>>>>>\e[0m"
unzip /tmp/dispatch.zip
pwd

echo -e "\e[36m<<<<<<<<< Install dependencies >>>>>>>>\e[0m"
go mod init dispatch
go get
go build
echo -e "\e[36m<<<<<<<<< setup systemD service >>>>>>>>\e[0m"
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service
pwd
echo -e "\e[36m<<<<<<<<< Reload Enable and start dispatch servie  >>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch
pwd