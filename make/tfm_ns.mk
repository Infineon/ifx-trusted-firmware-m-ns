################################################################################
# \file tfm_ns.mk
# \version 1.0
#
# \brief
# Trusted Firmware-M (TF-M) non-secure image make file
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

# Makefile with common macros
include $(join $(dir $(lastword $(MAKEFILE_LIST))),common.mk)


################################################################################
# Extract data from TF-M secure build
################################################################################

# Extract targets which triggers build
IS_BUILD_TARGET=$(findstring all,$(MAKECMDGOALS))$(findstring build_proj,$(MAKECMDGOALS))

# Validate presence of $(TFM_INSTALL_PATH) - path to non-secure interface installed by TF-M secure build
ifneq ($(IS_BUILD_TARGET),)
ifeq ($(wildcard $(TFM_INSTALL_PATH)),)
$(error "\"$(TFM_INSTALL_PATH)\" is not found, please validate path and/or build TF-M secure application")
endif
endif


################################################################################
# TF-M non-secure interface
################################################################################

# Compile TF-M non-secure interface
SOURCES+=$(filter-out $(TFM_IGNORE_SOURCES),$(TFM_SOURCES))
DEFINES+=MBEDTLS_PSA_CRYPTO_CONFIG_FILE=\"tfm_psa_crypto_config_client.h\"
DEFINES+=MBEDTLS_CONFIG_FILE=\"tfm_mbedcrypto_config_client.h\"
