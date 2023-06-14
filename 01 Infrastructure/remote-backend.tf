# resource "aws_s3_bucket" "terra_backend_bucket" {
#     bucket = "the-nice-terra-backend-state-bucket"
#     lifecycle {prevent_destroy = true}
# }
# resource "aws_s3_bucket_versioning" "enabled"{
#     bucket =   aws_s3_bucket.terra_backend_bucket.id
#     versioning_configuration {status = "Enabled"}
# }
# resource "aws_dynamodb_table" "terra_locks"{
#     name = "terra-backend-state-lock"
#     billing_mode = "PAY_PER_REQUEST"
#     hash_key = "LockID"
#     attribute {
#         name = "LockID"
#         type  = "S"
#     }
# }

# # # #this block will not work untill you created the bucket, dynamdb .. before applying this.
terraform{
    backend "s3" {
        profile = "terraform"
        bucket = "the-nice-terra-backend-state-bucket"
        key = "Dev/terraform.tfstate"   # just a path inside the bucket and file name
        region = "us-east-1"
        dynamodb_table = "terra-backend-state-lock"
        encrypt =  true
    }
}

# #terraform force-unlock --force <....lock..id....>