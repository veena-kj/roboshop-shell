script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

func_heading "Install nginx"
yum install nginx -y

func_heading "Remove the content"
rm -rf /usr/share/nginx/html/*
func_heading "Download the content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
func_heading "navigate to content location & Extract app content"
cd /usr/share/nginx/html
pwd
unzip /tmp/frontend.zip

func_heading "Configure reverse proxy"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf
func_heading "Enable nginx"
systemctl enable nginx
systemctl start nginx