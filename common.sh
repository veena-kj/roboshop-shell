app_user=roboshop

func_nodejs(){

  echo -e "\e[36m<<<<<<<<< Configuring NodeJs Repo files >>>>>>>>\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[36m<<<<<<<<< Configuring NodeJs Repo files >>>>>>>>\e[0m"
  yum install nodejs -y
  rm -rf /app
  echo -e "\e[36m<<<<<<<<< Create application user  >>>>>>>>\e[0m"
  useradd ${app_user}
  echo -e "\e[36m<<<<<<<<< Create app directory >>>>>>>>\e[0m"
  mkdir /app
  echo -e "\e[36m<<<<<<<<< Download the application content >>>>>>>>\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  echo -e "\e[36m<<<<<<<<< change to app directory  >>>>>>>>\e[0m"
  cd /app
  echo -e "\e[36m<<<<<<<<< Download the app content >>>>>>>>\e[0m"
  unzip /tmp/${component}.zip
  echo -e "\e[36m<<<<<<<<< Install NodeJs dependencies >>>>>>>>\e[0m"
  npm install
  echo -e "\e[36m<<<<<<<<< Create cart systemd service >>>>>>>>\e[0m"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  #cp cart.service /etc/systemd/system/cart.service
  #Ensure you replace <MONGODB-SERVER-IPADDRESS> with IP address of mongodb in catalog service file
  echo -e "\e[36m<<<<<<<<< Enable and start Cart >>>>>>>>\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

}