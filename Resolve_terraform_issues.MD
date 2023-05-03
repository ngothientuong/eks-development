# Terraform Issues

***Issue: Error acquiring the state lock***
  - **Resolve**:  
    - To release terraform lock, perform the following step:
      - terraform force-unlock -force {type in some randome string for LOCK_ID}
      - terraform will then provide error with output of that actual LOCK_ID being used
      - Rerun the command with the lock_id from output

***Issue***:
  ```
    Error refreshing state: state data in S3 does not have the expected content.

    This may be caused by unusually long delays in S3 processing a previous state
    update.  Please wait for a minute or two and try again. If this problem
    persists, and neither S3 nor DynamoDB are experiencing an outage, you may need
    to manually verify the remote state and update the Digest value stored in the
    DynamoDB table to the following value: cc88bb023db0b293c342195574f59e9e
  ```
  - **Resolve**:
    - Go to AWS Console -> DynamoDB -> Tables -> Explore items -> Click on the correct tabls -> Find the LockID associating with the S3 bucket -> Check box on it -> Action -> Delete
    - Rerun terraform init, plan again to generate new entry in dynamoDB