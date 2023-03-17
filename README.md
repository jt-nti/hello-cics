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

# CICS Program

Attempting to create a very basic CICS program using the `@CICSProgram` annotation!

Created a new gradle project using `gradle init --type basic` (no way to bootstrap a CICS project?)

See:
- https://github.com/IBM/cics-bundle-gradle/tree/main/samples/gradle-war-sample
- https://github.com/cicsdev/cics-java-liberty-link

## Deploying the CICS program (TBC)

Gradle build, ftp CICS bundle to USS, and unzip to a suitable bundle directory using `jar -xvf <bundle>.zip`

For example, using `zowe`

```shell
./gradlew build
zowe ssh issue cmd "rm -Rf ~/cicsBundle && mkdir -p ~/cicsBundle"
zowe zftp upload ftu ./build/distributions/hello-cics-1.0.0.zip "<bundle_dir>/hello-cics-1.0.0.zip" --binary
zowe ssh issue cmd "cd ~/cicsBundle && jar -xvf hello-cics-1.0.0.zip && rm hello-cics-1.0.0.zip"
```

Then some CICS stuff... here be dragons...

Need a JVM server

```
CEDA COPY GROUP(DFH£WLP) JVMSERVER(DFHWLP) TO(WLPGROUP) AS(WLPFTW)
CEDA INSTALL GROUP(WLPGROUP)
CEMT INQUIRE JVMSERVER(WLPFTW)
```

TODO need JVM profile, and `server.xml` (somewhere under the JVM work directory) needs to include the `cicsts:link-1.0` feature, e.g.

```
	<featureManager>
        <feature>cicsts:core-1.0</feature>
        <feature>cicsts:defaultApp-1.0</feature>
        <feature>transportSecurity-1.0</feature>
        <feature>cicsts:link-1.0</feature>
    </featureManager>
```

Create a bundle

```
CEDA DEFINE BUNDLE
```

```
Bundle       ==> HELLOB
Group        ==> BGROUP
...
BUndledir    ==> <bundle_dir>
```

```
CEDA INSTALL GROUP(BGROUP)
CEMT INQUIRE BUNDLE(HELLOB)
```

Note: installing the bundle should cause a program matching the annotation to get created automatically.

```
CEMT INQUIRE PROGRAM(HELLODFH)
```

Define the transaction

```
CEDA DEFINE TRANSACTION
```

```
TRANSaction  ==> HOLA  
Group        ==> TGROUP
DEScription  ==>       
PROGram      ==> HELLODFH 
```

```
CEDA INSTALL GROUP(TGROUP)
CEMT INQUIRE TRANSACTION(HOLA)
```

TODO use the same group for the bundle and transaction definitions, e.g. HELLOGRP?

Run the transaction!!!

```
HOLA
```
