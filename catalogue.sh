script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
pwd

echo ${script}
echo ${script_path}

component=catalogue
schema_setup=mongo
func_nodejs