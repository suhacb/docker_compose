#!/bin/bash
set -euo pipefail

# List of subdirectories in startup order
SERVICES=(
  "keycloak"
  "auth_backend"
  "nutrients_backend"
  "auth_frontend"
  "nutrients_frontend"
)

# Check argument
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 [up|down]"
  exit 1
fi

ACTION="$1"

# Validate action
if [[ "$ACTION" != "up" && "$ACTION" != "down" ]]; then
  echo "❌ Invalid argument: $ACTION"
  echo "Usage: $0 [up|down]"
  exit 1
fi

# Determine loop order
if [[ "$ACTION" == "up" ]]; then
  ORDER=("${SERVICES[@]}")
else
  # Reverse manually for down
  ORDER=()
  for (( idx=${#SERVICES[@]}-1 ; idx>=0 ; idx-- )); do
    ORDER+=("${SERVICES[idx]}")
  done
fi

# Run docker compose command for each service
for SERVICE in "${ORDER[@]}"; do
  echo "➡️  Processing $SERVICE ($ACTION)..."
  (
    cd "$SERVICE"
    if [[ "$ACTION" == "up" ]]; then
      docker compose up -d
    else
      docker compose down
    fi
  )
  echo "✅ $SERVICE: docker compose $ACTION complete."
  echo
done

echo "🏁 All services processed successfully."
