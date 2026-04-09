#!/bin/bash

STRAPI_DIR="$(dirname "$0")/server"
FRONTEND_DIR="$(dirname "$0")/frontend"

STRAPI_URL="http://localhost:1337"
FRONTEND_URL="http://localhost:3000"

echo "Starting Strapi..."
cd "$STRAPI_DIR" && npm run develop &
STRAPI_PID=$!

echo "Starting Next.js..."
cd "$FRONTEND_DIR" && npm run dev &
FRONTEND_PID=$!

wait_for_url() {
  local url=$1
  local name=$2
  echo "Waiting for $name to be ready..."
  until curl -s "$url" > /dev/null 2>&1; do
    sleep 2
  done
  echo "$name is ready!"
}

wait_for_url "$STRAPI_URL" "Strapi"
open "$STRAPI_URL/admin"

wait_for_url "$FRONTEND_URL" "Next.js"
open "$FRONTEND_URL"

echo ""
echo "Both services are running."
echo "  Strapi:  $STRAPI_URL"
echo "  Next.js: $FRONTEND_URL"
echo ""
echo "Press Ctrl+C to stop both."

trap "kill $STRAPI_PID $FRONTEND_PID 2>/dev/null; exit" INT TERM

wait
