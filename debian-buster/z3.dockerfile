# Authors:
#   Unai Martinez-Corral
#   Torsten Meissner
#   Michael Munch
#
# Copyright 2019-2021 Unai Martinez-Corral <unai.martinezcorral@ehu.eus>
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
    python3-distutils \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && update-ca-certificates  \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/z3 && cd /tmp/z3 \
 && curl -fsSL https://codeload.github.com/Z3Prover/z3/tar.gz/master | tar xzf - --strip-components=1 \
 && python3 scripts/mk_make.py \
 && cd build \
 && make PREFIX=/usr/local \
 && make DESTDIR=/opt/z3 PREFIX=/usr/local install

#---

FROM scratch
COPY --from=build /opt/z3 /z3
