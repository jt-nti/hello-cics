FROM mcr.microsoft.com/devcontainers/base:1-jammy

# Install additional OS packages required for zowe
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libsecret-1-0 gnome-keyring dbus-x11 tini

COPY cicsdev-bashrc.sh /tmp/
RUN cat /tmp/cicsdev-bashrc.sh >> /home/vscode/.bashrc \
    && rm -f /tmp/cicsdev-bashrc.sh

COPY unlock-keyring.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/docker-entrypoint.sh"]
CMD [ "sleep", "infinity" ]
