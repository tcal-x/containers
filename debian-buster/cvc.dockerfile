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

RUN mkdir /usr/share/man/man1 \
 && apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    cmake \
    libgmp-dev \
    m4 \
    patch \
    python3-toml \
    openjdk-11-jre-headless \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && update-ca-certificates  \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/cvc5 && cd /tmp/cvc5 \
 && curl -fsSL https://codeload.github.com/cvc5/cvc5/tar.gz/master | tar xzf - --strip-components=1 \
 && ./configure.sh --auto-download \
 && cd build \
 && make -j$(nproc) \
 && make DESTDIR=/opt/cvc install

#---

FROM scratch
COPY --from=build /opt/cvc /cvc
