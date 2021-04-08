#!/usr/bin/env python3

# Authors:
#   Unai Martinez-Corral
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

from typing import List, Optional
import sys
from sys import executable, platform
from os import environ
from subprocess import check_call, STDOUT
from shutil import which


isGHA: bool = "GITHUB_ACTIONS" in environ

isWin: bool = platform == "win32"

shell: List[str] = [which("bash")] if platform == "win32" else []


def _exec(args: List[str], dry: Optional[bool] = False, collapse: Optional[str] = None):
    isGroup = isGHA and collapse is not None

    if isGroup:
        print(f"\n::group::{collapse}")
        sys.stdout.flush()

    print("·", " ".join(args))
    sys.stdout.flush()

    if not dry:
        check_call(args, stderr=STDOUT)

    if isGroup:
        print("\n::endgroup::")
        sys.stdout.flush()


def _sh(args: List[str], dry: Optional[bool] = False):
    _exec(shell + args, dry=dry)


def _py(args: List[str], dry: Optional[bool] = False):
    _exec([executable] + args, dry=dry)
