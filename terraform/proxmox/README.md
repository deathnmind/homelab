# Proxmox terraform examples

- Using the `count` to create multiple VMs works - except its too fast and there is often a resource lock conflict.  Its better to define the VMs one by one in a one file.
- Rename either `count_main.tf` or `multiple_man.tf` to `main.tf` to use it.
- Enter the variables for the proxmox server into `credentials.auto.tfvars`
- The permission for the role on proxmox need to be:

```shell
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
```

- Then create an account and assign it to the role

```shell
pveum user add terraform-prov@pve --password password
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

- Once the role and user are created goto proxmox GUI and create the access token for the account.

## Single Folder
- Count can either be left or removed and it will create a VM based on itteration number.
- If the count is a high number there are often resource lock conflicts.

## Multiple Folders
- This divideds the VMs into modules and creates them one by one.  This is the best way to create multiple VMs.
- `main.tf` is edited to set the VM names and ip addresses.
- Apply an individual module with the command: `terraform apply -target=module.test1 -auto-approve`

```bash
#!/bin/bash
terraform apply -target=module.test1 -auto-approve
terraform apply -target=module.test2 -auto-approve
terraform apply -target=module.test3 -auto-approve
terraform apply -target=module.test4 -auto-approve
terraform apply -target=module.test5 -auto-approve
```