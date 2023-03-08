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

## Add some JCICSX code

WIP!
