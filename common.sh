script=$(realpath $0)
script_path=$(dirname $script)
app_user=roboshop

func_heading(){
  echo -e "\e[33m<<<<<<<<<< $1 >>>>>>>>>>>\e[0m"
  }

func_schema_setup(){
  if [ "$schema_setup" == "mongo" ];then
func_heading "copy the repo file for mongo client"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
func_heading "Install mongodb client"
yum install mongodb-org-shell -y
func_heading "load schema"
mongo --host mongodb-dev.e-platform.online </app/schema/catalogue.js
fi
}

func_nodejs(){
  func_heading "Configuring NodeJs Repo files"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  func_heading "Configuring NodeJs Repo files"
  yum install nodejs -y
  rm -rf /app
  func_heading "Create application user"
  useradd ${app_user}
  func_heading "Create app directory "
  mkdir /app
  func_heading "Download the application content "
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  func_heading "change to app directory"
  cd /app
  func_heading "Download the app content"
  unzip /tmp/${component}.zip
  func_heading "Install NodeJs dependencies"
  npm install
  func_heading "Create cart systemd service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  #cp cart.service /etc/systemd/system/cart.service
  #Ensure you replace <MONGODB-SERVER-IPADDRESS> with IP address of mongodb in catalog service file
  func_heading "Enable and start Cart"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
  func_schema_setup
}

