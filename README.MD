# Deploy a Kusama Validator into Azure using Terraform and Bash Script(s).

https://rudycorradetti.com/2022/10/22/deploying-a-kusama-validator-into-azure-featuring-terraform-and-bash/
    
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