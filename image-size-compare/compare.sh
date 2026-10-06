#!/usr/bin/env bash
# Builds the three Orders images (multistage, distroless, Jib) and prints a size and startup table.
# Run from this folder; needs Docker and Maven. Expects sibling folders.
set -euo pipefail
cd "$(dirname "$0")/.."

build() { docker build -q -t "$1" "$2" >/dev/null; }
build orders-multistage multistage-dockerfile
build orders-distroless distroless
(cd jib && mvn -q -B package jib:dockerBuild >/dev/null)

printf '%-20s %-10s %s\n' IMAGE SIZE_MB STARTUP_MS
for img in orders-multistage orders-distroless orders-jib:1.0.0; do
  size=$(docker image inspect "$img" --format '{{.Size}}')
  start=$(date +%s%N)
  cid=$(docker run -d -p 18080:8080 "$img")
  until curl -sf localhost:18080/orders >/dev/null; do sleep 0.05; done
  end=$(date +%s%N)
  docker rm -f "$cid" >/dev/null
  printf '%-20s %-10s %s\n' "$img" "$((size / 1000000))" "$(((end - start) / 1000000))"
done
