#!/bin/bash

# Get list of all Vagrant machines
machines=$(vagrant global-status | awk '$3 == "virtualbox" {print $5, $2}')

# Print out list of machines
echo "Existing Vagrant machines:"
echo "$machines" | awk '{print "("NR") => ("$2")"}'

# Prompt user to select a machine to destroy
echo "Enter the index of the machine you want to halt: "
read index

# Get the ID of the selected machine
machine_id=$(echo "$machines" | sed -n "${index}p" | awk '{print $2}')

# Destroy the selected machine
cd /goinfre/haitkadi/Vagrant
vagrant destroy "$machine_id"
