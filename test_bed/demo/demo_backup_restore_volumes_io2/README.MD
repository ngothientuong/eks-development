Reference: https://aws.amazon.com/blogs/containers/using-amazon-ebs-snapshots-for-persistent-storage-with-your-amazon-eks-cluster-by-leveraging-add-ons/ 
1. Change to default namespace
1. Apply 01 -> 05
2. Go to AWS Snapshot -> View Created snapshot (4GB)
3. Run kubectl delete 04-pod.yaml, 03-pvc.yaml
4. Create pvc from snapshot: run 06-pvc-from-snapshot.yaml
5. Run 07-pod-with-volume-from-snapshot.yaml

