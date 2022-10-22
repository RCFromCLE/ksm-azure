# Deploy a Kusama Validator into Azure using Terraform and Bash Script(s).

1. Deploy platform layer into Azure using main.tf in terraform directory.

2. Deploy application layer using Stakeworld's deployment script 

- ``curl -o- -L https://raw.githubusercontent.com/stakeworld/stakeworld-scripts/master/node-install.sh | bash`` 
    
### Monitoring Your KSM Validator Using Grafana

Requirements to monitor
#### Helpful commands:
- View information from Polkadot service 
``sudo systemctl status MisfitsStaking-01.service``
- View additional info from Polkadot service
``journalctl -xefu MisfitsStaking-01.service``
- Edit Polkadot service file
``vim /etc/systemd/system/MisfitsStaking-01.service``
- Restart Polkadot Service
``sudo systemctl daemon-reload``
- Show Session Keys
``curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9901``