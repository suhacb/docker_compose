#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

KEYCLOAK_URL="${KEYCLOAK_URL:-http://localhost:7080}"
KEYCLOAK_REALM="${KEYCLOAK_REALM:-ens3}"
SEED_TIMEOUT="${SEED_TIMEOUT:-120}"

echo "Checking Keycloak is reachable at ${KEYCLOAK_URL}/realms/${KEYCLOAK_REALM} ..."
if ! curl -sf "${KEYCLOAK_URL}/realms/${KEYCLOAK_REALM}" -o /dev/null; then
  echo ""
  echo "ERROR: Keycloak is not reachable."
  echo "  Start Keycloak, then run this script again."
  echo "  Expected URL: ${KEYCLOAK_URL}/realms/${KEYCLOAK_REALM}"
  exit 1
fi
echo "Keycloak OK."

echo "Stopping containers and wiping volumes..."
docker compose down -v

echo "Starting services..."
docker compose up -d --build

echo "Waiting for demo data to seed (timeout ${SEED_TIMEOUT}s)..."
deadline=$((SECONDS + SEED_TIMEOUT))
while true; do
  logs=$(docker compose logs server 2>/dev/null)

  if echo "$logs" | grep -q "Demo data seeded successfully"; then
    echo ""
    echo "Demo data ready."
    break
  fi

  if echo "$logs" | grep -q "Demo data seeding failed"; then
    echo ""
    echo "ERROR: Demo data seeding failed."
    echo "Check server logs:"
    echo "  docker compose logs server"
    exit 1
  fi

  if [ "$SECONDS" -ge "$deadline" ]; then
    echo ""
    echo "TIMEOUT: Demo data not seeded after ${SEED_TIMEOUT}s."
    echo "Last server log lines:"
    docker compose logs server 2>/dev/null | tail -20
    echo ""
    echo "Check full logs:"
    echo "  docker compose logs server"
    exit 1
  fi

  printf "."
  sleep 3
done

echo ""
echo "Ready."
echo "  App:    http://localhost:40000  (log in via Keycloak)"
echo "  Admin:  http://localhost:40001  (log in via Keycloak)"
echo "  Emails: http://localhost:8025"
echo ""
echo "Demo users (credentials as configured in Keycloak):"
echo "  blaz.suhac   (SEKRETAR)"
echo "  ana.novak    (PREDSEDNIK)"
echo "  peter.kovac  (CLAN)"
echo "  maja.horvat  (CLAN)"
