terraform {
  backend "s3" {
    bucket       = "taskapp-terraform-state-778939025602"
    key          = "taskapp/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
  }
}
