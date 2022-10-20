## Deploy a Kusama Validator into Azure using Terraform and Bash Script(s).

1. Deploy platform layer into Azure using main.tf in terraform directory.

2. Deploy application layer using Stakeworld's deployment script - https://github.com/stakeworld/stakeworld-scripts.
- 1. ``sudo apt update``
- 2. ``curl -o- -L https://raw.githubusercontent.com/stakeworld/stakeworld-scripts/master/node-install.sh | bash`` 
    
#### Troubleshooting:
- sudo systemctl status misfitsstaking-01.service
-