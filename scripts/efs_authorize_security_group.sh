#!/bin/bash
filesystemid=fs-1234a1b
region=us-east-1
#here tag name of ec2 worker nodes has "eks:cluster-name" in common , for now all cluster names starts with scrum, hence 'dev*' is used, needs to be update the clustername according tot he time of next run, other variables also needs to be updated accordingly

SGLIST=`aws ec2 describe-instances --filters "Name=tag:eks:cluster-name,Values=dev*" --query "Reservations[].Instances[].SecurityGroups[1].GroupId" --region $region --output json | cut -d, -f1| sort -n | uniq | grep "sg-" | tr -d '"' | tr -d ' ' |sed 1d`
echo "$SGLIST"
EFSTARGETID=`aws efs describe-mount-targets --file-system-id $filesystemid | awk '{ print $5}'`
echo "$EFSTARGETID"

echo "$EFSTARGETID" | while read LINE
do
EFSSG=`aws efs describe-mount-target-security-groups --mount-target-id $LINE | awk '{ print $2}'`

echo $LINE
for i in `echo "$SGLIST"`
do
aws ec2 authorize-security-group-ingress --group-id $EFSSG --protocol tcp --port 2049 --source-group "$i" --region $region
done
done
