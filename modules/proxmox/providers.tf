provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.api_token
  insecure  = false
  ssh {
    agent    = true
    username = var.ssh_username
    private_key = file(var.private_key_path)
  }
}
