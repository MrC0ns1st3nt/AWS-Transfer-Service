output "sftp-transfer-server-arn" {
    value = "${aws_transfer_server.server.arn}"
}
output "sftp-transfer-server-id" {
    value = "${aws_transfer_server.server.id}"
}
output "sftp-transfer-server-endpoint" {
    value = "${aws_transfer_server.server.endpoint}"
}

output "sftp-server-dns" {
    value = "${aws_route53_record.www.fqdn}"
}
