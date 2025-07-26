# Automated AWS Development Environment with Terraform

## Project Overview

This project provides a fully automated, production-ready remote development environment on AWS, provisioned and managed using Terraform. It is designed to provide a secure, scalable, and efficient workspace for software engineers, accessible directly from VS Code. The infrastructure is defined as code, ensuring consistency, repeatability, and easy customization.

## Features

*   **Automated Infrastructure Provisioning:** Leverages Terraform to automate the creation and management of all necessary AWS resources, including the VPC, subnets, security groups, and EC2 instance.
*   **Secure by Design:** Implements a secure network architecture with a custom VPC and fine-grained security group rules to control inbound and outbound traffic.
*   **Scalable and Flexible:** Built on a scalable EC2 instance that can be easily customized to meet specific performance requirements.
*   **Container-Ready:** The EC2 instance is pre-configured with Docker, enabling seamless development and testing of containerized applications.
*   **Optimized for VS Code:** Designed for a seamless remote development experience with VS Code, allowing developers to work in a powerful cloud-based environment with the familiarity of their local editor.

## Architecture

The infrastructure is deployed within a custom Amazon VPC to ensure network isolation and security. The core components include:

*   **VPC:** A logically isolated virtual network in the AWS cloud.
*   **Subnet:** A public subnet to allow the EC2 instance to access the internet.
*   **Internet Gateway:** Provides internet access to the resources in the VPC.
*   **Route Table:** Defines rules to direct network traffic from the subnet to the internet gateway.
*   **Security Group:** Acts as a virtual firewall for the EC2 instance, controlling inbound and outbound traffic. Only SSH access is allowed from a specified IP address.
*   **EC2 Instance:** A virtual server in the cloud where the development environment is hosted.

## Technologies Used

*   **Terraform:** Infrastructure as Code (IaC) for provisioning and managing the AWS infrastructure.
*   **AWS (Amazon Web Services):** The cloud platform providing the underlying compute, networking, and storage resources.
*   **Docker:** A platform for developing, shipping, and running applications in containers.
*   **VS Code:** A lightweight but powerful source code editor for interacting with the remote development environment.

## Getting Started

### Prerequisites

*   An AWS account
*   Terraform installed on your local machine
*   AWS CLI configured with your credentials
*   VS Code with the Remote - SSH extension

### Deployment

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/terraform-aws-dev-environment.git
    cd terraform-aws-dev-environment
    ```
2.  **Initialize Terraform:**
    ```bash
    terraform init
    ```
3.  **Deploy the infrastructure:**
    ```bash
    terraform apply
    ```
4.  **Connect with VS Code:**
    -   Once the `terraform apply` command is complete, the public IP of the EC2 instance will be displayed as an output.
    -   Use the VS Code Remote - SSH extension to connect to the EC2 instance using the public IP and the private key you specified.
