# vmware-permission-check
Script to check if user got adequate permission in vmware for OpenShift

Permission check
=========
Simple script to check if user got the necessary permissions for installing OpenShift on VMware with dynamic storage provisioning.

How it works
----------------
When run, the script will compare the users permission to those that are required for dynamic storage provisioning. It will output the permissions with either a check mark notifiying the user that it has the permission or a cross telling the permission is missing.

# Example usage

```bash
➜ ./check-vmware-permissions.sh 
Usage: ./check-vmware-permissions.sh [options]

Options:
    -s          Checks if user got adequate permissions.
    -h          Prints this messages and exits.


➜ ./check-vmware-permissions.sh -s
Resource.AssignVMToPool ✔
VirtualMachine.Config.AddExistingDisk ✔
VirtualMachine.Config.AddNewDisk ✔
VirtualMachine.Config.AddRemoveDevice ✔
VirtualMachine.Config.RemoveDisk ✔
VirtualMachine.Inventory.Create ❌
VirtualMachine.Inventory.Delete ❌
VirtualMachine.Config.Settings ❌
Datastore.AllocateSpace ✔
Datastore.FileManagement ✔
StorageProfile.View ✔
System.Anonymous ✔
System.Read ✔
System.View ✔
```
