echo -e "\e[36m<<<<<<<<< Install python  >>>>>>>>\e[0m"
yum install python36 gcc python3-devel -y
echo -e "\e[36m<<<<<<<<< Create app user  >>>>>>>>\e[0m"
useradd roboshop
echo -e "\e[36m<<<<<<<<< Create app directory  >>>>>>>>\e[0m"
mkdir /app
echo -e "\e[36m<<<<<<<<< Downlaod App content  >>>>>>>>\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
echo -e "\e[36m<<<<<<<<< changed to App directory  >>>>>>>>\e[0m"
cd /app
echo -e "\e[36m<<<<<<<<< Unzip the app content  >>>>>>>>\e[0m"
unzip /tmp/payment.zip

echo -e "\e[36m<<<<<<<<< Install dependencies  >>>>>>>>\e[0m"
pip3.6 install -r requirements.txt
echo -e "\e[36m<<<<<<<<< create systemD payment service file  >>>>>>>>\e[0m"
cp payment.service /etc/systemd/system/payment.service
echo -e "\e[36m<<<<<<<<< relaod daemon,Enable and restart payment service  >>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl start payment