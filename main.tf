terraform {
    backend "s3" {
        bucket         = "tf-bucket-test-dhan"
        key            = "terraform.tfstate"
        region         = "us-east-2"
        # profile = "default"
        dynamodb_table = "tf-db-test-dhan"
    }
}