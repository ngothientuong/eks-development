# AWS INFRASTRUCTURE BUILD

## VPC
#### Description: Infrastructure of a whole Virtual Private Cloud containing a set of IP address via VPC CIDR block, i.e. 103.0.0.0/16
- Build VPC dev, mgmt, prod 
- Dependencies:
    - VPC cidr_block

## SUBNETS
#### Description: Subsets of VPC containing cidr_blocks which are subsets of VPC CIDR block, i.e. 103.0.1.0/24, 103.0.2.0/24, 103.0.254.0/24 
- Build subnets for each environment. 
- No public/private setting for the subnets just yet. It's determined via route tables.

- Dependencies:
    - VPC ID
    - AZ
    - subnets cidr_blocks

## INTERNET GATEWAY
#### Description: A door to allow two ways traffic between the VPC and the internet. Those subnets that can reach out to the internet (0.0.0.0/0) via the IGW are called **public subnets**.
- Build igw dedicated for each VPC dev, mgmt, prod
- This is the gateway for any subnet inside the VPC to communicate to the internet (0.0.0.0/0)
- Route table associating with the subnets that has destination (0.0.0.0/0) and target VPC igw will allow the subnets to talk to the internet. In turn, those subnets are configured as 'public'

- Dependencies:
    - VPC ID

## VPC SECURITY GROUPS
#### Description: The security rule set allowing/denying what cidr_block (subnets, vpc) to communicate with the cidr_block (subnet/vpc) that the security group attach/belong to via certain protocol, ports
- Build security groups associating with the VPC dev, mgmt, prod

- Dependencies:
    - VPC ID
    - ingress rule: protocol, from_port, to_port, cidr_block (IPV4), cidr_block (IPV6)
    - egress rule: protocol, from_port, to_port, cidr_block (IPV4), cidr_block (IPV6)

## Elastic IP
#### Description: An IP that is publically accessible from the internet.
- Build Elastic IP which is a publically accessible IP
- Reserved for bastion host. When building out bastion host later on, assign this EIP to the bastion host.

- Dependencies:
    - [NONE]

## EC2 KEY
#### Description: a key pair that is attached to an EC2 instance for ssh purpose via default ec2-user
- Create EC2 Key pair to later on assign to EC2 instances during the instances creation
- ssh purpose
- Save the vpc to local ~/.ssh directory

- Dependencies:
    - [NONE]

## VPC NAT GATEWAY
#### Description: A 'middle guy' router that associated with a subnet. The NAT Gateway is routable to/from the IGW since the NAT Gateway is configured to be attached to a subnet that is routeable to the internet via target IGW. 
- In order for OTHER subnets which are not routable directly to the destnation all/internet (0.0.0.0/0) via IGW to be able to reach out to the internet, these subnets will need to be routed to the NAT Gateway via a route table. These subnets are called **private subnets** (not directly routable to the destination 0.0.0.0/0 via target internet gateway).
- Build a NAT gateway associate with a subnet which are routable directly to the internet (0.0.0.0/0) via target IGW in a route table, aka. a public subnet. 
- You can have multiple NAT gateway, each associate with a public subnet

- Dependencies:
    - A subnet that is routable to all destination or internet (0.0.0.0/0) via target IGW in a route table (public subnet)

## TRANSIT GATEWAY
#### Description: An internal router connecting between VPC and other peer Transit Gateway. The transit gaway is not exposed to the internet and it resides in a region. 
- A transit gateway is 'glued' with a VPC's cidr_block or the subnets' cidr_blocks in the form of a transit gateway attachment.
- A transit gateway can have multiple transit gateway attachments. Each attachment is associate with a particular VPC cidr_block or subnets' cidr_blocks.
- Dependencies:
    - [NONE]

## TRANSIT GATEWAY ATTACHMENTS
#### Description: An item that associates with both cidr_blocks representing VPCs or subnet AND the transit gateway
- When a transit gateway associating with 2 separate transit gateway attachments where each transit gateway attachment is associting to a separate VPC|subnets' cidr_blocks, then the instances from these 2 separate VPCs are routable via the transit gateway.

- Dependencies:
    - Transit Gateway
    - Subnets of a VPC

## ROUTE TABLE
#### Description: A table that ultimately define which cidr_blocks can be routed to which cidr_blocks via a target. The target can either be 'local', a Transit Gateway, NAT Gateway or Internet Gateway
- Target 'local': Subnets can communicate with its destination locally without any routers (transit gateway, NAT gateway or Internet Gateway)
- Target 'Internet Gateway': Subnets that are routable to destination 0.0.0.0/0 (ALL destinations) via this target are called **public subnets**
- Target 'NAT Gateway': The Subnets that are routable to destination 0.0.0.0/0 (ALL destinations) via this target are called **private subnets**
- Target 'Transit Gateway': The subnets can be routable privately to its destination cidr_block via this transit gateway target as long as there are an TGW attachment at these subnets (sources) and an TGW attachment at the destination AND these TGW attachments associate with this transit gateway.

- Dependencies:
    - Subnets Association's CIDR_blocks (The Source)
    - VPC cidr_block or Subnets' cidr_blocks of the Destination
    - Targets of types:
        - Transit Gateway
        - NAT Gateway
        - Internet Gateway


![MicrosoftTeams-image](https://user-images.githubusercontent.com/34757197/232990948-c419ef8b-8c76-4c80-8b7a-a91550da7563.png)
![MicrosoftTeams-image (4)](https://user-images.githubusercontent.com/34757197/232990952-4ddf9bd4-1864-48f9-8686-aa8fed69abaf.png)
![MicrosoftTeams-image (3)](https://user-images.githubusercontent.com/34757197/232990953-ae1e3777-d0df-45e4-bf3d-b23c6dcc0b49.png)
![MicrosoftTeams-image (2)](https://user-images.githubusercontent.com/34757197/232990956-3c65569b-6d93-4b30-8356-c0a95ca26ed7.png)
![MicrosoftTeams-image (1)](https://user-images.githubusercontent.com/34757197/232990958-fed20b36-6e2b-4f5e-a901-9b429e5b4a11.png)


---

# PROVISION VPC AND INFRASTRUCTURE COMPONENT
## Provisioning Preparation
### Set up dedicated ~/.bashrc
- Ensure the region is correct
- Ensure accounts for both TF and AWS point to the account with full AWS privilege is correct
- Ensure the path to hardcoded tfvars, .hcl  is correct

### HCL, TFVARS FILES
- Make copy and change the content of HCL, TFVARS to appropriate aws_region, s3 bucket, dynamodb info, env, envlc

### DEDICATED FOLDER FOR GLOBAL/{S3,VPC}
- Create folder for the region in global, ie. eu_west_2
- Copy s3, vpc folders into the newly created region folder


### EC2-KEYPAIR
- Create the public key from private key
```
ssh-keygen -f ~/.ssh/tngo-keypair -y > ~/tngo-keypair.pub
```
- Import the public key to the new region EC2 Key service

## Execute The Provisioning
### Run TF in S3 folder
```
terraform init

terraform plan -var-file=/home/vagrant/bl/personal/eks-development/users_spec/tngo/mgmt_eu_west_2_user.tfvars -compact-warnings -out tfm.out

terraform apply tfm.out
```

### Run TF in VPC folder
> -backend-config=${tngo_spec}/user_eu_west_2.hcl
- Comment out the below:

    
**.terraform/modules/transit-gateway/main.tf**:
```
# resource "aws_ram_resource_association" "this" {
#   count = var.create_tgw && var.share_tgw ? 1 : 0

#   resource_arn       = aws_ec2_transit_gateway.this[0].arn
#   resource_share_arn = aws_ram_resource_share.this[0].id
# }

# resource "aws_ram_principal_association" "this" {
#   count = var.create_tgw && var.share_tgw ? length(var.ram_principals) : 0

#   principal          = var.ram_principals[count.index]
#   resource_share_arn = aws_ram_resource_share.this[0].arn
# }
```

**.terraform/modules/transit-gateway/outputs.tf**

```
# output "ram_resource_share_id" {
#   description = "The Amazon Resource Name (ARN) of the resource share"
#   value       = try(aws_ram_resource_share.this[0].id, "")
# }

# output "ram_principal_association_id" {
#   description = "The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma"
#   value       = try(aws_ram_principal_association.this[0].id, "")
# }
```

- Run tfminit, tfmplan and tfmapply as usual

---
# PEERING BETWEEN 2 VPCS VIA TRANSIT GATEWAY
## Create a peering connectiong between 2 transit gateway
- Follow this Link for instruction: https://docs.aws.amazon.com/vpc/latest/peering/create-vpc-peering-connection.html#same-account-different-region

We'll use reggion VPC A of us-east-2 and VPC B of eu-west-2 as an example

### US-EAST-2
- VPC -> Peering connections -> Create peering Connection
- Choose a name for the connection, i.e. **us-east-2-eu-west-2**
- Choose VPC A
- A VPC CIDRs will appear as default choice
- Select another VPC to peer with -> Another Region
- Choose **eu-west-2**
- Choose VPC B
- Create peering connection

### EU-WEST-2
- VPC -> Peering connections
- You should see an entry of the connection with CIDR block of VPC A from us-east-2 in pending status
- Check on the radio button of the connection -> Action -> Accept Request

## Create|Add VPC Route Tables to VPC Peer Connection 
### US-EAST-2
#### VPC Route table
- VPC -> Route Tables -> Create Route Table 
- Name "VPC-A-US-EAST-2-VPC-B-EU-WEST-2"
- Choose CIDR BLOCK of VPC A 
- Create Route Table
- Go back to VPC -> Route tables -> "VPC-A-US-EAST-2-VPC-B-EU-WEST-2" -> Subnet associations -> Edit Subnet associations
- Choose subnets from VPC A you want to be connect to subnets of VPC B. In this case, choose the private subnets from VPC A
- VPC -> Route tables -> "VPC-A-US-EAST-2-VPC-B-EU-WEST-2" -> Routes -> Edit Routes
- Entry 1:
    - Destination: CIDR_BLOCK of VPC A;   
    - Target: Local
- Add route -> Entry 2
    - Destination: CIDR_BLOCK of VPC B or subnet CIDR_BLOCKs of VPC B
    - Target: pcx-XXXX (VPC Peering ID )
#### Transit-Gateway Route table
- VPC -> Transit gateway route tables -> The transit gateway associating with VPC Peering Connection -> Routes
- Create static Route 
    - CIDR: cidr_block of VPC B or subnet cidr_blocks of VPC B
    - Type: Active
    - Choose attachment: The attachment associating with subnets of VPC A. In this case, the attachment is associating with the private subnets of VPC B

### US-WEST-2
#### VPC Route table
- VPC -> Route Tables -> Create Route Table 
- Name "VPC-B-EU-WEST-2-VPC-A-US-EAST-2"
- Choose CIDR BLOCK of VPC B
- Create Route Table
- Go back to VPC -> Route tables -> "VPC-B-EU-WEST-2-VPC-A-US-EAST-2" -> Subnet associations -> Edit Subnet associations
- Choose subnets from VPC B you want to be connect to subnets of VPC A. In this case, choose the private subnets from VPC B
- VPC -> Route tables -> "VPC-B-EU-WEST-2-VPC-A-US-EAST-2" -> Routes -> Edit Routes
- Entry 1:
    - Destination: CIDR_BLOCK of VPC B;   
    - Target: Local
- Add route -> Entry 2
    - Destination: CIDR_BLOCK of VPC A or subnet CIDR_BLOCKs of VPC A
    - Target: pcx-XXXX (VPC Peering ID )
#### Transit-Gateway Route table
- VPC -> Transit gateway route tables -> The transit gateway associating with VPC Peering Connection -> Routes
- Create static Route 
    - CIDR: cidr_block of VPC A or subnet cidr_blocks of VPC A
    - Type: Active
    - Choose attachment: The attachment associating with subnets of VPC B. In this case, the attachment is associating with the private subnets of VPC B


