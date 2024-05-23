terraform {
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "3.0.1-rc2"
        }
    }
}

# Proxmox Cloud-Init Clone
# ---
# Create a new VM from a clone
variable "vm_name" {}
variable "vm_ip" {}
variable "vm_id" {}

resource "proxmox_vm_qemu" "vm" {
    # Node name has to be the same name as within the cluster
    target_node = "pve"
    # The template name to clone this VM from
    clone = "ubuntu-cloud"

    # VM SETTINGS BELOW
    # VM Name, Description, and VMID
    name = var.vm_name
    desc = "Terraform created VM for Kubernetes"
    # VM ID - optional
    vmid = var.vm_id
    # Boot with Proxmox
    onboot = true
    # Activate QEMU agent for this VM
    agent = 1
    # VM Cloud-Init Settings
    os_type = "cloud-init"
    # VM CPU Settings
    cores = 4
    sockets = 2
    cpu = "host"
    # VM Memory Settings
    memory = 16384
    # VM SCSI HW Controller
    scsihw = "virtio-scsi-pci"
    # VM Advanced General Settings

    # Setup the disks
    disks {
        ide {
            # ide number must match vm being cloned
            ide2 {
                cloudinit {
                    # storage must match vm being cloned
                    storage = "local-zfs"
                }
            }
        }
        scsi {
            # scsi drive number must match vm being cloned
                scsi0 {
                    disk {
                        # the storage local will move scsi0 to this location
                        storage = "nvmeZFS"
                        size = "200G"
                    }
                }
        }
    }

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # boot disk must match the disk defined above
    boot = "order=ide2;scsi0"

    # (Optional) IP Address and Gateway
    ipconfig0 = "ip=${var.vm_ip}/24,gw=0.0.0.0"
    # ipconfig0 = "ip=dhcp"
    nameserver = "0.0.0.0"

}