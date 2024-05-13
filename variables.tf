variable "host_os" {
	type = string
	default = "windows"
}

variable "AWS_REGION" {
  description = "The AWS region to deploy resources in"
  type        = string
}
