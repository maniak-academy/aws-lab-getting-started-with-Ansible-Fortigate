#!/bin/bash
# Navigate to the Terraform directory and run the commands in the background
(
cd terraform
terraform destroy -auto-approve
) &

pid=$!  # Get the process ID of the background process

# Wait for the background process to complete
while kill -0 "$pid" 2> /dev/null; do
  echo "Terraform commands are still executing..."
  sleep 1  # Wait for 1 second before checking again
done

echo "Destroy, thank you ."
