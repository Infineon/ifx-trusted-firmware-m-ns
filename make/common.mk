################################################################################
# \file common.mk
# \version 1.0
#
# \brief
# Trusted Firmware-M (TF-M) helper make file
#
################################################################################
# \copyright
# Copyright (c) 2022-2024 Cypress Semiconductor Corporation (an Infineon company)
# or an affiliate of Cypress Semiconductor Corporation. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
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
################################################################################

ifeq ($(WHICHFILE),true)
$(info Processing $(lastword $(MAKEFILE_LIST)))
endif

################################################################################
# Help macros
################################################################################

TFM_OS=$(shell uname)

ifneq (,$(findstring CYGWIN,$(TFM_OS)))
# Converts path to shell (Cygwin) path prefixed with /cygdrive/
TFM_PATH_SHELL=$(shell cygpath -u "$1")
# Converts path to cmake (Cygwin mixed) path prefixed with C:/abc/file.txt
TFM_PATH_MIXED=$(shell cygpath -m "$1")
# Use python executable on Windows/Cygwin
TFM_PYTHON_EXECUTABLE_NAME=python
else
# Keep path as is for other platforms (OS X, Linux)
TFM_PATH_SHELL=$1
TFM_PATH_MIXED=$1
# Use python3 executable on OS X/Linux
TFM_PYTHON_EXECUTABLE_NAME=python3
endif

# Wraps space in target
space:=$(subst ,, )
TFM_WRAP_SPACE=$(subst $(space),\ ,$1)
TFM_UNWRAP_SPACE=$(subst \ ,$(space),$1)
# Wrape double quote
double_quote:=$(subst ,,")
TFM_WRAP_DOUBLE_QUOTE=$(subst $(double_quote),\",$1)

################################################################################
# Python
################################################################################

ifeq ($(TFM_PYTHON_PATH),)
ifneq ($(CY_PYTHON_PATH),)
TFM_PYTHON_PATH=$(CY_PYTHON_PATH)
else
TFM_PYTHON_PATH=$(shell which $(TFM_PYTHON_EXECUTABLE_NAME) 2>/dev/null)
endif
ifeq ($(TFM_PYTHON_PATH),)
TFM_PYTHON_PATH=$(TFM_PYTHON_EXECUTABLE_NAME)
endif
endif

################################################################################
# Configuration
################################################################################

# Directory with current makefile
TFM_MAKE_SRC_DIR:=$(realpath $(join $(dir $(lastword $(MAKEFILE_LIST))),..))

# Temporary directory
TFM_TMP_DIR?=$(call TFM_PATH_MIXED,$(TFM_MAKE_SRC_DIR)/.tmp)
TFM_STAGES_DIR:=$(call TFM_PATH_MIXED,$(TFM_TMP_DIR)/stages)

# Location of TF-M sources
ifneq ($(TFM_GIT_URL),)
# Download TF-M sources from git repository
TFM_GIT_REF?=master
TFM_SRC_DIR?=$(call TFM_PATH_MIXED,$(abspath $(TFM_TMP_DIR)/src))
TFM_DOWNLOAD_SRC=true
else ifneq ($(wildcard $(TFM_SRC_DIR)),)
# Use existing TF-M sources
TFM_SRC_DIR:=$(call TFM_PATH_MIXED,$(wildcard $(abspath $(TFM_SRC_DIR))))
TFM_DOWNLOAD_SRC=false
else
# Use ifx-trusted-firmware-m library
TFM_SRC_DIR:=$(call TFM_PATH_MIXED,$(wildcard $(abspath $(TFM_MAKE_SRC_DIR)/src)))
TFM_DOWNLOAD_SRC=false
endif

# Location where non-secure interface is installed - application folder by default
TFM_INSTALL_PATH?=../install
# Location where hex images are installed
TFM_BUILD_PROJECT_HEX_DIR=$(call TFM_PATH_MIXED,$(abspath ../build/project_hex))

TFM_CONFIGURE_OPTIONS?= -Wno-dev

# MTB build
TFM_CONFIGURE_OPTIONS+= -DIFX_MTB_BUILD:BOOL=ON

# Part number provided by BSP
TFM_CONFIGURE_OPTIONS+= -DIFX_PDL_PART_NUMBER:STRING=$(DEVICE)

# Set core
TFM_CONFIGURE_OPTIONS+= -DIFX_CORE:STRING=$(TFM_CORE)

# Use BSP provided by project
TFM_CONFIGURE_OPTIONS+= -DIFX_BSP_LIB_PATH:PATH=$(call TFM_PATH_MIXED,$(realpath $(MTB_TOOLS__TARGET_DIR)))
TFM_CONFIGURE_OPTIONS+= -DIFX_BOARD_NAME:STRING=TARGET_$(subst -,_,$(TARGET))
# Use GeneratedSource generated by MTB
TFM_CONFIGURE_OPTIONS+= -DIFX_BSP_GENERATED_FILES_OUTPUT_PATH:PATH=$(call TFM_PATH_MIXED,$(realpath $(MTB_TOOLS__TARGET_DIR)))/config/GeneratedSource

# Device family from BSP
TFM_DEVICE_FAMILY=$(DEVICE_$(DEVICE)_DIE)
# List of device features (EPC2, ...) from BSP
TFM_DEVICE_FEATURES=$(DEVICE_$(DEVICE)_FEATURES)

TFM_DEVICE_FAMILY:=$(subst EXPLORER_A0,PSE84,$(TFM_DEVICE_FAMILY))
TFM_DEVICE_FAMILY:=$(subst EXPLORER,PSE84,$(TFM_DEVICE_FAMILY))
TFM_DEVICE_FAMILY:=$(subst BOY2,PSC3,$(TFM_DEVICE_FAMILY))
TFM_DEVICE_FEATURES:=$(subst L2,EPC2,$(TFM_DEVICE_FEATURES))
TFM_DEVICE_FEATURES:=$(subst L4,EPC4,$(TFM_DEVICE_FEATURES))

ifeq ($(DEVICE_MODE),SECURE)
TFM_DEVICE_CONFIG_DIR?=$(TFM_SRC_DIR)/platform/ext/target/infineon/common/mtb/config/
else
TFM_DEVICE_CONFIG_DIR?=$(TFM_INSTALL_PATH)/config/
endif
# Path to device family specific options for TF-M
TFM_DEVICE_CONFIG_MK=$(realpath $(join $(TFM_DEVICE_CONFIG_DIR),$(TFM_DEVICE_FAMILY).mk))
# Path to device features specific options for TF-M
TFM_DEVICE_CONFIG_MK+=$(foreach _FEATURE,$(TFM_DEVICE_FEATURES), $(realpath $(join $(TFM_DEVICE_CONFIG_DIR),$(TFM_DEVICE_FAMILY)-$(_FEATURE).mk)))

# Platform specific configuration
include $(TFM_DEVICE_CONFIG_MK)
