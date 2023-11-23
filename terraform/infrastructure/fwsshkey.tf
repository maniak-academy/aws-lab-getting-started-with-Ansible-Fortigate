resource "tls_private_key" "fwsshkey" {
  algorithm = "RSA"
}

resource "aws_key_pair" "fwsshkey" {
  key_name   = "sshfwkey"  # Set a simple name for the key pair
  public_key = tls_private_key.fwsshkey.public_key_openssh
}

resource "null_resource" "key" {
  # Ensures the key is created before trying to create the file
  depends_on = [aws_key_pair.fwsshkey]

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.fwsshkey.private_key_pem}\" > sshfwkey.pem"
  }

  provisioner "local-exec" {
    command = "chmod 600 sshfwkey.pem"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f sshfwkey.pem"
  }
}
