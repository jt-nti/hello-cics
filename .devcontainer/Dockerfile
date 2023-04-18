# [Choice] Java version (use -bullseye variants on local arm64/Apple Silicon): 11, 17, 11-bullseye, 17-bullseye, 11-buster, 17-buster
ARG VARIANT=11-bullseye
FROM mcr.microsoft.com/devcontainers/java:${VARIANT}

# [Option] Install Maven
ARG INSTALL_MAVEN="false"
ARG MAVEN_VERSION=""
# [Option] Install Gradle
ARG INSTALL_GRADLE="false"
ARG GRADLE_VERSION=""
RUN if [ "${INSTALL_MAVEN}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/sdkman/bin/sdkman-init.sh && sdk install maven \"${MAVEN_VERSION}\""; fi \
    && if [ "${INSTALL_GRADLE}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/sdkman/bin/sdkman-init.sh && sdk install gradle \"${GRADLE_VERSION}\""; fi

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libsecret-1-0 gnome-keyring libpam-gnome-keyring dbus-x11

# [Optional] Uncomment this line to install global node packages.
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g @zowe/cli@zowe-v2-lts && zowe plugins install @zowe/cics-for-zowe-cli@zowe-v2-lts @zowe/zos-ftp-for-zowe-cli@zowe-v2-lts @ibm/rse-api-for-zowe-cli@3.0.1 2>&1" ; fi

# Install CICS Transaction Server resource builder
RUN curl -sfL "https://public.dhe.ibm.com/ibmdl/export/pub/software/htp/zos/updates/cics-resource-builder-1.0.3.zip" 2>/dev/null -o /tmp/cics-resource-builder-1.0.3.zip \
    && cd /opt \
    && jar -xvf /tmp/cics-resource-builder-1.0.3.zip cics-resource-builder \
    && chmod 755 /opt/cics-resource-builder/bin/zrb \
    && rm /tmp/cics-resource-builder-1.0.3.zip

# TODO in theory the user might not be vscode?
COPY cicsdev-bashrc.sh /tmp/
RUN cat /tmp/cicsdev-bashrc.sh >> /home/vscode/.bashrc \
    && rm -f /tmp/cicsdev-bashrc.sh
