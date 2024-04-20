#!/bin/bash
# Auther: Omda
# Description: Script that scale down the kubernets cluster if the number of restart pod exceeded the allow.
# Date Modify: 20-04-2024
# Date Issue: 20-04-2024

namespace="sre"
deployment_name="swype-app"
maximum_number_of_restart_allowed=2

while true
do
    restart_count=$(kubectl get pods -n $namespace -l app=$deployment_name -o=jsonpath='{.items[*].status.containerStatuses[*].restartCount}' | tr ' ' '\n' | awk '{s+=$1} END {print s}')
    
    echo "Current Number of Restart: $restart_count"

    if [ $restart_count -gt $maximum_number_of_restart_allowed ]; then

        kubectl scale deployment $deployment_name --replicas=0  -n $namespace 

        break
    fi

        sleep 60

done

