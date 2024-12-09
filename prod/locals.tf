locals {
  env                = "prod"
  region             = "us-east-1"
  random_lambda_name = "terraformbootcamp_random_lambda_${local.env}"
  tags = {
    course = "terraform_bootcamp"
    env    = local.env
    region = local.region
  }
}