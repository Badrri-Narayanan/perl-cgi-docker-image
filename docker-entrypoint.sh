#!/bin/sh
set -e

# envvars defines APACHE_RUN_USER, APACHE_RUN_DIR, APACHE_LOCK_DIR etc.
# It reads optional unset variables, so it must be sourced before `set -u`.
# shellcheck source=/dev/null
. /etc/apache2/envvars
set -u

mkdir -p "$APACHE_RUN_DIR" "$APACHE_LOCK_DIR"
rm -f "$APACHE_PID_FILE"

# exec so apache runs as PID 1 and receives stop signals directly.
exec apache2 -DFOREGROUND "$@"
