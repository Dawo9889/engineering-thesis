resource "proxmox_vm_qemu" "cloud-init" {
  for_each = var.vm_configs

  vmid = each.value.vm_id
  name = each.value.name
  target_node = each.value.target_node

  clone = "ubuntu-server-noble"
  full_clone = false
  scsihw = "virtio-scsi-single"

  os_type = "cloud-init"
  memory = each.value.memory

  onboot = each.value.onboot
  startup = each.value.startup
  ipconfig0 = each.value.ipconfig
  # ciuser = each.value.ciuser
  # cipassword = each.value.cipassword
  # sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILhKpbWy7VPP7p7CL0/DdNtrWHnTTogaAfXmNegECbJZ For automation"
  nameserver = "1.1.1.1"

  serial {
    id = 0
    type = "socket"
  }

  cpu {
    cores = each.value.cores
    type = "x86-64-v2-AES"
  }

  network {
    id = 0
    model = "virtio"
    bridge = each.value.bridge
    firewall = true
    tag = each.value.network_tag
  }

  disks {
    virtio {
      virtio0 {
        disk {
          storage   = "Share-NFS"
          size      = "32G"
          iothread  = true
          replicate = false
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = "Share-NFS"
        }
      }
    }
  }
}