# my-scripts
Useful scripts from my brain :D

## 1. aws-at-a-glance
This is a bash script (tested only on my Mac) that reaches out to AWS, retrieves the EC2 JSON data, and parses/displays it.

### Step 1: AWS CLI

Install the AWS CLI using their instructions, or just skip the click and use:

``
pip install awscli
``

Once installed, you should then go manually retrieve your Access Key from the IAM Console:

Instructions for snagging the access key/secret

Once you have these two values, run (in your shell of choice):

aws configure

It will ask you for both. You can specify the region in which your servers are mentioned. The default output format can be left as None.

### 2. Run script
Run chmod u+x to ensure it has execute permissions, and give it a run.

### 2. Output
