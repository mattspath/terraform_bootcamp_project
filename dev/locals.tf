locals {
  env                = "dev"
  region             = "us-west-2"
  random_lambda_name = "terraformbootcamp_random_lambda_${local.env}"
  tags = {
    course = "terraform_bootcamp"
    env    = local.env
    region = local.region
  }
}