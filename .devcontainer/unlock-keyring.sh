#!/usr/bin/env sh
#
# SPDX-License-Identifier: Apache-2.0
#
set -eu

export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --fork --print-address)

eval $(cat /var/lib/dbus/machine-id | gnome-keyring-daemon -r -d --components=secrets --unlock)

echo "export DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" > ~/keyringenv.sh
echo "export GNOME_KEYRING_CONTROL=$GNOME_KEYRING_CONTROL" >> ~/keyringenv.sh

exec "$@"
