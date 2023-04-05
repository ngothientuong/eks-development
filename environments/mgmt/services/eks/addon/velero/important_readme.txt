Important
The deployed chart doesn't receive security updates automatically. You need to manually upgrade to a newer chart when it becomes available. 


## The below is irrelevant since you're upgrading with terraform
When upgrading, change install to upgrade in the previous command, but run the following command to install the TargetGroupBinding custom resource definitions before running the previous command.
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"