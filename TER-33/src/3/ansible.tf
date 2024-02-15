resource "local_file" "ansible_inventory" {
  content       = templatefile("${path.module}/ansible_hosts.tftpl",
    {
        web     =  yandex_compute_instance.web,
        db      =  yandex_compute_instance.db,
        storage =  [yandex_compute_instance.storage_vm]
    }
)

  filename = "${abspath(path.module)}/hosts.cfg"
}
