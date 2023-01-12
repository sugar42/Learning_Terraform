provider "aws" {
  region = "eu-central-1"
}
//variable for bucket name
variable "website_bucket_name" {
    type = string
}

resource "aws_s3_bucket" "website_bucket" {
  //bucket name
  bucket = var.website_bucket_name
  //access control list
  acl = "public-read"
  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
        {
        "Sid": "PublicReadForGetBucketObjects",
        "Effect": "Allowd",
        "Principal": {
            "AWS": "*"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${var.website_bucket_name}/*"
        }
    ]
}
EOF

    website {
    index_document = "index.html"
    }
}

output "website_url" {
    value = "http://${aws_s3_bucket.website_bucket.bucket}.s3-website.${}.amazonaws.com"
}

data "aws_region" "region" {
    //fetch region from provider above
}

resource "aws_s3_bucket_object" "index_upload" {
    bucket = aws_s3_bucket.website_bucket.bucket
    key = "index.html"

    source = "index.html"
    //returns html header
    content_type = "text/html"
  
}

