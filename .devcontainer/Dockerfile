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
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g @zowe/cli@zowe-v2-lts && zowe plugins install @zowe/cics-for-zowe-cli@zowe-v2-lts 2>&1" ; fi

# TODO 
# https://docs.zowe.org/stable/user-guide/cli-configure-scs-on-headless-linux-os

# TBC interactive commands to unlock the Gnome keyring?
# export $(dbus-launch)
# printf '\n' | gnome-keyring-daemon -r --unlock --components=secrets

# Fails with...
# bash: /usr/bin/gnome-keyring-daemon: Operation not permitted

# TBC automatically unlock the Gnome keyring at log on?

# Is this required/correct?
# RUN echo "auth optional pam_gnome_keyring.so" >> /etc/pam.d/login \
#     && echo "session optional pam_gnome_keyring.so auto_start" >> /etc/pam.d/sshd

# Update ~/.bashrc?
# if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
#   exec dbus-run-session -- $SHELL
# fi
