# ========================================================
# Description: Starts or stops an Azure VM based on its current status
# Author: Shubhali Bakshi
# ========================================================

# Load configuration variables (Resource Group, VM name, etc.)
source config/vm-config.env

# 1. Read user input (start/stop)
TASK=$1  # The first argument passed to the script (e.g., "start" or "stop")

# Validate input
if [[ "$TASK" != "start" && "$TASK" != "stop" ]]; then
  echo "Usage: $0 start|stop"
  exit 1
fi

# 2. Check the current power state of the VM - To handle single VM
# Query Azure for the VM's current power state
STATUS=$(az vm get-instance-view -g $RG -n $VM \
         --query "instanceView.statuses[?starts_with(code, 'PowerState/')].code" \
         -o tsv)

echo "Current VM status: $STATUS"

# 3. Start or stop the VM based on status
if [[ "$TASK" == "start" ]]; then
  if [[ "$STATUS" == "PowerState/running" ]]; then
    echo "VM is already running. No action taken."
  else
    echo "Starting VM..."
    az vm start -g $RG -n $VM
  fi
elif [[ "$TASK" == "stop" ]]; then
  if [[ "$STATUS" == "PowerState/deallocated" || "$STATUS" == "PowerState/stopped" ]]; then
    echo "VM is already stopped. No action taken."
  else
    echo "Stopping VM..."
    az vm deallocate -g $RG -n $VM
  fi
fi

# 4. Log the action taken
echo "$(date '+%Y-%m-%d %H:%M:%S') - $TASK on VM $VM in RG $RG (Previous Status: $STATUS)" >> $LOG_FILE


# 5. Confirm the final VM status
UPDATED_STATUS=$(az vm get-instance-view -g $RG -n $VM \
                 --query "instanceView.statuses[?starts_with(code, 'PowerState/')].displayStatus" \
                 -o tsv)
UPDATED_STATUS=$(az vm get-instance-view -g $RG -n $VM --query "instanceView.statuses[?starts_with(code, 'PowerState/')].displayStatus" -o tsv)
echo "Final status of VM '$VM': $UPDATED_STATUS"


# === [OPTIONAL] Uncomment below to handle multiple VMs ===
# VM_LIST=("vm1" "vm2" "vm3")
#
# for VM in "${VM_LIST[@]}"; do
#   echo "Processing VM: $VM"
#   if ! az vm show -g $RG -n $VM &> /dev/null; then
#     echo "VM $VM not found. Skipping."
#     continue
#   fi
#   STATUS=$(az vm get-instance-view -g $RG -n $VM --query "instanceView.statuses[?starts_with(code,'PowerState/')].code" -o tsv)
#   echo "Status: $STATUS"
#   if [[ "$TASK" == "start" && "$STATUS" != "PowerState/running" ]]; then
#     echo "Starting VM $VM..."
#     az vm start -g $RG -n $VM
#   elif [[ "$TASK" == "stop" && "$STATUS" != "PowerState/deallocated" && "$STATUS" != "PowerState/stopped" ]]; then
#     echo "Stopping VM $VM..."
#     az vm deallocate -g $RG -n $VM
#   else
#     echo "No action needed."
#   fi
#   echo "$(date '+%Y-%m-%d %H:%M:%S') - $TASK on VM $VM in RG $RG (Prev Status: $STATUS)" >> $LOG_FILE
# done
