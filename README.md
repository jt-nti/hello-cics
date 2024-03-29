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

## Configuring CICS to provide a dev environment (TBC)

Some CICS stuff... here be dragons...

TODO: script somehow- using DFHCSDUP? E.g. [CSDUPDAT.jclsamp](https://github.com/WASdev/sample.wola/blob/7048683bf358797fcbd08cf15ac118987eb12324/CSDUPDAT.jclsamp)

Need a JVM server

```
CEDA COPY GROUP(DFH£WLP) JVMSERVER(DFHWLP) TO(WLPGROUP) AS(WLPFTW)
CEDA INSTALL GROUP(WLPGROUP)
CEMT INQUIRE JVMSERVER(WLPFTW)
```

TODO need JVM profile, and `<work_dir>/WLPFTW/wlp/usr/servers/defaultServer/server.xml` needs to include the `cicsts:link-1.0` feature, e.g.

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
BUndledir    ==> <bundle_deploy_root>/<bundle_id>_<bundle_version>
```

where,
  - `<bundle_deploy_root>` was specified by `-Dcom.ibm.cics.jvmserver.cmci.bundles.dir` in `EYUSMSSJ.jvmprofile`, and
  - `<bundle_id>` is the gradle `rootProject.name`

e.g. `/u/cicsdev/cmciBundles/hello-cics_1.0.0`

```
CEDA INSTALL GROUP(BGROUP)
CEMT INQUIRE BUNDLE(HELLOB)
```

Installing the bundle should cause a program matching the `@CICSProgram` annotation to get created automatically due to the `cicsts:link-1.0` feature, which you can check with

```
CEMT INQUIRE PROGRAM(HELLODFH)
```

TODO: would it be better just to include a program in the bundle to avoid having to add the `cicsts:link-1.0` feature?

The bundle also includes an `LO1` transaction which uses the program, which you can check with

```
CEMT INQUIRE TRANSACTION(LO1)
```

TODO use the same group for the bundle and transaction definitions, e.g. HELLOGRP?

Run the transaction!!!

```
LO1
```

## Deploying the CICS bundle (TBC)

Note: a CICS bundle is **not** the same thing as an OSGi bundle!

Gradle build, ftp CICS bundle to USS, and unzip to a suitable bundle directory using `jar -xvf <bundle>.zip`

For example, using `zowe`

```shell
./gradlew build
zowe ssh issue cmd "rm -Rf ~/cicsBundle && mkdir -p ~/cicsBundle"
zowe zftp upload ftu ./build/distributions/hello-cics-1.0.0.zip "<bundle_dir>/hello-cics-1.0.0.zip" --binary
zowe ssh issue cmd "cd ~/cicsBundle && jar -xvf hello-cics-1.0.0.zip && rm hello-cics-1.0.0.zip"
```

Alternatively, use `./gradlew deployCICSBundle`

This requires CMCI to be working and the 'managedcicsbundles' endpoint to be enabled with the `-Dcom.ibm.cics.jvmserver.cmci.bundles.dir` parameter. See [Configuring the CMCI JVM server for the CICS bundle deployment API](https://www.ibm.com/docs/en/cics-ts/6.1?topic=suc-configuring-cmci-jvm-server-cics-bundle-deployment-api)

Scripting with Zowe seems quite nice since credentials are stored securely, and the bundle deployement API still requires the bundle to have been defined up front anyway. The bundle deployment API does "just work" when it works though.

## Using resource builder and DFHCSDUP to configure CICS

Generate the resource definitions schema

```shell
zrb generate -m src/main/resources/sample.cicsresourcemodel.yaml -o src/main/resources/sample.cicsresourcedefinitions.schema.json
```

Build the DFHCSDUP commands file

```shell
zrb build --model src/main/resources/sample.cicsresourcemodel.yaml --resources src/main/resources/sample.cicsresourcedefinitions.yaml --output src/main/resources/DFHCSD.txt
```

TODO:
- there's probably a better place to generate the schema and DFHCSD.txt files
- use yq to fix the bundledir

The resulting commands file can be used when invoking DFHCSDUP as a batch program. See:
https://www.ibm.com/docs/en/cics-ts/6.1?topic=dfhcsdup-sample-job-invoking-as-batch-program

First upload the DFHCSDUP commands file to a suitable data set.
For example, to create a new partitioned data set and upload the `DFHCSD.txt` file using Zowe...

```shell
zowe zos-files create data-set-partitioned NEW.DFHCSD.DATASET
zowe zos-files upload file-to-data-set "DFHCSD.txt" "NEW.DFHCSD.DATASET(SAMPLE)"
```

Then refer to your data set in the DFHCSDUP JCL, e.g.

```
//CSDUP   JOB  ...
//CSDUP   EXEC PGM=DFHCSDUP,REGION=0M,
//             PARM='CSD(READWRITE),PAGESIZE(60),NOCOMPAT'
//STEPLIB  DD DISP=SHR,DSN=xxx.SDFHLOAD
//DFHCSD   DD DISP=SHR,DSN=xxx.DFHCSD
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DISP=SHR,DSN=NEW.DFHCSD.DATASET(SAMPLE)
```

## Using CMCI and a REST client to configure CICS!

The [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) for VS Code works quite well (see the [cmci.http file](./cmci.http) for example), or just use cURL...

```shell
curl --request POST \
  --url http://cmci.example.org:1490/CICSSystemManagement/CICSDefinitionBundle/<cics_region> \
  --header 'authorization: Basic <encoded_username_password>' \
  --header 'content-type: application/xml' \
  --data '<request><create><parameter name="CSD"/><attributes name="HELLO" bundledir="/u/ibmuser/cmciBundles/hello-cics_1.0.0" csdgroup="SAMPLE"/></create></request>'
```
