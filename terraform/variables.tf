variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_ami" {
  type    = string
  # Amazon Linux 2 (commonly used). If your region differs, update this AMI.
  default = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "lambda_zip_path" {
  type    = string
  default = "./lambda.zip"
}
