Prerequisite addons:
    - external dns
    - cni (cilium in this case)
    - aws-load-balancer
    - cert-manager
    - AWSPCA (maybe not)
1. No need to run cert secret. ALB will pull directly from ACM, not from AWS Issuer

2. Apply the following:    
    - 2-argocd-namespace.ayml
    - Switch to argocd namespace
    - 3-argocd-install.yaml
    - 4a-argocd-server-alb.yaml