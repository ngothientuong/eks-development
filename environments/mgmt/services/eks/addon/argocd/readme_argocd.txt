Prerequisite addons:
    - external dns
    - cni (cilium in this case)
    - aws-load-balancer
    - cert-manager
    - AWSPCA (maybe not)

# No need to run cert secret. ALB will pull directly from ACM, not from AWS Issuer

# Apply the following:    
    - 2-argocd-namespace.ayml
    - Switch to argocd namespace
    - 3-argocd-install.yaml
    - 4a-argocd-server-alb.yaml
# If your admin account password doesn't work after fresh install, follow these step:
    !!! note "Generating a bcrypt hash" Use the following command to generate a bcrypt hash for admin.password
        argocd account bcrypt --password <YOUR-PASSWORD-HERE>
    To apply the new password hash, use the following command (replacing the hash with your own):

    # bcrypt(password)=$2a$10$rRyBsGSHK6.uc8fntPwVIuLVHgsAhAX7TcdrqW/RADU0uh7CaChLa
    kubectl -n argocd patch secret argocd-secret \
    -p '{"stringData": {
        "admin.password": "$2a$10$rRyBsGSHK6.uc8fntPwVIuLVHgsAhAX7TcdrqW/RADU0uh7CaChLa",
        "admin.passwordMtime": "'$(date +%FT%T%Z)'"
    }}'


# Login to argocd server via argocdcli
#argocd login <your argocd server url>:<port>
argocd login tngo-eks-argocd.bylightsdc.bylight.com:443

# Connect to github repository
- Generate ssh keys
- Github -> Add public key to github repo via setting -> Deploy keys
- ArgoCD -> Add private key to argoCD UI or via argocdcli: argocd repo add git@github.com:ngothientuong/argocd-eks-app.git --ssh-private-key-path ~/.ssh/id_ed25519
    Note: If connection failed, delete key in Github and redeploy the key in Github repo

# Connect to cluster via argoCDcli
#argocd cluster add CONTEXT 
argocd cluster add  arn:aws:eks:us-east-2:682331604648:cluster/project-mgmt-eks-cluster-int-2
argocd cluster add arn:aws:eks:us-east-2:682331604648:cluster/project-mgmt-eks-cluster-int-test
argocd cluster add arn:aws:eks:us-east-2:682331604648:cluster/project-mgmt-eks-cluster-rancher-test
argocd cluster add arn:aws:eks:eu-west-2:682331604648:cluster/project-eumgmt-eks-eu-west-2

