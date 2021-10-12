# Dynamic secrets can be revoked immediately after use, minimizing the amount of time the secret existed.

# 1 - Enable Secrets Engine
vault secrets enable aws_secret_engine

# 2 - Configuring Secrets Engine
export AWS_ACCESS_KEY_ID=<aws_access_key_id>
export AWS_SECRET_ACCESS_KEY=<aws_secret_key>

vault write aws_secret_engine/config/root \
    access_key=$AWS_ACCESS_KEY_ID \
    secret_key=$AWS_SECRET_ACCESS_KEY \
    region=us-east-1

# 3 - Create a role
# Vault knows how to create an IAM user via the AWS API, but it does not know what permissions, groups, and policies you want to attach to that user.
# here is an IAM policy that enables all actions on EC2, but not IAM or other AWS services.
vault write aws_secret_engine/roles/name_of_role \
        credential_type=iam_user \
        policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF

# 4 - Generate the secret
# Vault will connect to AWS and generate a new IAM user and key pair.
vault read aws_secret_engine/creds/name_of_role

# 5 - Revoke the secret
vault lease revoke aws_secret_engine/creds/name_of_role/0bce0782-32aa-25ec-f61d-c026ff22106