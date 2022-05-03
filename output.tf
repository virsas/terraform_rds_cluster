output "endpoint" {
  value = aws_rds_cluster.cluster.endpoint
}

output "reader-endpoint" {
  value = aws_rds_cluster.cluster.reader_endpoint
}