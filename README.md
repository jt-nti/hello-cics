# hello-cics

Experimental project to try out modern development techniques with CICS

The journey so far...

## Dev Container

Attempting to create a dev container suitable for the [IBM Z Open Editor](https://ibm.github.io/zopeneditor-about/Docs/getting_started.html#installing-the-ibm-z-open-editor-vs-code-extension)

Run the following to unlock the Gnome keyring manually to run Zowe CLI commands.

```shell
export $(dbus-launch)
printf '\n' | gnome-keyring-daemon -r --unlock --components=secrets
```

**TODO:** update the dev container to [unlock the Gnome keyring automatically](https://docs.zowe.org/stable/user-guide/cli-configure-scs-on-headless-linux-os/#unlocking-the-keyring-automatically).

After unlocking the Gnome keyring, create a global Zowe CLI configuration, either using the Zowe Explorer or the following command.

```shell
zowe config init --global-config
```

Edit the config file as required, either using the Zowe Explorer, or using `jq`. For example, to accept self-signed certificates.

```shell
jq --indent 4 '.profiles.base.properties.rejectUnauthorized |= false' /home/vscode/.zowe/zowe.config.json | shuf --output=/home/vscode/.zowe/zowe.config.json --random-source=/dev/zero
```
