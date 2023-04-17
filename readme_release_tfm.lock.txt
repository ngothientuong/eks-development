To release terraform lock, perform the following step:
- terraform force-unlock -force <type in some randome string for LOCK_ID>
- terraform will then provide error with output of that actual LOCK_ID being used
- Rerun the command with the lock_id from output
