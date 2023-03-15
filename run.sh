#!/bin/bash

# Get list of powered-off Vagrant machines
machines=$(vagrant global-status | awk '$4 == "poweroff" && $3 == "virtualbox" {print $5, $2}')

# Print out list of powered-off machines
echo "Powered-off Vagrant machines:"
echo "$machines" | awk '{print "("NR") => ("$2")"}'

# Prompt user to select a machine to start
echo "Enter the index of the machine you want to halt: "
read index

# Get the ID of the selected machine
machine_id=$(echo "$machines" | sed -n "${index}p" | awk '{print $2}')

echo "$machine_id"

# Start the selected machine
cd /goinfre/haitkadi/Vagrant
vagrant up "$machine_id"
