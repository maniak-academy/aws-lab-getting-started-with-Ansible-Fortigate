# AWS lab Getting with Ansible + Fortigate
DevSecOps with Fortinet

## Agenda 
1. Deploy lab Environment
2. DevSecOps with Fortinet
3. Create your first ansible playbook
4. Build and Secure and Application

### Prerequsists
* Install Terraform to deploy lab
* Install Ansible 
* https://docs.ansible.com/ansible/latest/collections/fortinet/fortios/index.html 


## Install Terraform

Uing brew to install terraform 

```
brew install terraform
```

### Initiate Terraform 
Initiate terraform and apply terraform

```
terraform init
terraform apply -auto-approve
```

## Install ansible 
We will be using ansible to orchestrate 

```
brew install ansible
```

## Setup Ansible Playbook

* Install FortiOS Galaxy Collection
The FortiOS Ansible Galaxy supports multilple FortiOS major releases, you can install the latest collection by default via command 

```
ansible-galaxy collection install fortinet.fortios
```

## Setup Fortigate Access token
1. Log into the fortigate devices
2. System > Admin Profiles > Create New > Profile
3. System > Administrators > Create New rest API

## Creat a Vault Secret token with ur API key
Let's make sure we encrypt the token, so lets use Ansible Vault

1. Create the Ansible Vault Secret Token
2. First, you need to encrypt your Fortigate token (47dwqz9pw6GHy6fbmb6wwh6t8Hc686) using Ansible Vault.

### Encryption:

* Run the following command in your terminal:

```
ansible-vault encrypt_string '47dwqz9pw6GHy6fbmb6wwh6t8Hc686' --name 'fortigate_token'
```

* This will prompt you to create a password. Once you enter and confirm the password, it will output an encrypted string.

example. 
```
Encryption successful

fortigate_token: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          38323665323035666633396461383536386233336461613036323834363161383863393637333162
          3737393364363030663063303730393862613434613333380a346665656432633936373266333831
          63613033633362373438633965666265323837313832666633383537363161653065396532613332
          3939386435393335300a336530343034616265613833306564663431396435653265653630313236
          39613266386438623266623462326437323765316339323665326336613535343462
```
## Storing Encrypted Token:

Copy the encrypted string.
Save it in a YAML file (e.g., secrets.yml) or directly in your Ansible playbook.

## Run Your First Playbook

Prepare host inventory using the info from the output.

vi hosts.ini

```
[fortigates]
awsfortigate ansible_host=34.248.234.165 fortios_access_token=secrets.yml

[fortigates:vars]
ansible_network_os=fortinet.fortios.fortios
vdom=FG-traffic
fortigate_token=secrets.yml
```

## Write the playbook
* Lets build a playbook that automates building address group for our server.


```
- hosts: fortigates
  connection: httpapi
  collections:
  - fortinet.fortios
  vars:
   ansible_httpapi_use_ssl: yes
   ansible_httpapi_validate_certs: no
   ansible_httpapi_port: 443

  vars_files:
    - secrets.yml

  tasks:
      - name: Define a Jucicehop Address Group
        fortios_firewall_address:
          vdom: "{{ vdom }}"
          access_token: "{{ fortigate_token }}"
          state: "present"
          firewall_address:
            name: "web-add-group"
            subnet: "192.168.1.0 255.255.255.0"
            comment: "Created by Ansible"
```

## Run the playbook to build outbound access 
ansible-playbook -i hosts 00-playbook.yml --ask-vault-pass


## Run the playbook to build outbound access 
ansible-playbook -i hosts 01-playbook.yml --ask-vault-pass

## Spin up JuiceShop App
Now we can install juceishop because its to go out to the interent to download the docker

cd terraform folder and uncomment the main.tf and variables.tf lines

next initiate terraform and apply

```
terraform init
terraform apply -auto-approve
```

## got back into the Ansible Folder
Build a policy to allow access to the juiceshop web app, note you will need the internal IP

ansible-playbook -i hosts 02-playbook.yml --ask-vault-pass

## play with jinja2 templating
ansible-playbook -i hosts 03-playbook.yml --ask-vault-pass

