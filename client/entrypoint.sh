#!/bin/bash
SOCK_GID=$(stat -c '%g' /var/run/docker.sock)
sudo groupadd -g $SOCK_GID docker || true
sudo usermod -aG docker hyk
exec "$@"
