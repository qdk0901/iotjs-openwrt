#!/bin/bash

# Copyright 2015 Samsung Electronics Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Choosing table or semicolon-separated output mode
if [ "$1" == "-d" ]
then
  TABLE="no"
  PRINT_TEST_NAME_AWK_SCRIPT='{printf "%s;", $1}'
  PRINT_TOTAL_AWK_SCRIPT='{printf "%d;%d;%d;%d\n", $1, $2, $4, $5 * 1024}'

  shift
else
  PRINT_TEST_NAME_AWK_SCRIPT='{printf "%30s", $1}'
  PRINT_TOTAL_AWK_SCRIPT='{printf "%25d%35d%35d%20d\n", $1, $2, $4, $5 * 1024}'
  TABLE="yes"
fi

function fail_msg
{
  echo "$1"
  exit 1
}

# Engine

# Check if the specified build supports memory statistics options
function is_mem_stats_build
{
  [ -x "$1" ] || fail_msg "Engine '$1' is not executable"

  tmpfile=`mktemp`
  "$1" --mem-stats $tmpfile | grep -- "Ignoring memory statistics option because of '!MEM_STATS' build configuration." 2>&1 > /dev/null
  code=$?
  rm $tmpfile

  return $code
}

JERRY="$1"
shift
is_mem_stats_build "$JERRY" || fail_msg "First engine specified should be built without memory statistics support"

JERRY_MEM_STATS="$1"
shift
is_mem_stats_build "$JERRY_MEM_STATS" && fail_msg "Second engine specified should be built with memory statistics support"

# Benchmarks list
BENCHMARKS=""

while [ $# -ne 0 ]
do
  BENCHMARKS="$BENCHMARKS $1"
  shift
done

# Running
if [ "$TABLE" == "yes" ]
then
  awk 'BEGIN {printf "%30s%25s%35s%35s%20s\n", "Test name", "Heap (byte-code)", "Heap (byte-code + parser)", "Heap (byte-code + execution)", "Maximum RSS"}'
  echo
fi

for bench in $BENCHMARKS
do
  test=`basename -s '.js' $bench`

  echo "$test" | awk "$PRINT_TEST_NAME_AWK_SCRIPT"
  MEM_STATS=$("$JERRY_MEM_STATS" --mem-stats --mem-stats-separate $bench | grep -e "Peak allocated=" -e "Allocated =" | grep -o "[0-9]*")
  RSS=$(./tools/rss-measure.sh "$JERRY" $bench | tail -n 1 | grep -e "Rss" | grep -o "[0-9]*")
  echo $MEM_STATS $RSS | xargs | awk "$PRINT_TOTAL_AWK_SCRIPT"
done
