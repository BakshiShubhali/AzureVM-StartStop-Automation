# Azure VM Start/Stop Automation Project

This project demonstrates how to automate **starting and stopping Azure Virtual Machines** using **Bash shell scripts** and the **Azure CLI (AZ CLI)**. It helps optimize cloud cost by ensuring that VMs are only running when needed.

---

## 🚀 Project Purpose

Cloud resources like Virtual Machines (VMs) incur costs while running. To optimize usage, this project automates VM lifecycle operations like:

* ✅ **Starting a VM only when needed**
* ❌ **Stopping/deallocating the VM when not in use**
* 📝 **Checking VM power state before performing any operation**
* 📩 **Logging every action for audit or analysis**

This is especially useful for development/testing environments where VMs don’t need to run 24/7.

---

## 📁 Folder Structure

```
Project-VM-StartStop-Automation/
├── scripts/                      # All shell scripts
│   ├── create-vm.sh             # Creates RG, VNet, Subnet, and VM
│   └── start-stop-vm.sh         # Starts or stops a VM based on current status
│
├── config/                      # Environment configuration
│   └── vm-config.env            # Contains VM, RG, location and log path
│
├── logs/                        # Logging for actions performed
│   └── vm-actions-sample.log    # Logs of each start/stop event
│
├── screenshots/                 # Optional: Azure Portal screenshots
│   └── vm-status-portal.png     # Example: screenshot showing VM status
│
├── README.md                    # Project documentation (this file)
```

---

## 💡 How It Works

### 1. **Configuration**

The file `config/vm-config.env` contains all the key variables used across scripts:

```bash
RG="project1"
VNET="my-vnet"
SUBNET="my-subnet"
VM="start-stop-vm"
LOCATION="canadacentral"
LOG_FILE="logs/vm-actions-sample.log"
```

Edit this file to customize your environment.

---

### 2. **Creating the Environment** (`create-vm.sh`)

This script:

* Creates resource group, virtual network, subnet, and VM if they don't exist
* Uses Ubuntu 22.04 as base image

Command:

```bash
bash scripts/create-vm.sh
```

---

### 3. **Starting or Stopping the VM** (`start-stop-vm.sh`)

This script:

* Takes `start` or `stop` as input
* Checks VM power status
* Starts/stops the VM if needed
* Logs the action with timestamp

Command:

```bash
bash scripts/start-stop-vm.sh start
bash scripts/start-stop-vm.sh stop
```

Sample log entry:

```
2025-06-28 10:20:11 - start on VM start-stop-vm in RG project1 (Previous Status: PowerState/deallocated)
```

---

## 🔁 Workflow Summary

1. Configure: `config/vm-config.env`
2. Setup: Run `create-vm.sh`
3. Operate: Run `start-stop-vm.sh start` or `stop`
4. Review: Check `logs/vm-actions-sample.log`

---

## 🧰 Prerequisites

* Azure CLI (`az login`)
* Azure Subscription
* Bash Shell (Linux, macOS, WSL, Git Bash on Windows)

---

## 👤 Ideal For

* Azure Dev/Test Automation
* Cost-conscious developers
* Learners building Azure CLI skills
