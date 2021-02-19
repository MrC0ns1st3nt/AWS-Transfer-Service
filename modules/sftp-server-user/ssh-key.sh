#!/bin/bash
ENV=$1
SERVERID=$2
USERNAME=$3

echo "####"
echo "CREATING SSH KEYS"

yes "y" | ssh-keygen -t rsa -C $ENV-sftp-server-ssh-key -N "" -m PEM -f $ENV-sftp-server-ssh-key

echo "SSH CREATION COMPLETED!!"

echo "STORING SECRETS (SSH KEY - private key) INTO SECRETS MANAGER"
echo "FILE NAME: $ENV-sftp-server-ssh-key"

aws secretsmanager put-secret-value --secret-id $ENV-$USERNAME-sftp-server-ssh-key --secret-string file://$ENV-sftp-server-ssh-key

echo "DONE SECRETS MANAGER STORED THE PRIVATE KEY"


PUBKEY=`cat $ENV-sftp-server-ssh-key.pub | tr -d '\r'`

aws transfer import-ssh-public-key --server-id $SERVERID --ssh-public-key-body "$PUBKEY" --user-name $USERNAME

rm -rf $ENV-sftp-server-ssh-key
rm -rf $ENV-sftp-server-ssh-key.pub

echo "######"

exit $?
