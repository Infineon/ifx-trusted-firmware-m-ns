# Infineon Customized Trusted Firmware-M for Non-Secure project

## Overview
Trusted Firmware-M (TF-M) implements the Secure Processing Environment (SPE)
for Arm Cortex-M based platforms. This aligns the reference implementation of the platform security architecture
with the PSA Certified guidelines. Thus, TF-M allows relevant chips and devices to become PSA Certified.

This library contains Trusted Firmware-M (TF-M) for non-secure projects. Use the ifx-trusted-firmware-m
library to build a TF-M secure project.

## Licensing
This software component is licensed under a mixture of the Apache License,
version 2 and the 3-Clause BSD License. See separate files to
determine which license applies. Note the licensing of the
following modules:
* [t_cose](https://github.com/Infineon/trusted-firmware-m/blob/master/src/lib/ext/t_cose/LICENSE)
* [qcbor](https://github.com/Infineon/trusted-firmware-m/blob/master/src/ext/qcbor/README.md)

## Usage of TF-M in the ModusToolbox™ tools package
### Usage of TF-M in non-secure applications
To use the TF-M secure image functionality in non-secure applications:
1. Set up and build a TF-M secure application. See the ifx-trusted-firmware-m library README.md for more
   details.
2. Add the ifx-trusted-firmware-m-ns library to your non-secure project.
3. The code used to bind a non-secure project with TF-M is generated during the TF-M secure
   project build into folder `TFM_INSTALL_PATH`.

### Further instructions
For more info and configuration options,
see README.md provided by the ifx-trusted-firmware-m library.

For the general TF-M documentation, refer to
[TF-M user guide](https://tf-m-user-guide.trustedfirmware.org/index.html).

## More information
Use the following links for more information:
* [Cypress Semiconductor Corporation (an Infineon company)](https://www.infineon.com)
* [Cypress Semiconductor Corporation (an Infineon company) GitHub](https://github.com/Infineon)
* [Trusted Firmware website](https://www.trustedfirmware.org)
* [TF-M project](https://www.trustedfirmware.org/projects/tf-m)
* [PSA API](https://github.com/ARM-software/psa-arch-tests/tree/master/api-specs)
* [ModusToolbox™ Software Environment, Quick Start Guide, Documentation, and Videos](https://www.infineon.com/cms/en/design-support/tools/sdk/modustoolbox-software)

---
© 2023-2025, Cypress Semiconductor Corporation (an Infineon company) or an affiliate of Cypress Semiconductor Corporation.
