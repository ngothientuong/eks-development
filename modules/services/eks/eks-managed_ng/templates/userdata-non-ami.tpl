MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: text/x-shellscript; charset="us-ascii"
Content-Disposition: attachment; filename="cloud-config.txt"
#!/bin/bash
set -ex

%{ if length(pre_userdata) > 0 ~}
# User-supplied pre userdata
${pre_userdata}
%{ endif ~}
%{ if format_mount_nvme_disk ~}
echo "Format and Mount NVMe Disks if available"
IDX=1
DEVICES=$(lsblk -o NAME,TYPE -dsn | awk '/disk/ {print $1}')

for DEV in $DEVICES
do
  mkfs.xfs /dev/$${DEV}
  mkdir -p /local$${IDX}

  echo /dev/$${DEV} /local$${IDX} xfs defaults,noatime 1 2 >> /etc/fstab

  IDX=$(($${IDX} + 1))
done
mount -a
%{ endif ~}
%{ if length(service_ipv4_cidr) > 0 ~}
export SERVICE_IPV4_CIDR=${service_ipv4_cidr}
%{ endif ~}
%{ if length(service_ipv4_cidr) > 0 ~}
export SERVICE_IPV6_CIDR=${service_ipv6_cidr}
%{ endif ~}
%{ if length(custom_ami_id) > 0 ~}
B64_CLUSTER_CA=${cluster_ca_base64}
API_SERVER_URL=${cluster_endpoint}
/etc/eks/bootstrap.sh ${eks_cluster_id} --kubelet-extra-args '${kubelet_extra_args}' ${bootstrap_extra_args}

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="post_userdata.txt"

#!/bin/bash
/bin/echo "Hello World" >> /tmp/testfile.txt
# Install AWSCLI
/bin/pwd >> /tmp/testpwd.txt
/usr/bin/date >> /tmp/testdate_1.txt
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo mkdir -p /etc/pki/tls/source/anchors
sudo aws s3 cp s3://${s3_artifact}/certs/va.internal.ca.bundle.crt /etc/pki/ca-trust/source/anchors/va.internal.ca.bundle.crt
sudo update-ca-trust extract
cat /etc/eks/containerd/containerd-config.toml >> /tmp/test.toml
echo '[plugins."io.containerd.grpc.v1.cri".registry.configs."registry-1.docker.io".auth]' >> /etc/eks/containerd/containerd-config.toml
echo "username = \"$(aws --region=${aws_region} ssm get-parameter --name "/${project_id}/dockerhub/registry/proxy/service/account/username" --with-decryption --output text --query Parameter.Value)\"" >>/etc/eks/containerd/containerd-config.toml
echo "password = \"$(aws --region=${aws_region} ssm get-parameter --name "/${project_id}/dockerhub/registry/proxy/service/account/password" --with-decryption --output text --query Parameter.Value)\"" >>/etc/eks/containerd/containerd-config.toml
sudo systemctl restart containerd
/usr/bin/date >> /tmp/testdate_2.txt
#sudo sed -i '$ a [plugins."io.containerd.grpc.v1.cri".registry.configs."registry-1.docker.io".auth] \n username = "'$(aws --region=us-gov-west-1 ssm get-parameter --name "/${project_id}/dockerhub/registry/proxy/service/account/username" --with-decryption --output text --query Parameter.Value)'" \n password = "'$(aws --region=us-gov-west-1 ssm get-parameter --name "/${project_id}/dockerhub/registry/proxy/service/account/password" --with-decryption --output text --query Parameter.Value)'" ' /etc/eks/containerd/containerd-config.toml
sudo systemctl restart containerd
%{ endif ~}
%{ if length(post_userdata) > 0 ~}
# User-supplied post userdata
${post_userdata}
%{ endif ~}

--//--
