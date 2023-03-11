#!/bin/bash


# Define colors
RED='\033[0;31m'     # Red
GREEN='\033[0;32m'   # Green
YELLOW='\033[0;33m'  # Yellow
BLUE='\033[0;34m'    # Blue
PURPLE='\033[0;35m'  # Purple
CYAN='\033[0;36m'    # Cyan
WHITE='\033[0;37m'   # White
NC='\033[0m'         # No Color


# ++++++++++++++++++++++ Setuping machines +++++++++++++++++++++++++++

spinner() {
  local delay=0.1
  local spinstr='|/-\'
  tput civis # hide cursor
  while true; do
    local temp=${spinstr#?}
    printf "\e[1;36m[%c]\e[0m " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  tput cnorm # show cursor
}


# ------------------  check if Vagrant not installed -------------------
if ! which vagrant &>/dev/null; then
  echo -e "${RED}Error: ${YELLOW}Vagrant${NC} is not installed.\nopen \"Managed Software Center\" install it and run again." >&2
  exit 1
fi

# Check if VirtualBox is installed
if ! vboxmanage --version &>/dev/null; then
  echo -e "${RED}Error: ${YELLOW}Virualbox${NC} is not installed.\nopen \"Managed Software Center\" install it and run again." >&2
  exit 1
fi


#check if vagrant-vbguest plugin not installed intall it

if ! vagrant plugin list | grep -q 'vagrant-vbguest'; then
    spinner & # launch spinner
    SPINNER_PID=$!
    trap "kill $SPINNER_PID; exit" INT # trap Ctrl+C and stop the spinner
    vagrant plugin install vagrant-vbguest &>/dev/null
    kill $SPINNER_PID # stop the spinner
fi



run_boxes() {
    cd /Users/$USER/goinfre/Vagrant
    echo "Boxes already exists"
    echo "\
Enter number (1) to run ubuntu\n\
Enter number (2) to run kali\n\
Enter number (3) to run debian\n\
Enter number (4) to run alpine\n\
Enter number (0) to Exit"

    read which_to_run
    case $which_to_run in
        1)
            echo "Running ubuntu"
            spinner & # launch spinner
            SPINNER_PID=$!
            trap "kill $SPINNER_PID; exit" INT # trap Ctrl+C and stop the spinner
            vagrant up ubuntu &>/dev/null
            kill $SPINNER_PID # stop the spinner
            vagrant ssh ubuntu
            ;;
        2)
            echo "Running kali"
            spinner & # launch spinner
            SPINNER_PID=$!
            trap "kill $SPINNER_PID; exit" INT # trap Ctrl+C and stop the spinner
            vagrant up kali &>/dev/null
            kill $SPINNER_PID # stop the spinner
            vagrant ssh kali
            ;;
        3)
            echo "Running debian"
            spinner & # launch spinner
            SPINNER_PID=$!
            trap "kill $SPINNER_PID; exit" INT # trap Ctrl+C and stop the spinner
            vagrant up debian &>/dev/null
            kill $SPINNER_PID # stop the spinner
            vagrant ssh debian
            ;;
        4)
            echo "Running alpine"
            spinner & # launch spinner
            SPINNER_PID=$!
            trap "kill $SPINNER_PID; exit" INT # trap Ctrl+C and stop the spinner
            vagrant up alpine &>/dev/null
            kill $SPINNER_PID # stop the spinner
            vagrant ssh alpine
            ;;
        0)
            exit 0
            ;;
        *)
            echo "Invalid input"
            exit 0
            ;;
    esac
} # run_box

#===============================================================================

setup_boxes() {
vagrant_content='
Vagrant.configure("2") do |config|

    config.vm.define "ubuntu" do |ubuntu|
        ubuntu.vm.box = "ubuntu/trusty64"
    end

    config.vm.define "debian" do |debian|
        debian.vm.box = "debian/jessie64"
    end

    config.vm.define "kali" do |kali|
        kali.vm.box = "kalilinux/rolling"
    end

    config.vm.define "alpine" do |alpine|
        alpine.vm.box = "generic/alpine38"
    end

end
'
# ==================================================================
file_name="/goinfre/$USER/Vagrant/Vagrantfile"

if [ -e "$file_name" ]; then
    run_boxes
else
    echo "Setuping boxes ...."
    echo "$vagrant_content" > "$file_name"
    run_boxes
fi

} # setup_box

#=======================================================================

if [ -v VAGRANT_HOME ]; then
    setup_boxes
else
    echo '
# ========================== Setuping Vagrant==================================
if [ ! -d "/goinfre/$USER/Vagrant" ]
then
    echo "Creating Vagrant folder ....."
    mkdir /goinfre/$USER/Vagrant
fi

export VAGRANT_HOME=/goinfre/$USER/Vagrant/

# Setuping Vagrant
if [ ! -d "/goinfre/$USER/.vagrant.d" ]
then
    echo "Creating .vagrant.d folder ....."
    mkdir /goinfre/$USER/.vagrant.d
fi

export VAGRANT_DOTFILE_PATH=/goinfre/$USER/.vagrant.d/

# Setuping VM folder
if [ ! -d "/goinfre/$USER/VMs" ]
then
    mkdir /goinfre/$USER/VMs
fi
if VBoxManage --version &>/dev/null; then
    VBoxManage setproperty machinefolder /goinfre/$USER/VMs
fi
' >> ~/.zshrc

source ~/.zshrc
setup_boxes

fi




