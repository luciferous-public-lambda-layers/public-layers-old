output "layer_arn" {
  value = aws_lambda_layer_version.layer.arn
}

output "layer_name" {
  value = aws_lambda_layer_version.layer.layer_name
}
