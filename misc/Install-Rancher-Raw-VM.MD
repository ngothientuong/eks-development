# Install Rancher RKE2 on Blank VMs
Version: RKE2 v2.7
Compatible K8s version: 1.25
**Note**: This section describe the installation of Rancher on the new VM that does not have K8s installed.

# Requirement
- Infrastructure
- Install K8s
- Install Rancher
## Infrastructure
Reference: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/other-installation-methods/rancher-behind-an-http-proxy/set-up-infrastructure 

1. 3 Linux Node (or odd number of nodes) to avoid split-brain due to quorum rule (n/2) + 1
2. A load balancer to direct front-end traffic to the three nodes.
3. A DNS record to map a URL to the load balancer. This will become the Rancher server URL, and downstream Kubernetes clusters will need to reach it.

### Linux Node
Reference: 
```
https://ranchermanager.docs.rancher.com/pages-for-subheaders/installation-requirements
https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/infrastructure-setup/nodes-in-amazon-ec2
```

1. **Internet Connection**:Connectivity to the internet through HTTP proxy
2. **Docker**: No need to install Docker since RKE2 is shipped with containerd in it's installation package
3. **Harware** (CPU, Mem): https://ranchermanager.docs.rancher.com/pages-for-subheaders/installation-requirements#rke2-kubernetes
4. **Disk**: SSD is recommended or dedicated storage with max IOPS
5. **Network**: If a server containing Rancher has the X-Frame-Options=DENY header, some pages in the new Rancher UI will not be able to render after upgrading from the legacy UI. This is because some legacy pages are embedded as iFrames in the new UI.
6. **IP Address**: Need static dedicated IP address for the RKE Nodes
7. **Ports**: 
   - **Critical**: The VXLAN port on nodes should not be exposed to the world as it opens up your cluster network to be accessed by anyone. Run your nodes behind a firewall/security group that disables access to port 8472.
   - URL1: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-requirements/port-requirements#ports-for-rancher-server-nodes-on-rke2
   - Just open the port range similarly like AWS EKS `1025-65535`, 80, 443, 5473, 2379, 2380, 8472, 6443, 9345
   - Additional Ports that are ALWAYS required regardless of what type of K8s cluster: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-requirements/port-requirements#other-port-considerations
   - Additional Port for DownStream K8s Cluster: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-requirements/port-requirements#downstream-kubernetes-cluster-nodes

### Load Balancer
- Route traffic to the ingress controller of the 3 static K8s Nodes hosting Rancher RKE2 clusters
### DNS Record
- Register DNS record for the Load Balancer which is the Rancher server URL that downstream Kubernetes clusters will need to reach

# Install Kubernetes
Reference: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/other-installation-methods/rancher-behind-an-http-proxy/install-kubernetes

## All 3 RKE2 `server nodes` in the control plane 
- Export IP address and Port of the proxy to environment variable
```
export proxy_host="10.0.0.5:8888"
export HTTP_PROXY=http://${proxy_host}
export HTTPS_PROXY=http://${proxy_host}
export NO_PROXY=127.0.0.0/8,10.0.0.0/8,cattle-system.svc,172.16.0.0/12,192.168.0.0/16
```

- On every node in the **control plane**, run RKE2 install script to install K8s clusters. Change `v1.xx` to correct k8s supported version from Rancher
```
curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.xx sh -
```
- Configure HTTP proxy setting on RKE2 systemd service so that RKE2's containerd can pull images through the proxy:
```
cat <<'EOF' | sudo tee /etc/default/rke2-server > /dev/null
HTTP_PROXY=http://${proxy_host}
HTTPS_PROXY=http://${proxy_host}"
NO_PROXY=127.0.0.0/8,10.0.0.0/8,cattle-system.svc,172.16.0.0/12,192.168.0.0/16,.svc,.cluster.local
EOF
```
- On the **first** RKE2 node hosting Rancher, make the following file, fix the DNS of the Rancher URL in `tls-san` section to match with your DNS registered for the LB pointing to RKE2 nodes hosting Rancher. Also add node taint to prevent Racher deployment to run on control plane of RKE2 cluster hosting Rancher. We want the rancher deployment to be run in the `agent nodes` (`worker nodes` hosting Rancher application)
- `/etc/rancher/rke2/config.yaml`
    ```
    token: my-shared-secret
    tls-san:
    - my-kubernetes-domain.com  
    - another-kubernetes-domain.com
    node-taint:
      - "CriticalAddonsOnly=true:NoExecute"
    ```
- On the rest of the nodes (2) of the RKE2 hosting rancher, be sure to fix the correct server URL `https://my-kubernetes-domain.com:9345` for your Rancher URL.
- `/etc/rancher/rke2/config.yaml`
    ```
    server: https://my-kubernetes-domain.com:9345
    token: my-shared-secret
    tls-san:
    - my-kubernetes-domain.com  
    - another-kubernetes-domain.com
    node-taint:
      - "CriticalAddonsOnly=true:NoExecute"
    ```  
- After that start and enable the rke2-server service from the **first** node to the rest of the **server nodes**:
  ```
  systemctl enable rke2-server.service
  systemctl start rke2-server.service
  ```
- View logs
  ```
  export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
  alias kubectl=/var/lib/rancher/rke2/bin/kubectl
  kubectl cluster-info
  kubectl get pods --all-namespaces
  ```
## Install `agent nodes` (`worker nodes`) and join them to the control plane of RKE2 cluster hosting Rancher
Reference: https://docs.rke2.io/install/quickstart#linux-agent-worker-node-installation
- Require sudo access
  ```
  curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -
  ```
-  Enable the rke2-agent service
  ```
  systemctl enable rke2-agent.service
  ```
- Configure the rke2-agent service
  ```
  mkdir -p /etc/rancher/rke2/
  vim /etc/rancher/rke2/config.yaml
  ```
- Content for config.yaml:
  ```
  server: https://<server>:9345
  token: <token from server node>
  ```
- **Note**: The rke2 server process listens on port 9345 for new nodes to register. The Kubernetes API is still served on port 6443, as normal.
- Start the service
  ```
  systemctl start rke2-agent.service
  ```
- Monitor log
  ```
  journalctl -u rke2-agent -f
  ```

**Congratulation**: You have successfully install RKE2 K8s cluster!

# Install Rancher
Reference: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/other-installation-methods/rancher-behind-an-http-proxy/install-rancher

## Requirements - Install Rancher Application 
- Install Helm cli
- Install cert-manager
- Install Rancher

### Install Helm cli
- Install helm CLI in your working linux machine where you run kubectl
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
sudo ./get_helm.sh
```

### Install cert-manager
```
helm repo add jetstack https://charts.jetstack.io
kubectl create namespace cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
```
- **Note**: Install it with Helm. Note that cert-manager also needs your proxy configured in case it needs to communicate with Let's Encrypt or other external certificate issuers:
```
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager --version v1.11.0 \
  --set http_proxy=http://${proxy_host} \
  --set https_proxy=http://${proxy_host} \
  --set no_proxy=127.0.0.0/8\\,10.0.0.0/8\\,cattle-system.svc\\,172.16.0.0/12\\,192.168.0.0/16\\,.svc\\,.cluster.local
```
- Now you should wait until cert-manager is finished starting up:
```
kubectl rollout status deployment -n cert-manager cert-manager
kubectl rollout status deployment -n cert-manager cert-manager-webhook
```

### Install Rancher
**Critical**: If you don't intend to send telemetry data, opt out telemetry during the initial login. Leaving this active in an air-gapped environment can cause issues if the sockets cannot be opened successfully.
#### Review and prepare for Rancher URL certificate
- There are a lot of sections to follow through in preparation steps here
- Critical: Run `helm template` command to generate the rendered yaml file and modify `cluster.yaml` in later step
**Rancher Helm Chart Options**: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-references/helm-chart-options
- set bootstrapPassword
- set API Audit Log
- **TLS Settings**: When you install Rancher inside of a Kubernetes cluster, TLS is offloaded at the cluster's ingress controller. The possible TLS settings depend on the used ingress controller.
  - TLS settings: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-references/tls-settings
- **Import local Cluster**: By default Rancher server will detect and import the local cluster it's running on. User with access to the local cluster will essentially have "root" access to all the clusters managed by Rancher server.
  - --set addLocal="false"
  - **Critical**: If you turn addLocal off, most `Rancher v2.5` features **won't work**, including the EKS provisioner.
- Customizing your Ingress: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-references/helm-chart-options#customizing-your-ingress
  - To customize or use a different ingress with Rancher server you can set your own Ingress annotations.
  - Example:
    - --set ingress.extraAnnotations.'cert-manager\.io/cluster-issuer'=issuer-name
    - --set ingress.configurationSnippet='more_set_input_headers X-Forwarded-Host {{ .Values.hostname }};'
- HTTP Proxy: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-references/helm-chart-options#http-proxy
  - Follow through with this section here
- Additional Trusted CAs for `private registries`, `catalogs`:
  - Reference: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-references/helm-chart-options#additional-trusted-cas
  - If you have private registries, catalogs or a proxy that intercepts certificates, you may need to add additional trusted CAs to Rancher.
  - --set additionalTrustedCAs=true
  - kubectl -n cattle-system create secret generic tls-ca-additional --from-file=ca-additional.pem=./ca-additional.pem
- If install with Private Registry, follow the `airgap installation docs` for an environment where Rancher server will be installed offline, behind a firewall, or behind a proxy: https://ranchermanager.docs.rancher.com/pages-for-subheaders/air-gapped-helm-cli-install
- External TLS Termination: We ***recommend*** configuring your load balancer as a `Layer 4 balancer`, forwarding plain 80/tcp and 443/tcp to the Rancher Management cluster nodes. The Ingress Controller on the cluster will redirect http traffic on port 80 to https on port 443.
  - You may terminate the SSL/TLS on a L7 load balancer external to the Rancher cluster (ingress). Use the --set tls=external option and point your load balancer at port http 80 on all of the Rancher cluster nodes
  - **Critical**: If you are using a Private CA signed certificate, add `--set privateCA=true` and see Adding TLS Secrets - Using a Private CA Signed Certificate to add the CA cert for Rancher.
- Configuring Ingress for External TLS when Using `NGINX v0.25`: 
  - Reference: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-references/helm-chart-options#configuring-ingress-for-external-tls-when-using-nginx-v025
  - Run `helm template` and edit `cluster.yml` to enable the use-forwarded-headers option for ingress (or maybe the below is what's in values.yaml):
  ```
    ingress:
    provider: nginx
    options:
        use-forwarded-headers: 'true'
  ```
  - Example Nginx config (**Not suited for PROD**) tested with `NGINX 1.14`: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-references/helm-chart-options#example-nginx-config
```
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system
```
- **Note**: And install Rancher with Helm. Rancher also needs a proxy configuration so that it can communicate with external application catalogs or retrieve Kubernetes version update metadata:
```
helm upgrade --install rancher rancher-latest/rancher \
   --namespace cattle-system \
   --set hostname=rancher.example.com \
   --set proxy=http://${proxy_host} \
   --set noProxy=127.0.0.0/8\\,10.0.0.0/8\\,cattle-system.svc\\,172.16.0.0/12\\,192.168.0.0/16\\,.svc\\,.cluster.local
```
- Wait for the deployment to finish:
```
kubectl rollout status deployment -n cattle-system rancher
```
**Congratulation**: You can now navigate to https://rancher.example.com and start using Rancher.