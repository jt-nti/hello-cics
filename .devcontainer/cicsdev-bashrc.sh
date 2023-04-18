export PATH=$PATH:/opt/cics-resource-builder/bin

# Unlock the Gnome keyring automatically. See:
# https://docs.zowe.org/stable/user-guide/cli-configure-scs-on-headless-linux-os/#unlocking-the-keyring-automatically
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
  exec dbus-run-session -- $SHELL
fi

printf '\n' | gnome-keyring-daemon -r --unlock --components=secrets
