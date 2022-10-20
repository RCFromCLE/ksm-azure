## Deploy a Kusama Validator into Azure using Terraform and Ansible.

### Steps to setup Application Layer
#   1) Add Ansible user
    
    #Creat e user for ansible
    sudo adduser ansible_user
    #Allow sudo on this user
    sudo usermod -aG sudo ansible_user
    
#   2) Generate SSH Keys
 
    #Swith to the ansible_user, put in password created in step 1),
    #alternativel you may logout and log back in as ansible_user
    
    su ansible_user
    cd /home/ansible_user
    
    #Generate keypairs, use defaults and optionally enter a passphrase
    ssh-keygen -t rsa
    
    #Copy the keys to your system
    ssh-copy-id ansible_user@<serverip>
    
    #Optional, make edits to change the port 
    sudo nano /etc/ssh/sshd_config
    sudo systemctl restart ssh.service
    
#   3) Ansible Install
 
    #Install the ansible package
    sudo apt install ansible
    
    #Get the latest release of the secure validator package
    git clone https://github.com/w3f/polkadot-secure-validator.git
    
    #Go to the Ansible folder
    cd polkadot-secure-validator/ansible
    
    #Create a copy of the template Inventory file for edit
    mv inventory.sample inventory.yml
    
    #Edit the template
    sudo nano inventory.yml
    
    #<FOLLOW THE STEPS IN THE VIDEO>
    
#   4) Run setup
    ./setup.sh