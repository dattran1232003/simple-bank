#!/bin/sh

set -e

echo "run migration"
source /app/app.env # apply environment variables
/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"