# hello-cics

Experimental project to try out modern development techniques with CICS

The journey so far...

## Dev Container

Attempting to create a dev container suitable for the [IBM Z Open Editor](https://ibm.github.io/zopeneditor-about/Docs/getting_started.html#installing-the-ibm-z-open-editor-vs-code-extension)

Create a global [Zowe CLI team configuration](https://docs.zowe.org/stable/user-guide/cli-using-initializing-team-configuration), either using the Zowe Explorer or with the following `zowe` command.

```shell
zowe config init --global-config
```

Edit the config file as required, either using the Zowe Explorer, or with the `zowe` CLI. For example, to accept self-signed certificates.

```shell
zowe config set "profiles.base.properties.rejectUnauthorized" "false" --global-config
```
