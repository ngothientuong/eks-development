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




