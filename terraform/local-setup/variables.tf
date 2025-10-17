variable proxmox_api_url {
  type = string
}

variable proxmox_api_token_id {
  type = string
}

variable proxmox_api_token {
  type = string
}


variable vm_configs {
  type = map(object({
    vm_id       = number
    name        = string
    memory      = number
    vm_state    = string
    onboot      = bool
    startup     = string
    ipconfig    = string
    ciuser      = string
    cipassword  = string
    cores       = number
    bridge      = string
    network_tag = number
  }))
  default = {
    "master-node1" = {
      vm_id       = 300
      name        = "master-1"
      memory      = 4096
      vm_state    = "stopped"
      onboot      = true
      startup     = "order=1"
      ipconfig    = "ip=192.168.0.3/24,gw=192.168.0.1"
      ciuser      = "root"
      cipassword  = "zaq12wsx"
      cores       = 2
      bridge      = "vmbr0"
      network_tag = 0
    },
    # "master-node2" = {
    #   vm_id       = 301
    #   name        = "master-2"
    #   memory      = 4096
    #   vm_state    = "stopped"
    #   onboot      = true
    #   startup     = "order=1"
    #   ipconfig    = "ip=192.168.0.4/24,gw=192.168.0.1"
    #   ciuser      = "root"
    #   cipassword  = "zaq12wsx"
    #   cores       = 2
    #   bridge      = "vmbr0"
    #   network_tag = 0
    # },
    # "master-node3" = {
    #   vm_id       = 302
    #   name        = "master-3"
    #   memory      = 2048
    #   vm_state    = "stopped"
    #   onboot      = true
    #   startup     = "order=1"
    #   ipconfig    = "ip=192.168.0.5/24,gw=192.168.0.1"
    #   ciuser      = "root"
    #   cipassword  = "zaq12wsx"
    #   cores       = 2
    #   bridge      = "vmbr0"
    #   network_tag = 0
    # },
    "worker-node1" = {
      vm_id       = 303
      name        = "worker-1"
      memory      = 4096
      vm_state    = "stopped"
      onboot      = true
      startup     = "order=1"
      ipconfig    = "ip=192.168.0.6/24,gw=192.168.0.1"
      ciuser      = "root"
      cipassword  = "zaq12wsx"
      cores       = 1
      bridge      = "vmbr0"
      network_tag = 0
    },
    # "worker-node2" = {
    #   vm_id       = 304
    #   name        = "worker-2"
    #   memory      = 1024
    #   vm_state    = "stopped"
    #   onboot      = true
    #   startup     = "order=1"
    #   ipconfig    = "ip=192.168.0.7/24,gw=192.168.0.1"
    #   ciuser      = "root"
    #   cipassword  = "zaq12wsx"
    #   cores       = 1
    #   bridge      = "vmbr0"
    #   network_tag = 0
    # },
    # "lb-node1" = {
    #   vm_id       = 305
    #   name        = "lb-1"
    #   memory      = 512
    #   vm_state    = "stopped"
    #   onboot      = true
    #   startup     = "order=1"
    #   ipconfig    = "ip=192.168.0.8/24,gw=192.168.0.1"
    #   ciuser      = "root"
    #   cipassword  = "zaq12wsx"
    #   cores       = 1
    #   bridge      = "vmbr0"
    #   network_tag = 0
    # },
    # "lb-node2" = {
    #   vm_id       = 306
    #   name        = "lb-2"
    #   memory      = 512
    #   vm_state    = "stopped"
    #   onboot      = true
    #   startup     = "order=1"
    #   ipconfig    = "ip=192.168.0.9/24,gw=192.168.0.1"
    #   ciuser      = "root"
    #   cipassword  = "zaq12wsx"
    #   cores       = 1
    #   bridge      = "vmbr0"
    #   network_tag = 0
    # },
    "nfs-server" = {
      vm_id = 310
      name = "nfs-server"
      memory      = 1024
      vm_state    = "stopped"
      onboot      = true
      startup     = "order=1"
      ipconfig    = "ip=192.168.0.20/24,gw=192.168.0.1"
      ciuser      = "root"
      cipassword  = "zaq12wsx"
      cores       = 1
      bridge      = "vmbr0"
      network_tag = 0
    }

  }
}