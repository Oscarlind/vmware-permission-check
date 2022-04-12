#!/bin/bash
# Oscar Lindholm olindhol@redhat.com

# Script for verifying adequate role permission for VMware service account used for OpenShift UPI installations using dynamic storage

# Pre-requirements
# GOVC - CLI for VMware.
# Credentials for the Service Account

# Required permissions for dynamic storage
reqPermissions=("Resource.AssignVMToPool" "VirtualMachine.Config.AddExistingDisk" "VirtualMachine.Config.AddNewDisk" "VirtualMachine.Config.AddRemoveDevice" "VirtualMachine.Config.RemoveDisk" "VirtualMachine.Inventory.Create" "VirtualMachine.Inventory.Delete" "VirtualMachine.Config.Settings" "Datastore.AllocateSpace" "Datastore.FileManagement" "StorageProfile.View" "System.Anonymous" "System.Read" "System.View")

# Main function
function main() {
case $1 in 

        -s) permissionCheck
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
echo "    -s          Checks if user got adequate permissions."
echo "    -h          Prints this messages and exits."

exit
}

function permissionCheck() {
govc about > /dev/null 2>&1

if [ $? != 0 ]; then
  echo "GOVC was not found or you are not logged in. Please check your path or log in."
  exit 1
fi

results=$(
  for role in $(govc permissions.ls | awk '(NR>1)' | awk '{ print $1 '} | sort | uniq -u); do 
    govc role.ls $role 2>/dev/null; 
  done
)

for item in ${reqPermissions[@]}; do
  if ( IFS=$'\n'; echo "${results[*]}" ) | grep -qFx "$item"; then
      echo -e "$item \xE2\x9C\x94"
  else
      echo -e "$item \xE2\x9D\x8C"
  fi
done
}

main $1
