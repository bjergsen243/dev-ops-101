# AlbumPix Terraform

## Important Note

- This is Terraform code to deploy a project on AWS
- This was deployed by AWS Account ID
- Please direct message to Mr.Hai for more information about this account
- Please checkout to branch `albumpik-prod` for Production environment
- Please checkout to branch `dev` for Development environment

## Setup

0. Please make sure you checkout to the correct branch as I mentioned above! Then you are good to do those steps below!
1. First you need to create your own SSH Key for AWS Account and import it into `input.tfvars` file
2. Create AWS profile

```bash
aws configure --profile ALBUMPIX-Prod
```

3. Create Hosted Zone on AWS Console
4. Then you can deploy with these commands below

## How to deploy

```bash
terraform init --reconfigure
terraform workspace new prod
terraform plan --var-file="input.tfvars"
terraform apply --var-file="input.tfvars"
```

## How to destroy

```bash
terraform destroy --var-file="input.tfvars"
```
