yum install nginx -y
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip

#some files to create and configure the ip

systemctl enable nginx
systemctl start nginx
