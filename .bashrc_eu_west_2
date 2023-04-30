# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

export PATH=/usr/local/bin/:$PATH
# Source bash completion
source /usr/share/bash-completion/bash_completion

source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k

## BL SA 1 - mhv like restricted access
#export AWS_SECRET_ACCESS_KEY="7rf1rqdkvVkEmQZp3/PPHElQGuLBuxTs4f51rv3g"
#export AWS_ACCESS_KEY_ID="AKIAZ5XRCA2UKDCZ7OGM"

## BL SA 2 - full admin access
#export AWS_SECRET_ACCESS_KEY="mTcJUbwDz39lPOunb65bI1woSl1QLAbTbtyNk8sO"
#export AWS_ACCESS_KEY_ID="AKIAZ5XRCA2UMGNOIJEI"

complete -C /usr/local/bin/terraform terraform
# BEGIN ANSIBLE MANAGED BLOCK PROJECT_NAME
export PROJECT_NAME="tngo"
# END ANSIBLE MANAGED BLOCK PROJECT_NAME
# BEGIN ANSIBLE MANAGED BLOCK AWS_ACCOUNT_NAME
export AWS_ACCOUNT_NAME=bl-devops-cloud
# END ANSIBLE MANAGED BLOCK AWS_ACCOUNT_NAME
# BEGIN ANSIBLE MANAGED BLOCK AWS_ACCOUNT_NUMBER
export AWS_ACCOUNT_NUMBER=682331604648
# END ANSIBLE MANAGED BLOCK AWS_ACCOUNT_NUMBER
# BEGIN ANSIBLE MANAGED BLOCK AWS_DEFAULT_REGION
export AWS_DEFAULT_REGION=eu-west-2
# END ANSIBLE MANAGED BLOCK AWS_DEFAULT_REGION
# BEGIN ANSIBLE MANAGED BLOCK PROJECT_DOMAIN
export PROJECT_DOMAIN="bylightsdc.bylight.com"
# END ANSIBLE MANAGED BLOCK PROJECT_DOMAIN
# BEGIN ANSIBLE MANAGED BLOCK PROJECT_ARCHIVE
export PROJECT_ARCHIVE=bl-artifacts
# END ANSIBLE MANAGED BLOCK PROJECT_ARCHIVE
# BEGIN ANSIBLE MANAGED BLOCK PROJECT_CIDR_MGMT
export PROJECT_CIDR_MGMT="103.0.0.0/16"
# END ANSIBLE MANAGED BLOCK PROJECT_CIDR_MGMT
# BEGIN ANSIBLE MANAGED BLOCK PROJECT_CIDR_INT
export PROJECT_CIDR_INT="104.0.0.0/16"
# END ANSIBLE MANAGED BLOCK PROJECT_CIDR_INT
# BEGIN ANSIBLE MANAGED BLOCK PROJECT_CIDR_PROD
export PROJECT_CIDR_PROD="105.0.0.0/16"
# END ANSIBLE MANAGED BLOCK PROJECT_CIDR_PROD
# BEGIN ANSIBLE MANAGED BLOCK PROJECT_ID
export PROJECT_ID="tngo"
# END ANSIBLE MANAGED BLOCK PROJECT_ID
# BEGIN ANSIBLE MANAGED BLOCK AWS_ACCESS_KEY_ID
#export AWS_ACCESS_KEY_ID="AKIAZ5XRCA2UKDCZ7OGM"
# END ANSIBLE MANAGED BLOCK AWS_ACCESS_KEY_ID
# BEGIN ANSIBLE MANAGED BLOCK AWS_SECRET_ACCESS_KEY
#export AWS_SECRET_ACCESS_KEY="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"
# END ANSIBLE MANAGED BLOCK AWS_SECRET_ACCESS_KEY

### Service Account - bl-service-account-1 - limited access
export AWS_ACCESS_KEY_ID="AKIAZ5XRCA2UKDCZ7OGM"
export AWS_SECRET_ACCESS_KEY="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"
## BL SA 2 - full admin access
#export AWS_SECRET_ACCESS_KEY="mTcJUbwDz39lPOunb65bI1woSl1QLAbTbtyNk8sO"
#export AWS_ACCESS_KEY_ID="AKIAZ5XRCA2UMGNOIJEI"

function awsdc() {
        aws sts decode-authorization-message --encoded-message ${1}  | sed 's/\\"/"/g' | sed 's/^"//' | sed 's/"$//'  | sed 's/\,/\n/g'
}

## Terraform
export TF_VAR_aws_region=eu-west-2
export TF_LOG=TRACE
export TF_LOG_PATH="/media/sf_vagrantfileshare/terraform.txt"
export TF_VAR_CIDR_INT="104.0.0.0/16"
export TF_VAR_CIDR_MGMT="103.0.0.0/16"
export TF_VAR_CIDR_PROD="105.0.0.0/16"
export TF_VAR_rancher_eks_user_access_key=
export TF_VAR_rancher_eks_user_secret_key=
## BL SA Account 1 - limited access
export TF_VAR_aws_access_key="AKIAZ5XRCA2UKDCZ7OGM"
export TF_VAR_aws_secret_key="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"
## BL SA Account 2 - Full Access
#export TF_VAR_aws_access_key="AKIAZ5XRCA2UMGNOIJEI"
#export TF_VAR_aws_secret_key="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"


export ms=~/bl/personal/eks-development
export eks=~/bl/personal/eks-development/environments/eumgmt/services/eks
export mdl=~/bl/personal/eks-development/modules/services/eks
export tngo_spec=/home/vagrant/bl/personal/eks-development/users_spec/tngo
export work_scripts=/home/vagrant/bl/personal/eks-development/work_scripts

function tfmplan() {
        terraform plan -var-file=/home/vagrant/bl/personal/eks-development/users_spec/tngo/mgmt_eu_west_2_user.tfvars -compact-warnings -out tfm.out
}
function tfminit() {
        terraform init -backend-config=${tngo_spec}/user_eu_west_2.hcl
}
function tfmdestroy() {
        terraform destroy -var-file=/home/vagrant/bl/personal/eks-development/users_spec/tngo/mgmt_eu_west_2_user.tfvars -compact-warnings
}
function tfmrefresh() {
        terraform refresh -var-file=/home/vagrant/bl/personal/eks-development/users_spec/tngo/mgmt_eu_west_2_user.tfvars -compact-warnings
}
function tfmapply() {
        terraform apply tfm.out
}
alias tfmimport="terraform import "


# Kubectl
alias k="kubectl "
alias kgl="kubectl get --show-labels -o wide"
alias kg="kubectl get -o wide"
alias ke="kubectl edit"
alias kd="kubectl describe"
alias kr="kubectl replace --grace-period 0 --force -f"
alias ka="kubectl apply --grace-period 0 --force -f"
alias kstd="kubectl exec -it --stdin --tty"
alias kex="kubectl exec -it"
export ksn="-n kube-system"
alias kct="kubectl config use-context "
export do="--dry-run=client -oyaml"
export drs="--dry-run=server -oyaml"
export now="--grace-period 0 --force"
alias kgc="kubectl config get-contexts "
alias kuc="kubectl config user-context "
alias klo="kubectl logs -f "
alias kdel="kubectl delete --grace-period 0 --force -f"
function kjn() {
  kubectl get $1 -o=jsonpath={.items[*].metadata.name}
}
function kgall {
    for i in $(kubectl api-resources -o name --namespaced)
    do
	if [ "$(kubectl -n ${1} get --ignore-not-found ${i} 2>/dev/null)" != "" ]
        then
            for item in $(kubectl get --show-labels -n ${1} --ignore-not-found ${i} | awk '{print $1}' | tail -n +2 )
            do
                   echo ${i}/${item} 
           done
        fi
    done
}
function destroyall {
    for i in $(kubectl api-resources -o name --namespaced)
    do
        if [ "$(kubectl -n ${1} get --ignore-not-found ${i} 2>/dev/null)" != "" ]
        then
            for item in $(kubectl get --show-labels -n ${1} --ignore-not-found ${i} | awk '{print $1}' | tail -n +2 )
            do
		   if [ "$(echo ${1} )" != "kube-system" ]
		   then
                     kubectl delete -n ${1} ${i}/${item} --grace-period 0 --force
                   else 
			   echo "Can't destroy kube-system"
		   fi
           done
        fi
    done
}
function ns() {
        kubectl config set-context --current --namespace=$1
}
function removecluster() {
        kubectl config delete-cluster $1
        kubectl config unset users.$1
        kubectl config delete-context $1
}
function addcluster(){
	if [ -f ~/.kube/config ]
	then
          sed -i 's/: null/: []/g' ~/.kube/config 
	fi	  
        aws eks update-kubeconfig --region eu-west-2 --name $1
}
function cfn() {
        for i in ${1}*; do new=$(echo $i | sed "s:${2}:${3}:g" ) ; mv ${i} ${new} ; done
}
function mtpl() {
	cd ${eks}/local-exec/jinja2_templates
        for i in "eks-addon-kubectl_run"* ; do new=$(echo $i | sed "s:kubectl_run:${1}:g" ) ; cp -rp ${i} ${new}; sed -i "s:kubectl_run:${1}:g" ${new} ; done
	cd -
}
function mhtpl() {
        cd ${eks}/local-exec/jinja2_templates        
	for i in "eks-addon-aws_lb_controller"* ; do new=$(echo $i | sed "s:aws_lb_controller:${1}:g" ) ; cp -rp ${i} ${new}; sed -i "s:aws_lb_controller:${1}:g" ${new} ; done
        cd -
}
function s3bk() {
	DATE=$(date +%Y%m%d%H%M%S)
	root_path=/home/vagrant/bl/personal/eks-development
	local_sync_folder="mhv-ms"
	local_sync_src=$(echo ${root_path}/${local_sync_folder})
	cp -rp ~/.bashrc ${local_sync_src}/
	s3_bucket="tngo-backup"
	s3_sync_dest=$(echo s3://${s3_bucket}/${DATE}/${local_sync_folder})
	aws s3 sync s3://tim-tf-k8s-state/ s3://${s3_bucket}/${DATE}/tim-tf-k8s-state/
	aws s3 sync $local_sync_src $s3_sync_dest
}
function ubuntu() {
	kubectl run ubuntu --image=ubuntu:latest  -- sh -c "apt update -y; apt install dnsutils curl -y; sleep 5d"
}
function centos() {
        kubectl run centos --image=centos:latest  -- sh -c "yum update -y ; yum install bind-utils curl nmap wget -y; sleep 5d"
}
function amzlnx2 {	
	kubectl run amzlnx2 --image=blutv/amazonlinux2-python3:latest -- bash -c "yum update -y ; yum install dnsutils curl wget -y; sleep 5d"
}
alias mnkube="minikube start --memory 10240 --cpus 4"
alias gitadd="cp -rp ~/.bashrc ~/.bashrc_eu_west_2 ~/.bashrc_us_east_2 ~/.ssh /home/vagrant/bl/personal/eks-development/; git add --all"
export gitkey=$(kg secret -n kube-system private-github-pat -o=jsonpath={.data.key} | base64 -d)
alias argocd="argocd --grpc-web"
alias kzfix="kustomize edit fix"
function restartdeploy(){
	for i in $(kg ns --no-headers | awk {'print $1'}); do kubectl config set-context --current --namespace="${i}"; kubectl rollout restart deploy ; done
}
function scalealldeploy(){
        for i in $(kg ns --no-headers | awk {'print $1'}); do kubectl config set-context --current --namespace="${i}"; 
	for dpl in $(kg deploy --no-headers | awk {'print $1'});
	do	
	kubectl scale deploy $dpl --replicas=${1}; 
	done
	done
}
export CLUSTER1=arn:aws:eks:us-east-2:682331604648:cluster/project-mgmt-eks-cluster-rancher-test
export CLUSTER2=arn:aws:eks:us-east-2:682331604648:cluster/project-mgmt-eks-cluster-int-test
export CLUSTER3=arn:aws:eks:us-east-2:682331604648:cluster/project-mgmt-eks-cluster-int-2
export CLUSTER4=arn:aws:eks:eu-west-2:682331604648:cluster/project-eumgmt-eks-eu-west-2

function viewtls(){
  for i in ca\\.crt ca\\.key tls\\.crt tls\\.key
  do
	  TMP=$(kubectl get secret ${1} -oyaml -ojsonpath={.data.${i}})
	  if [ "$(echo $TMP)" != "" ]
	  then	  
            echo "==== ${i} base64 ====:"  
            echo $TMP
	    echo "==== ${i} base64 DECODE ====:"
	    echo $TMP | base64 -d 
	    echo "==== ${i} cert content ====:"
	    echo $TMP | base64 -d > ./${1}-$(echo ${i} | sed -e 's:\\::g')
	    chmod 644 ./${1}-$(echo ${i} | sed -e 's:\\::g')
              if [ "$(echo $i |  sed -e 's:\\::g' | grep '.key')" == "" ]
              then
	       openssl x509 -in ./${1}-$(echo ${i} | sed -e 's:\\::g') -text -noout
	      fi
          fi  
  done	  
}
function viewcrt(){
  openssl x509 -in ${1} -text -noout > ${1}.txt
}
function viewnodeport(){
  kubectl get svc -A -o=jsonpath='{range..items[?(.spec.type=="NodePort")]}{.metadata.name}{"\n"}{end}'
}
function hubblefw(){
  cilium hubble port-forward&
}
function removeciliumsecret() {
  for i in clustermesh-apiserver-admin-cert clustermesh-apiserver-client-cert clustermesh-apiserver-external-workload-cert clustermesh-apiserver-server-cert  ; do kubectl delete secret $i -n kube-system ; done
}
## Remove resources in cilium-test generated by cilium clustermesh connectivity test
function removeciliumtest(){
  for sa in echo-other-node echo-same-node client client2; do kubectl delete sa ${sa} -n cilium-test; done
  for svc in echo-other-node echo-same-node; do kubectl delete svc/${svc} -n cilium-test; done
  for deploy in echo-same-node echo-other-node client client2; do kubectl delete deploy/${deploy} -n cilium-test; done
}
function dmesh() {
  cilium clustermesh disable --context ${1}
}
function emesh() {
  cilium clustermesh enable --context ${1}
}
# Switch cluster or check current namespace via python scripts
function cc() {
  python ${work_scripts}/change_cluster.py
}
# Change namespace
function cns(){
  python ${work_scripts}/change_namespace.py
}
function eu() {
  cp -rp ~/.bashrc_eu_west_2 ~/.bashrc
  source ~/.bashrc
}
function us(){
  cp -rp ~/.bashrc_us_east_2 ~/.bashrc
  source ~/.bashrc
}
alias kgt="kubectl get -o wide --sort-by=.metadata.creationTimestamp "
function watchpo() {
 while true ; do sleep 1; date; kgt po -A ; kubectl get node -oyaml | grep -iA3 taint; done
}
function tmesh(){
	while true; do kubectl exec -ti deployment/x-wing -- curl rebel-base; done
}
function listsvc(){
  kubectl get svc -A -ojsonpath="{range .items[*]} {.metadata.namespace} {'\t'} {.metadata.name} {'\t'} {@.spec.type} {'\t'}  {'\t'} {range @.spec.ports[*]}{@.name}{'\t'}{'\t'}{@.port} {'\t'} {@.targetPort} {'\t'} {@.nodePort}{'\n'}{'\t'}{'\t'}{end}{'\n'}{end}"
}
function listpp(){
  kubectl get po -A -ojsonpath="{range .items[*]} {.metadata.namespace} {'\t'} {.metadata.name} {'\t'} {.status.hostIP} {'\t'} {range @.spec.containers[*]} {'\t'} {@.name} {range @.ports[*]} containerPort:{@.containerPort} - hostPort:{@.hostPort}{'\t'}{end}|{'\t'}{end}{'\n'}{end}"
}
function listciliumNode() {
  kubectl get cn
}
function generaterootca(){
  # Valid for 10 years = 3650 days
  # ${1} is Domain name and ${2} is alternatives name
  openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout ./root-key.pem -out ./root-cert.pem -subj "/CN=${1}" \
  -addext "subjectAltName=DNS:${2}"
}
function removecrd() {
  kubectl delete customresourcedefinition.apiextensions.k8s.io/${1} &
  kubectl patch customresourcedefinition.apiextensions.k8s.io/${1} -p '{"metadata":{"finalizers":[]}}' --type=merge
}
function removeargocdapp() {
  kubectl patch app ${1} -p '{"metadata": {"finalizers": null}}' --type merge --context $CLUSTER1 -n argocd
  kubectl delete app ${1} --context $CLUSTER1 -n argocd
}
function commitargo(){
  cd ~/bl/argocd-eks-app
  git add --all
  sleep 1;
  git commit -m "${1}"
  sleep 1
  git push
  cd -
}
function base64d (){
  echo "${1}" | base64 -d
}
function base64e (){
  echo "${1}" | base64
}
## Get list of name of resources
function listname (){
  kubectl get ${1} -o wide --no-headers | awk '{print $1}'
}
## Decode key ${2} in a secret ${1}
function dsecret () {
  base64d $(kubectl get secret ${1} -ojsonpath={.data.${2}})
}
function copysecret() {
  kubectl get secret ${1} --namespace=${2} -o yaml | sed "s/namespace: .*/namespace: ${3}/" | kubectl apply -f -
}
function portfwd() {
  kubectl port-forward ${1} ${2}:${2}
}
