# shell-scripts
Requirement: 
Update a set of EC2 instance's security groups ID on EFS security groups
EFS are being used by pods running on kubernetes, so need to collect the security group ID of worker nodes and put it on EFS's security group
our EKS cluster's worker nodes are enabled with tags that has clustername tagged.
this script has way to get the SG of worker nodes and EFS mount points , the inputs are clustername,region, EFS filesystemID

