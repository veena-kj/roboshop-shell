pwd
cp cart.service /etc/systemd/system/cart.service
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
mkdir /app
curl -o /tmp/cart.zip /https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
npm install
#cp cart.service /etc/systemd/system/cart.service
#Ensure you replace <MONGODB-SERVER-IPADDRESS> with IP address of mongodb in catalog service file
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
