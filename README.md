AWS Transfer Family service. 

The Terraform supplied can easily be used to build a working SFTP service and VPC endpoint in your account and attaching a Route53 record. 

This also creates the SSH public / private keys used by the service for access. The Private key is sent to Secrets Manager and the public key is attached to the user account within the SFTP service.

This is the first version and is attempting to allow a series of variables to be passed through in order to customise:

1. SFTP username
2. Home Directory
3. IAM policy actions attached to user/s role 
4. IAM policy resources attached to user/s role

- Could it have been written better? Most definitely. 
- Does it work for what I need to use it for? Yes it does. 
- Am I going to improve? At some point, yes. 

The version of Terraform used is 0.14.2. 


## List of variables

The following are used in the sftp user module:

- for_each = Paired with sftp-user when passing more than one user name
- s3-bucket = The variable for the S3-bucket used as default by the SFTP service.
- s3-bucketlist = This is used by the SFTP user module when creating the IAM policy. In my usage case it is the same as the s3-bucket variable. 
- s3-actions = This is used to overwrite the default readonly provided to the sftp user. (Optional)
- sftp-user = Create a single user or mutliple users with the same permissions. Paired with for_each. Defaults to test user if not present
- s3-prefix = This builds the IAM policy attached to the sftp user role. Format is <bucketname/prefix>
- sftp-home-directory = Specify the bucket prefix or leave blank for bucket level



