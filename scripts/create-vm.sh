# create-vm.sh

source config/vm-config.env

echo "Checking resource group $RG..."
if ! az group show -n $RG &> /dev/null; then
  echo "Creating resource group: $RG"
  az group create --name $RG --location $LOCATION
else
  echo "Resource group $RG already exists."
fi

echo "Checking virtual network $VNET..."
if ! az network vnet show -g $RG -n $VNET &> /dev/null; then
  echo "Creating Virtual Network $VNET with Subnet $SUBNET"
  az network vnet create -g $RG -n $VNET \
    --address-prefix 10.0.0.0/16 \
    --subnet-name $SUBNET \
    --subnet-prefix 10.0.0.0/24 \
    --location $LOCATION
else
  echo "Virtual network $VNET already exists."
fi

echo "Checking VM $VM..."
if ! az vm show -g $RG -n $VM &> /dev/null; then
  echo "Creating Virtual Machine: $VM"
  az vm create -g $RG -n $VM \
    --image Ubuntu2204 \
    --vnet-name $VNET \
    --subnet $SUBNET \
    --admin-username azureuser \
    --authentication-type ssh \
    --public-ip-sku Standard \
    --size Standard_B1s \
    --nsg-rule SSH
else
  echo "VM $VM already exists."
fi
