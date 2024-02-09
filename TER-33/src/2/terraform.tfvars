proj    = "netology"
env     = "develop"
app     = "platform"
vms_resources = {
  web = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  },
  db = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}
metadata = {
  platform = {
     serial_port_enable = 1
     ssh_keys = "ubuntu:ssh-rsa = DYS5324@MOSDYS5324"
  }
}
