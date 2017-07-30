#!/bin/bash
# wait-for-postgres.sh
# TODO: Turn this into something useful we can use with other services we need to bring up

set -e

host="$1"
shift
cmd="$@"

until psql -h "$host" -U "postgres" -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec $cmd
