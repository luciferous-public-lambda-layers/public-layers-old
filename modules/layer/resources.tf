locals {
  layer_name = sha256(var.parameter_name)
}

data "archive_file" "package" {
  type        = "zip"
  source_dir  = "${path.root}/${var.source_directory}"
  output_path = "${local.layer_name}.zip"
}

resource "aws_s3_object" "package" {
  bucket = var.s3_bucket
  key    = "${var.s3_key_prefix}/layer_packages/${data.archive_file.package.output_path}"
  source = data.archive_file.package.output_path
  etag   = data.archive_file.package.output_md5
}

resource "aws_lambda_layer_version" "layer" {
  layer_name       = local.layer_name
  description      = var.parameter_name
  s3_bucket        = aws_s3_object.package.bucket
  s3_key           = aws_s3_object.package.key
  source_code_hash = data.archive_file.package.output_base64sha256
}

resource "aws_ssm_parameter" "layer" {
  name  = var.parameter_name
  type  = "String"
  value = aws_lambda_layer_version.layer.arn
}
