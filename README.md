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

