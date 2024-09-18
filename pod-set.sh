#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
BRIGHT_PINK='\033[38;5;213m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Run kubectl get pods and store the output
kubectl_output=$(kubectl get pods)

# Extract the header
header=$(echo "$kubectl_output" | head -n 1)

# Print the header with a # prefix in bright orange-pink
echo -e "${BRIGHT_PINK}# ${header}${NC}" >&2

# Process and print the rest of the output with colored line numbers and green "Running" status
# Also, store pod names in an array
pod_names=()
while IFS= read -r line; do
    if [[ "$line" == *"Running"* ]]; then
        echo -e "${RED}$((${#pod_names[@]}+1))${NC} ${line/Running/${GREEN}Running${NC}}" >&2
    else
        echo -e "${RED}$((${#pod_names[@]}+1))${NC} $line" >&2
    fi
    pod_name=$(echo "$line" | awk '{print $1}')
    pod_names+=("$pod_name")
done < <(echo "$kubectl_output" | tail -n +2)

# Get the number of pods
num_pods=${#pod_names[@]}

# Prompt user for input
while true; do
    echo -e "\n${YELLOW}Enter the number of the pod you want to select (1-$num_pods):${NC}" >&2
    read -r selection

    # Validate input
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "$num_pods" ]; then
        selected_pod=${pod_names[$selection-1]}
        echo -e "${GREEN}Selected pod: $selected_pod${NC}" >&2
        echo "export POD='$selected_pod'"
        break
    else
        echo -e "${RED}Invalid input. Please enter a number between 1 and $num_pods.${NC}" >&2
    fi
done
