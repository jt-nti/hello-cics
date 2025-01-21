#!/usr/bin/env sh
#
# SPDX-License-Identifier: Apache-2.0
#
set -eu

#
# Install zowe cli
#
npm install -g @zowe/cli@zowe-v2-lts

zowe plugins install @zowe/cics-for-zowe-cli@zowe-v2-lts @zowe/zos-ftp-for-zowe-cli@zowe-v2-lts @ibm/rse-api-for-zowe-cli@3.0.1

#
# TODO: Install CICS Transaction Server resource builder
#
# RUN curl -sfL "https://public.dhe.ibm.com/ibmdl/export/pub/software/htp/zos/updates/cics-resource-builder-1.0.3.zip" 2>/dev/null -o /tmp/cics-resource-builder-1.0.3.zip \
#     && cd /opt \
#     && jar -xvf /tmp/cics-resource-builder-1.0.3.zip cics-resource-builder \
#     && chmod 755 /opt/cics-resource-builder/bin/zrb \
#     && rm /tmp/cics-resource-builder-1.0.3.zip
