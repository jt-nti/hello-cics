#!/usr/bin/env sh
#
# SPDX-License-Identifier: Apache-2.0
#
set -e

service dbus start

# See https://github.com/zowe/zowe-sample-dockerfiles
# Check if container has IPC_LOCK capability
if capsh --print | grep -q cap_ipc_lock; then
   su -l -c /usr/local/bin/unlock-keyring.sh vscode
fi

exec "$@"
