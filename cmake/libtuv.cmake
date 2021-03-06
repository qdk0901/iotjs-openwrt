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

cmake_minimum_required(VERSION 2.8)

set(LIBTUV_ROOT ${DEP_ROOT}/libtuv)

if(${TARGET_OS} STREQUAL "openwrt")
	set(LIBTUV_INCDIR ${LIBTUV_ROOT}/include
                  ${LIBTUV_ROOT}/source
                  ${LIBTUV_ROOT}/source/linux)
else()
	set(LIBTUV_INCDIR ${LIBTUV_ROOT}/include
                  ${LIBTUV_ROOT}/source
                  ${LIBTUV_ROOT}/source/${TARGET_OS})
endif()

set(LIBTUV_LIB ${LIB_ROOT}/libtuv.a)


add_custom_command(OUTPUT ${LIBTUV_LIB}
                   COMMAND touch ${LIBTUV_LIB})

add_custom_target(targetLibtuv DEPENDS ${LIBTUV_LIB})
