cp mongo.repo /etc/yum.repos.d/mongo.repo
install mongodb-org -y
systemtl enable mongod
systemtl start mongod

#onfig file has to be edited : Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
