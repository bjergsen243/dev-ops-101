# How to deploy
```
terraform init --reconfigure
terraform workspace new dev
terraform plan --var-file="input.tfvars"
terraform apply --var-file="input.tfvars"
```

# How to destroy
```
terraform destroy --var-file="input.tfvars"
```

# Importent Note
- Please push 1 version to lambda ECR before running make lambda function