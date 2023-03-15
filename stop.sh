#!/bin/bash

# Get list of running Vagrant machines
machines=$(vagrant global-status | awk '$4 == "running" && $3 == "virtualbox" {print $5, $2}')

# Print out list of running machines
echo "Running Vagrant machines:"
echo "$machines" | awk '{print "("NR") => ("$2")"}'

# Prompt user to select a machine to halt
echo "Enter the index of the machine you want to halt: "
read index
# Get the ID of the selected machine
machine_id=$(echo "$machines" | sed -n "${index}p" | awk '{print $2}')

# Halt the selected machine
cd /goinfre/haitkadi/Vagrant
vagrant halt "$machine_id"
