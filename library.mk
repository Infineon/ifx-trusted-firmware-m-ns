################################################################################
# \copyright
# Copyright (c) 2023-2025 Cypress Semiconductor Corporation (an Infineon company)
# or an affiliate of Cypress Semiconductor Corporation. All rights reserved.
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

ifndef $(DEVICE_MODE)
# SECURE/NON_SECURE mode is provided by VCORE_ATTRS instead of DEVICE_MODE
DEVICE_MODE=$(VCORE_ATTRS)
endif

################################################################################
# Validate build
################################################################################
ifeq ($(DEVICE_MODE),SECURE)
# This library is for non-secure project only
ifneq ($(filter build_proj,$(MAKECMDGOALS)),)
$(error Please use ifx-trusted-firmware-m library instead of ifx-trusted-firmware-m-ns for secure project)
else
$(warning Please use ifx-trusted-firmware-m library instead of ifx-trusted-firmware-m-ns for secure project)
endif
endif

################################################################################
# Non-secure build
################################################################################
# TF-M non-secure Makefile
include $(abspath $(join $(dir $(lastword $(MAKEFILE_LIST))),/make/tfm_ns.mk))
