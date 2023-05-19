1. Show backup location for each cluster by changing to EACH cluster and run the following command line:
> velero backup-location get

You should see out put like this:
NAME      PROVIDER        BUCKET/PREFIX                                                                                 PHASE       LAST VALIDATED                  ACCESS MODE   DEFAULT
default   velero.io/aws   project-eumgmt-eu-west-2-eks-backup/eks_backup/project-eumgmt-eu-west-2-eks-backup/cluster/   Available   2023-05-19 05:22:29 -0400 EDT   ReadWrite     true


2. Create a test namespace
> kubectl create ns test

3. Change to namespace test, then create a pod, call amzlnx2. Note the pod creation is from bash profile
> amzlnx2   

4. Create backup for each cluster 
> velero backup create {backup_name}

5. Validate backup
> velero backup describe {backup_name}
> velero backup logs {backup_name}

6. Delete pod amzlnx and optionally namespace test
> kubectl delete pod amzlnx2
> kubectl delete ns test

7. Wait for the backup to finish, perform the restore
> velero get backup
> velero restore create {restore_name} --from-backup {backup_name}

8. Alternately, you can restore a namespace or particular resources from backup
> velero restore create {restore_name} --include-namespaces {namespace1},{namespace2} --from-backup {backup_name}


## Schedule Backup
9. For each cluster, perform a backup for every 6 hours
> velero schedule create backup-every-6h-schedule --schedule="0 */6 * * *"
> velero get schedule