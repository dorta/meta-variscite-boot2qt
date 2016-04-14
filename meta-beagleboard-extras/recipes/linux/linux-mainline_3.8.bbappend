##############################################################################
##
## Copyright (C) 2016 The Qt Company Ltd.
## Contact: http://www.qt.io/licensing/
##
## This file is part of the Boot to Qt meta layer.
##
## $QT_BEGIN_LICENSE:COMM$
##
## Commercial License Usage
## Licensees holding valid commercial Qt licenses may use this file in
## accordance with the commercial license agreement provided with the
## Software or, alternatively, in accordance with the terms contained in
## a written agreement between you and The Qt Company. For licensing terms
## and conditions see http://www.qt.io/terms-conditions. For further
## information use the contact form at http://www.qt.io/contact-us.
##
## $QT_END_LICENSE$
##
##############################################################################

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "\
    file://0001-AM335x-Adding-SGX-DT-node.patch \
    file://0002-AM33XX-Invoke-hwmod-deassert-for-SGX-graphics-device.patch \
    file://0003-video-da8xx-fb-Add-API-to-register-wait-for-vsync-ca.patch \
    file://ARM-perf-add-support-for-perf-registers-API.diff \
    file://ARM-perf-wire-up-perf_regs-and-unwind-support-for-AR.patch \
    file://0001-ARM-8158-1-LLVMLinux-use-static-inline-in-ARM-ftrace.patch \
    file://0001-kernel-add-support-for-gcc-5.patch \
    file://0001-Change-extern-inline-to-static-inline.patch \
    "

INSANE_SKIP_${PN} = "installed-vs-shipped"
KERNEL_IMAGETYPE = "zImage"
B = "${S}"

do_configure_prepend() {
    sed -e '/CONFIG_USB_FUNCTIONFS_ETH=/d' \
        -e '/CONFIG_USB_FUNCTIONFS_RNDIS=/d' \
        -i ${WORKDIR}/defconfig
    echo "CONFIG_FHANDLE=y"  >> ${WORKDIR}/defconfig
    echo "CONFIG_MOUSE_PS2=n"  >> ${WORKDIR}/defconfig
}
