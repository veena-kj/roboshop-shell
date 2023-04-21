script=$(realpath $0)
script_path=$(dirname $script)
app_user=roboshop

func_heading(){
  echo -e "\e[33m<<<<<<<<<< $1 >>>>>>>>>>>\e[0m"
  }

func_nodejs(){

  func_heading "Configuring NodeJs Repo files"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_heading Configuring NodeJs Repo files
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

}