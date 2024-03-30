variable "s3_bucket" {
  type     = string
  nullable = false
}

variable "s3_key_prefix" {
  type     = string
  nullable = false
}

variable "source_directory" {
  type     = string
  nullable = false
}

variable "parameter_name" {
  type     = string
  nullable = false
}