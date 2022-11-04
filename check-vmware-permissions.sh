#!/bin/bash
# Oscar Lindholm olindhol@redhat.com
# Script for verifying adequate role permission for VMware service account used for OpenShift UPI and IPI installations 

# Pre-requirements
# GOVC - CLI for VMware.
# Credentials for the Service Account

# Required permissions for UPI
upiPermissions=("Resource.AssignVMToPool" "VirtualMachine.Config.AddExistingDisk" "VirtualMachine.Config.AddNewDisk" "VirtualMachine.Config.AddRemoveDevice" "VirtualMachine.Config.RemoveDisk" "VirtualMachine.Inventory.Create" "VirtualMachine.Inventory.Delete" "VirtualMachine.Config.Settings" "Datastore.AllocateSpace" "Datastore.FileManagement" "StorageProfile.View" "System.Anonymous" "System.Read" "System.View")
# Required permissions for IPI
ipiPermissions=("Cns.Searchable" "Datastore.AllocateSpace" "Datastore.Browse" "Datastore.FileManagement" "Folder.Create" "Folder.Delete" "Host.Config.Storage" "InventoryService.Tagging.AttachTag" "InventoryService.Tagging.CreateCategory" "InventoryService.Tagging.CreateTag" "InventoryService.Tagging.DeleteCategory" "InventoryService.Tagging.DeleteTag" "InventoryService.Tagging.EditCategory" "InventoryService.Tagging.EditTag" "InventoryService.Tagging.ObjectAttachable" "Network.Assign" "Resource.AssignVMToPool" "Sessions.ValidateSession" "StorageProfile.Update" "StorageProfile.View" "System.Anonymous" "System.Read" "System.View" "VApp.AssignResourcePool" "VApp.Import" "VirtualMachine.Config.AddExistingDisk" "VirtualMachine.Config.AddNewDisk" "VirtualMachine.Config.AddRemoveDevice" "VirtualMachine.Config.AdvancedConfig" "VirtualMachine.Config.Annotation" "VirtualMachine.Config.CPUCount" "VirtualMachine.Config.DiskExtend" "VirtualMachine.Config.DiskLease" "VirtualMachine.Config.EditDevice" "VirtualMachine.Config.Memory" "VirtualMachine.Config.RemoveDisk" "VirtualMachine.Config.Rename" "VirtualMachine.Config.ResetGuestInfo" "VirtualMachine.Config.Resource" "VirtualMachine.Config.Settings" "VirtualMachine.Config.UpgradeVirtualHardware" "VirtualMachine.Interact.GuestControl" "VirtualMachine.Interact.PowerOff" "VirtualMachine.Interact.PowerOn" "VirtualMachine.Interact.Reset" "VirtualMachine.Inventory.Create" "VirtualMachine.Inventory.CreateFromExisting" "VirtualMachine.Inventory.Delete" "VirtualMachine.Provisioning.Clone" "VirtualMachine.Provisioning.DeployTemplate" "VirtualMachine.Provisioning.MarkAsTemplate")

# Main function
function main() {
if  [ -z $1 ]; then
  helpmsg
elif [ $1 = "-u" ]; then
  reqPermissions=${upiPermissions[@]}
elif [ $1 = "-i" ]; then
  reqPermissions=${ipiPermissions[@]}
else helpmsg
fi
case $1 in 

        -u) permissionCheck
        ;;
        -i) permissionCheck
        ;;
        -h) helpmsg
        ;;
        *) helpmsg
        ;;
esac
}

function helpmsg() {
echo "Usage: $0 [options]"
echo
echo "Options:"
echo "    -u          Checks if user got adequate permissions for a UPI installation."
echo "    -i          Checks if user got adequate permissions for a IPI installation."
echo "    -h          Prints this messages and exits."

exit
}
function permissionCheck() {
govc about > /dev/null 2>&1

if [ $? != 0 ]; then
  echo "GOVC was not found or you are not logged in. Please check your path or log in."
  exit 1
fi

results=( $(govc permissions.ls -json=true | jq  -r .Roles[].Privilege | tr -d [,' '\"] | sort -u ) )

for item in ${reqPermissions[@]}; do
  if ( IFS=$'\n'; echo "${results[*]}" ) | grep -qFx "$item"; then
      echo -e "$item \xE2\x9C\x94"
  else
      echo -e "$item \xE2\x9D\x8C"
  fi
done
}


main $1