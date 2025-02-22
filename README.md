# gandi-dynamic-dns

This shell command is optimised for home assistant 2025.2. It is tested with Gandi v5 DNS. 

Create a Gandi API Token

Log in to your domain dashboard, click on your username and then 'User Settings'. 

Scroll down to 'Personal Access Token (PAT)' and select 'Create a Token'. You can call it anything you like. I would suggest you set the expiry to 1 year. Copy the generated token to your secrets.yaml file, example below

gandi_api_token: YOUR_TOKEN

Copy the file gandi-dns-update.sh to your home assistant /config directory. I suggest creating a subdirectory /config/scripts to keep things tidy


