variable proxmox_api_url {
  type = string
}

variable proxmox_api_token_id {
  type = string
}

variable proxmox_api_token {
  type = string
}

  variable "vm_configs" {
    type = map(object({
      vm_id       = number
      target_node = string
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
        vm_id       = 1000
        target_node = "pve1"
        name        = "master-1"
        memory      = 4096
        vm_state    = "stopped"
        onboot      = true
        startup     = "order=1"
        ipconfig    = "ip=192.168.4.150/24,gw=192.168.4.1"
        ciuser      = "root"
        cipassword  = "zaq12wsx"
        cores       = 2
        bridge      = "vmbr0"
        network_tag = 0
      },
      "master-node2" = {
        vm_id       = 1001
        target_node = "pve1"
        name        = "master-2"
        memory      = 4096
        vm_state    = "stopped"
        onboot      = true
        startup     = "order=1"
        ipconfig    = "ip=192.168.4.151/24,gw=192.168.4.1"
        ciuser      = "root"
        cipassword  = "zaq12wsx"
        cores       = 2
        bridge      = "vmbr0"
        network_tag = 0
      },
      "master-node3" = {
        target_node = "pve2"
        vm_id       = 1002
        name        = "master-3"
        memory      = 4096
        vm_state    = "stopped"
        onboot      = true
        startup     = "order=1"
        ipconfig    = "ip=192.168.4.152/24,gw=192.168.4.1"
        ciuser      = "root"
        cipassword  = "zaq12wsx"
        cores       = 2
        bridge      = "vmbr0"
        network_tag = 0
      },
      "master-node4" = {
        target_node = "pve2"
        vm_id       = 1003
        name        = "master-4"
        memory      = 4096
        vm_state    = "stopped"
        onboot      = true
        startup     = "order=1"
        ipconfig    = "ip=192.168.4.153/24,gw=192.168.4.1"
        ciuser      = "root"
        cipassword  = "zaq12wsx"
        cores       = 2
        bridge      = "vmbr0"
        network_tag = 0
      },
      "worker-node1" = {
        vm_id       = 1004
        target_node = "pve1"
        name        = "worker-1"
        memory      = 4096
        vm_state    = "stopped"
        onboot      = true
        startup     = "order=1"
        ipconfig    = "ip=192.168.4.154/24,gw=192.168.4.1"
        ciuser      = "root"
        cipassword  = "zaq12wsx"
        cores       = 4
        bridge      = "vmbr0"
        network_tag = 0
      },
      "worker-node2" = {
        vm_id       = 1005
        target_node = "pve3"
        name        = "worker-2"
        memory      = 4096
        vm_state    = "stopped"
        onboot      = true
        startup     = "order=1"
        ipconfig    = "ip=192.168.4.155/24,gw=192.168.4.1"
        ciuser      = "root"
        cipassword  = "zaq12wsx"
        cores       = 4
        bridge      = "vmbr0"
        network_tag = 0
      },
      "worker-node3" = {
        vm_id       = 1006
        target_node = "pve3"
        name        = "worker-3"
        memory      = 4096
        vm_state    = "stopped"
        onboot      = true
        startup     = "order=1"
        ipconfig    = "ip=192.168.4.156/24,gw=192.168.4.1"
        ciuser      = "root"
        cipassword  = "zaq12wsx"
        cores       = 4
        bridge      = "vmbr0"
        network_tag = 0
      },
      "lb-node1" = {
        vm_id       = 1007
        target_node = "pve1"
        name        = "lb-1"
        memory      = 512
        vm_state    = "stopped"
        onboot      = true
        startup     = "order=1"
        ipconfig    = "ip=192.168.4.157/24,gw=192.168.4.1"
        ciuser      = "root"
        cipassword  = "zaq12wsx"
        cores       = 1
        bridge      = "vmbr0"
        network_tag = 0
      },
      "lb-node2" = {
        vm_id       = 1008
        target_node = "pve2"
        name        = "lb-2"
        memory      = 512
        vm_state    = "stopped"
        onboot      = true
        startup     = "order=1"
        ipconfig    = "ip=192.168.4.158/24,gw=192.168.4.1"
        ciuser      = "root"
        cipassword  = "zaq12wsx"
        cores       = 1
        bridge      = "vmbr0"
        network_tag = 0
      },
      # "nfs-server" = {
      #   vm_id = 1007
      #   target_node = "pve2"
      #   name = "nfs-server"
      #   memory      = 512
      #   vm_state    = "stopped"
      #   onboot      = true
      #   startup     = "order=1"
      #   ipconfig    = "ip=192.168.4.157/24,gw=192.168.4.1"
      #   ciuser      = "root"
      #   cipassword  = "zaq12wsx"
      #   cores       = 1
      #   bridge      = "vmbr0"
      #   network_tag = 0
      # }
    }
  }