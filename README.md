# vmware-permission-check
Script to check if user got adequate permission in vmware for OpenShift/Kubernetes

Pre-requirements
----------------
This script requires the user to have [govc](https://github.com/vmware/govmomi/tree/master/govc) VMwares CLI.  
It also requires the user to be logged in to the vCenter which is easily done by exporting these variables:

1. export GOVC_URL=url
2. export GOVC_USER=user
3. export GOVC_PASSWORD=password
4. export GOVC_INSECURE=true

Permission check
=========
Simple script to check if user got the necessary permissions for installing OpenShift on VMware with dynamic storage provisioning.

How it works
----------------
When run, the script will compare the users permission to those that are required for dynamic storage provisioning. It will output the permissions with either a check mark notifiying the user that it has the permission or a cross telling the permission is missing.

A list of the necessary permissions can be found [here](https://github.com/vmware-archive/vsphere-storage-for-kubernetes/blob/master/documentation/vcp-roles.md)

> NOTE that while the script checks if the permissions for the user are there, it does not check whether they are propogated or not.
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
