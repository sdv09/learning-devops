#locals {
#  db_vm_name    = "${var.proj}-${var.env}-${var.app}-db"
#  web_vm_name   = "${var.proj}-${var.env}-${var.app}-web"
#}
locals {
  ssh_key_path = "/home/sdvvm01/.ssh/id_rsa.pub"
}
