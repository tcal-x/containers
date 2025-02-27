# Authors:
#   Unai Martinez-Corral
#   Torsten Meissner
#
# Copyright 2021 Unai Martinez-Corral <unai.martinezcorral@ehu.eus>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

ARG REGISTRY='gcr.io/hdl-containers/debian/buster'

#---

FROM $REGISTRY/build/build AS build

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    binutils \
    autoconf \
    gperf \
    libgmp-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && update-ca-certificates  \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/yices2 && cd /tmp/yices2 \
&& curl -fsSL https://codeload.github.com/SRI-CSL/yices2/tar.gz/master | tar xzf - --strip-components=1 \
&& autoconf \
&& ./configure \
&& make -j$(nproc) \
&& make DESTDIR=/opt/yices2 install

#---

FROM scratch
COPY --from=build /opt/yices2 /yices2
