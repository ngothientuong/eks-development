Installation Guide:
- Files location: modules/eks/addon/generic_kubectl/manifests/argocd
- Ensure external-dns is installed and able to write records to backend, i.e, route53 for aws
- Download yaml files to be ran against the cluster
    Download HA install yaml files first: https://argo-cd.readthedocs.io/en/stable/operator-manual/installation/#high-availability
    Download URL: https://github.com/argoproj/argo-cd/blob/master/manifests/ha/install.yaml

- Modify 3-argocd-install.yaml
    Add spec.type: NodePort for argocd-server's Service (line 17808)
- Apply Change 1-cert-secert.yaml
- Apply 3-argocd-install.yaml
- Inspect the NodePort pointing to port 443 of service argocd-server
- Modify file 2a-argocd-server-alb.yaml with the following:
    The subnets has to be PUBLIC subnet of the same VPC running the cluster
    The healthcheck-port must be the same port as the NodePort found above
    All other fields are required
- Access the browser as specified in the rules[*].host field.


```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-ingress
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing # Required
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443},{"HTTP":80}]' # Required
    alb.ingress.kubernetes.io/ssl-redirect: '443' # Required
    alb.ingress.kubernetes.io/backend-protocol: "HTTPS" # Required
    alb.ingress.kubernetes.io/load-balancer-name: tngo-eks-argocd-alb
    alb.ingress.kubernetes.io/ip-address-type: ipv4
    kubernetes.io/ingress.class: alb    # Required
    alb.ingress.kubernetes.io/healthcheck-path: "/healthz?full=true"    # Required
    alb.ingress.kubernetes.io/healthcheck-protocol: "HTTPS"  # Required
    alb.ingress.kubernetes.io/healthcheck-port: "31191"      # Has to be the same as the nodePort
    alb.ingress.kubernetes.io/subnets: 'subnet-0f08d68d1c661395a,subnet-0312fb0e0e36c8b49'   # Required to be in public subnets for internet facing!!  

    # Cert Manager
    cert-manager.io/issuer: tngo-eks-ca
    #cert-manager.io/cluster-issuer: tngo-eks-ca
    cert-manager.io/issuer-kind: AWSPCAClusterIssuer
    cert-manager.io/issuer-group: awspca.cert-manager.io

    # External DNS
    external-dns.alpha.kubernetes.io/hostname: tngo-eks-argocd.bylightsdc.bylight.com

spec:
  #ingressClassName: alb
  tls: # < placing a host in the TLS config will determine what ends up in the cert's subjectAltNames
  - hosts:
    - tngo-eks-argocd.bylightsdc.bylight.com
    secretName: tngo-eks-argocd-cert # < cert-manager will store the created certificate in this secret.
  rules:
  - host: tngo-eks-argocd.bylightsdc.bylight.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              number: 443    


```

#########################
## Connect to Git Repo ##
#########################
- Generate ssh key: ssh-keygen -t ed25519 -C "Tuong Private Git Repo"
- Go to github repo -> setting -> deploy ssh key -> Place in public key
- Go to ArgoCD UI -> Setting -> +Connect Repo
    The address for repo is:   "git@github.com:<your user name>/<name of repo>.git
    Put in private key and fill out the rest of the form

###############################
## Connect to remote Servers ##
## ############################
- Ensure you add clusters in your kubectl first so you have cluster CONTEXT in hand
  argocd cluster add <CLUSTER CONTEXT>
argocd cluster add arn:aws:eks:us-east-2:682331604648:cluster/project-mgmt-eks-cluster-rancher-test
argocd cluster add arn:aws:eks:us-east-2:682331604648:cluster/project-mgmt-eks-cluster-int-test
- You should see the cluster (unknown status) in the UI because of no apps

###################################
## Deploy the first example app  ##
###################################
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://87FE42E2F4258886AAD287E4F42B393B.gr7.us-east-2.eks.amazonaws.com --dest-namespace default
argocd app create guestbook-cluster1 --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://D13A3C493A0CFE9DCBEAFE5639226574.gr7.us-east-2.eks.amazonaws.com --dest-namespace default

