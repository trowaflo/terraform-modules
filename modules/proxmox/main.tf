data "proxmox_virtual_environment_vms" "template" {
  node_name = var.target_node
  tags      = var.src_template_tag

  dynamic "filter" {
    for_each = var.src_template_filters
    content {
      name   = filter.key
      values = filter.value
    }
  }
}
resource "proxmox_virtual_environment_vm" "vm" {
  name      = "${var.vm_hostname}.${var.domain}"
  node_name = var.target_node

  on_boot = var.onboot

  agent {
    enabled = var.qemu_guest_agent
    trim    = var.qemu_guest_agent_trim
    type    = var.qemu_guest_agent_type
  }

  tags = [for tag in var.vm_tags : lower(tag)]

  cpu {
    sockets = var.cpu_sockets
    cores   = var.cpu_cores
    units   = var.cpu_units
    type    = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
    floating  = var.memory_floating
  }

  vga {
    type   = var.vga_type
    memory = var.vga_memory
  }

  network_device {
    bridge      = var.network_bridge
    mac_address = var.network_mac_address
    model       = var.network_model
  }
  # Ignore changes to the network
  ## MAC address is generated on every apply, causing
  ## TF to think this needs to be rebuilt on every apply
  lifecycle {
    prevent_destroy = var.vm_enable_prevent_destroy_vm
    ignore_changes = [
      network_device,
    ]
  }

  boot_order    = var.vm_boot_order
  scsi_hardware = var.vm_scsi_hardware

  dynamic "disk" {
    for_each = var.additionnal_disks
    content {
      interface    = "scsi${1 + disk.key}"
      iothread     = true
      datastore_id = disk.value.storage
      size         = disk.value.size
      discard      = "ignore"
      file_format  = "raw"
    }
  }

  clone {
    vm_id = data.proxmox_virtual_environment_vms.template.vms[0].vm_id
  }

  initialization {
    # ip_config {
    #   ipv4 {
    #     address = "dhcp"
    #   }
    # }

    datastore_id      = "local-lvm"
    interface         = "ide2"
    user_data_file_id = proxmox_virtual_environment_file.cloud_user_config.id
    meta_data_file_id = proxmox_virtual_environment_file.cloud_meta_config.id
  }
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.vm.id
}
output "vm_ip" {
  value = proxmox_virtual_environment_vm.vm.ipv4_addresses
}

resource "proxmox_virtual_environment_file" "cloud_user_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.target_node

  source_raw {
    data = templatefile(var.cloud_user_config_file,
      {
        domain   = var.domain
        hostname = var.vm_hostname
      }
    )

    file_name = "${var.vm_hostname}.${var.domain}-ci-user.yml"
  }
}
resource "proxmox_virtual_environment_file" "cloud_meta_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.target_node

  source_raw {
    data = templatefile(var.cloud_meta_config_file,
      {
        instance_id    = sha1(var.vm_hostname)
        local_hostname = var.vm_hostname
      }
    )

    file_name = "${var.vm_hostname}.${var.domain}-ci-meta_data.yml"
  }
}
