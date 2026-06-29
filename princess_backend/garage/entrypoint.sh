#!/bin/sh
set -e
envsubst < /etc/garage.toml.template > /etc/garage.toml
exec /garage server
