echo -e "\e[36m********* Install nginx **************\e[0m"
yum install nginx -y

echo -e "\e[36m********* Remove the content **************\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[36m********* Download the content **************\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[36m********* navigate to content location & Extract app content**************\e[0m"
cd /usr/share/nginx/html/
pwd
unzip /tmp/frontend.zip
echo -e "\e[36m********* Configure reverse proxy **************\e[0m"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[36m********* Enable nginx **************\e[0m"
systemctl enable nginx
systemctl restart nginx
