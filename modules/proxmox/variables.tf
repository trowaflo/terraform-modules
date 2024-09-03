### Proxmox provider configuration
variable "proxmox_endpoint" {
  description = "Proxmox endpoint"
  type        = string
}
variable "api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}
variable "private_key_path" {
  description = "SSH private key path"
  type        = string

}
variable "ssh_username" {
  description = "SSH username"
  type        = string
}
### Source template
variable "src_template_tag" {
  description = "Template tag"
  type        = list(string)
  default     = []
}
variable "src_template_filters" {
  description = "Template name"
  type        = map(list(string))
}
### VM configuration
variable "target_node" {
  description = "Proxmox node"
  type        = string
}
variable "vm_hostname" {
  description = "VM hostname"
  type        = string
}
variable "domain" {
  description = "VM domain"
  type        = string
}
variable "vm_tags" {
  description = "VM tags"
  type        = list(string)
  default     = []
}
variable "cpu_sockets" {
  description = "Number of sockets"
  type        = number
  default     = 1
}
variable "cpu_cores" {
  description = "Number of cores"
  type        = number
  default     = 1
}
variable "cpu_units" {
  description = "Number of cores"
  type        = number
  default     = 100
}
variable "memory_mb" {
  description = "Number of memory in MB"
  type        = number
  default     = 1024
}
variable "memory_floating" {
  description = "Number of memory in MB"
  type        = number
  default     = 0
}
variable "vga_type" {
  description = "VGA type"
  type        = string
  default     = "std"
}
variable "vga_memory" {
  description = "VGA memory"
  type        = number
  default     = 16
}
variable "network_bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}
variable "network_model" {
  description = "Network model"
  type        = string
  default     = "virtio"
}
variable "disk" {
  description = "Disk (size in Gb)"
  type = object({
    storage = string
    size    = number
  })
  default = {
    storage = "local-lvm"
    size    = 10
  }
}
variable "additionnal_disks" {
  description = "Additionnal disks"
  type = list(object({
    storage = string
    size    = number
  }))
  default = []
}
variable "vm_boot_order" {
  description = "VM boot order"
  type        = list(string)
  default     = ["scsi0"]
}
variable "vm_scsi_hardware" {
  description = "VM scsi hardware"
  type        = string
  default     = "virtio-scsi-single"
}
variable "onboot" {
  description = "Auto start VM when node is start"
  type        = bool
  default     = true
}
variable "qemu_guest_agent" {
  description = "Qemu guest agent"
  type        = bool
  default     = true
}
variable "qemu_guest_agent_trim" {
  description = "Qemu guest agent trim"
  type        = bool
  default     = false

}
variable "qemu_guest_agent_type" {
  description = "Qemu guest agent type"
  type        = string
  default     = "virtio"

}
variable "vm_user" {
  description = "User"
  type        = string
  sensitive   = true
  default     = "sysadmin"
}
### Cloud init
variable "cloud_user_config_file" {
  description = "Cloud init user config file"
  type        = string
  default     = "cloud-init/user_data"
}
variable "cloud_meta_config_file" {
  description = "Cloud init meta config file"
  type        = string
  default     = "cloud-init/meta_data"
}
