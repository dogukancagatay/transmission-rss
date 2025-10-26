#!/bin/sh
set -e

# Get current ruby user UID and GID
CURRENT_UID=$(id -u ruby)
CURRENT_GID=$(id -g ruby)

# Only modify user/group if the desired UID/GID differs from current
if [ "$CURRENT_UID" != "$PUID" ] || [ "$CURRENT_GID" != "$PGID" ]; then
  echo "Updating ruby user to UID:GID = $PUID:$PGID"

  # Modify group ID if needed
  if [ "$CURRENT_GID" != "$PGID" ]; then
    delgroup ruby 2>/dev/null || true
    addgroup -g "$PGID" ruby
  fi

  # Modify user ID if needed
  if [ "$CURRENT_UID" != "$PUID" ]; then
    deluser ruby 2>/dev/null || true
    adduser -u "$PUID" -G ruby -D -s /bin/sh ruby
  fi
else
  echo "Ruby user already has UID:GID = $PUID:$PGID"
fi

# Execute the main command as the ruby user
exec su-exec ruby "$@"
