script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
rabbitmq_appuser_password=$1
if [ -z "rabbitmq_appuser_password"]; then
  echo  rabbitmq_appuser_password missing
  exit 1
fi

func_heading "Install python "
yum install python36 gcc python3-devel -y
func_heading "Create app user"
useradd ${app_user}
func_heading "Create app directory"
mkdir /app
func_heading "Downlaod App content"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
func_heading "changed to App directory"
cd /app
func_heading "Unzip the app content"
unzip /tmp/payment.zip

func_heading "Install dependencies"
pip3.6 install -r requirements.txt
func_heading "create systemD payment service file"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

func_heading "reload daemon,Enable and restart payment service"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment
