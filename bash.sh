VAR=$1

START=$(date +%s.%N)

rsync -a --exclude='.git/' local   ubuntu@$SERVER:/there
eval $@ 2>&1 | tee log.log
ssh -t ubuntu@$SERVER "timeout 120 tail -n 50 -f .bashrc"
[ -f ./number_cruncher ] || { echo 'FAILED' ; exit 1; }


if [ "$VAR" = "val" ] || [ "$VAR" = "val" ]; then else fi
if [ "$VAR" = "val" ]; then exit 1; fi # Only sync
if (($VAR%8 == 0)); then

aws s3 rm s3://bucket/ --recursive

END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)

alias htest=""

FILE=file.ip
getip(){ export IP=$(head -n 1 $FILE) }
start(){
    CIP=$(head -n 1 $FILE) 
}

ID='i-0000'
start(){ 
    if [ -n "$1" ]; then id=$1; else id=$ID; fi
    aws ec2 start-instances --instance-ids $id > /dev/null; 
    aws ec2 describe-instances --instance-ids $id --query "Reservations[].Instances[].PublicIpAddress" --output text > $FILE
    export CIP=$(head -n 1 $FILE)
}



ips=$(aws ec2 describe-instances --query "Reservations[].Instances[].[PublicIpAddress,Tags[?Key=='Name']| [0].Value]" --output table \
| grep 'val1\|val2' \
| cut -c4-17)

while read ip
do
  ssh ubuntu@$ip "docker image ls" < /dev/null &
done <<< $ips
