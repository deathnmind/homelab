# Proxmox Cloud-Init Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "your-vm" {
    # Node name has to be the same name as within the cluster
    target_node = "pve"
    # The template name to clone this VM from
    clone = "ubuntu-cloud"
    #the count variable will create multiple VMs - however this is too fast for the cloud-init to finish
    count = 5


    # VM SETTINGS BELOW
    # VM Name, Description, and VMID
    name = "test${count.index + 1}"
    desc = "Terraform created VM"
    # VM ID - optional
    vmid = "40${count.index + 1}"
    # Boot with Proxmox
    onboot = true
    # Activate QEMU agent for this VM
    agent = 1
    # VM Cloud-Init Settings
    os_type = "cloud-init"
    # VM CPU Settings
    cores = 4
    sockets = 1
    cpu = "host"
    # VM Memory Settings
    memory = 8192
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
                    storage = "local-lvm"
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
    ipconfig0 = "ip=0.0.0.0${count.index + 1}/24,gw=0.0.0.0"
    # ipconfig0 = "ip=dhcp"
    nameserver = "0.0.0.0"
    
    # (Optional) Default User
    # ciuser = "your-username"
    
    # (Optional) Add your SSH KEY
    # sshkeys = <<EOF
    # #YOUR-PUBLIC-SSH-KEY
    # EOF

}