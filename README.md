# Course-Project-pt2
Minecraft server set up with terraform/ansible

## Background

As part of the DevOps automation initiative, this project demonstrates the full provisioning and configuration of a Minecraft server on AWS using Infrastructure as Code (IaC) principles. The server setup is fully automated using Terraform and Ansible.

In Part 1, the Minecraft server was deployed manually via the AWS Console. In this continuation (Part 2), we aim to:

- Replace manual steps with automated scripts
- Use Terraform to provision AWS resources (EC2 instance, SSH key)
- Use Ansible to install Java, configure the Minecraft server, and enable auto-start
- Connect to the server without logging into the AWS Console or using SSH manually

This not only improves reproducibility and scalability, but also aligns with best practices in modern cloud administration. The project ensures that Acme Corp’s internal Minecraft server is resilient, repeatable, and easy to maintain.



## Requirements
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) ≥ 1.2.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) 2.27.26 
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html)2.14.13-1
- Python 3.13.3
- AWS Credential
- OpenSSH (MAC)
- Any Linux VM (Win)
- nmap

### AWS Configuration
- AWS CLI must be configured with IAM credentials that allow:
  - Creating EC2 instances
  - Creating key pairs
  - Using/Creating existing VPC and security groups

#### Get your Credential:
1. Start your AWS Academy Learner Lab.
2. Click on "AWS Details" in the top right corner of your Learner Lab page.
3. Create the file ~/.aws/credentials and copy the credentials from your "AWS Details" tab. Save the file.

#### Or on Windows using command prompt:

```bash
aws configure
```

and copy the values over to corresponding section

### Environment
- Terraform will generate private key over to
```~/mc_terraform_key.pem```
- Find your terraform install on local machine, and add it to environment variable

## Broad Overview

This project automates the end-to-end setup of a Minecraft server on AWS using Terraform and Ansible. It replaces all manual actions (like using the AWS Console or SSH) with infrastructure and configuration code.

The automation pipeline includes the following stages:

1. **Terraform (Infrastructure Provisioning)**
   - Generates a new SSH key pair and saves the private key to the local machine.
   - Provisions an EC2 instance running Amazon Linux 2.
   - Create a new security group that allows SSH (port 22) and Minecraft traffic (port 25565).

2. **Ansible (Server Configuration)**
   - Copy the generated key from local to VM and change permission
   - Installs Java 21 via the Adoptium package repository.
   - Downloads the latest Minecraft server JAR.
   - Accepts the EULA automatically.
   - Sets up a `systemd` service to ensure the Minecraft server auto-starts on reboot.

4. **Validation**
   - Once the setup is complete, the user can verify the server is running by scanning port `25565` using `nmap`.

This fully automated pipeline ensures the Minecraft server is ready for use immediately after running the Terraform and Ansible scripts, without any manual configuration or console interaction.

## Tutorial (Window Based)
1. Install terraform and aws cli on local device
2. verify installation with
```bash
terraform -help
aws --version
```
3. Clone the Repository
```bash
git clone https://github.com/practicalPro/Course-Project-pt2.git
cd Course-Project-pt2/terraform
```
4. Set up Aws CLI Credentials
Make sure your AWS CLI is configured with credentials that have access to EC2.
```bash
aws configure
```
5. Run Terraform to Provision Infrastructure
```bash
terraform init
terraform apply
```
This will:
- Terraform will create a ssh key and store it in your local home directory (not VM) ```~/```
- Launch EC2 instance without AWS console
- Output the public ip, path of the key, instance id

**Note down the IP for later use**

6. Open up another command prompt to open up your linux terminal/local VM
7. Install Ansible to run the playbook to install/run minecraft, and nmap to verify the minecraft server status
```bash
sudo apt install ansible-core
sudo apt install nmap
```
8. Copy the key from local machine over to VM, Run:
```bash
cp /mnt/c/Users/<your-username>/.ssh/mc_terraform_key.pem ~/
chmod 400 ~/mc_terraform_key.pem
```
9. Modify inventory.ini, replace ```<your-ec2-public-ip>``` with the public ip we got from terraform
10. On your VM, change directory to path of git clone, then run:
```bash
cd ansible
ansible-playbook playbook.yml -i inventory.ini
```
This will:
- Install Java 21
- Download and set up the Minecraft server
- Accept the EULA
- Enable the server to auto-start on boot using systemd
11. Verify Minecraft is running, run:
  ```bash
  nmap -sV -Pn -p T:25565 <your-ec2-public-ip>
  ```
12. Verify the reboot function works, run:
```bash
aws ec2 reboot-instances --instance-ids <instance-id> --region us-west-2
```
13. Run nmap again to check if the server is closed
  ```bash
  nmap -sV -Pn -p T:25565 <your-ec2-public-ip>
  ```
14. After 1-2 minutes, run nmap again to see if nmap is running again
```bash
  nmap -sV -Pn -p T:25565 <your-ec2-public-ip>
  ```
## Source
- AWS Credential Configuration (SYSTEM ADMINISTRATION (CS_312_001_S2025) Lab Week 9)
