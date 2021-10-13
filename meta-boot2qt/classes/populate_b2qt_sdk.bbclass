############################################################################
##
## Copyright (C) 2020 The Qt Company Ltd.
## Contact: https://www.qt.io/licensing/
##
## This file is part of the Boot to Qt meta layer.
##
## $QT_BEGIN_LICENSE:GPL$
## Commercial License Usage
## Licensees holding valid commercial Qt licenses may use this file in
## accordance with the commercial license agreement provided with the
## Software or, alternatively, in accordance with the terms contained in
## a written agreement between you and The Qt Company. For licensing terms
## and conditions see https://www.qt.io/terms-conditions. For further
## information use the contact form at https://www.qt.io/contact-us.
##
## GNU General Public License Usage
## Alternatively, this file may be used under the terms of the GNU
## General Public License version 3 or (at your option) any later version
## approved by the KDE Free Qt Foundation. The licenses are as published by
## the Free Software Foundation and appearing in the file LICENSE.GPL3
## included in the packaging of this file. Please review the following
## information to ensure the GNU General Public License requirements will
## be met: https://www.gnu.org/licenses/gpl-3.0.html.
##
## $QT_END_LICENSE$
##
############################################################################

inherit populate_sdk

quiet_sdk_extraction() {
EXTRA_TAR_OPTIONS="$EXTRA_TAR_OPTIONS --checkpoint=9999999"
}
SDK_PRE_INSTALL_COMMAND = "${quiet_sdk_extraction}"

replace_sysroot_symlink() {
        SYSROOT=$1
        find ${SYSROOT} -type l | while read SOURCE
        do
                TARGET=`readlink -m "${SOURCE}"`
                #check whether TARGET is inside the sysroot when not prepend the sysroot
                TARGET=`echo ${TARGET} | grep "^${SYSROOT}" || echo ${SYSROOT}${TARGET}`
                rm "${SOURCE}"
                if [ -f "${TARGET}" ]; then
                        cp "${TARGET}" "${SOURCE}"
                elif [ -e "${TARGET}" ]; then
                        touch "${SOURCE}"
                fi
        done
}

do_populate_sdk[depends] += "p7zip-native:do_populate_sysroot"

fakeroot archive_sdk:sdkmingw32() {
        replace_sysroot_symlink ${SDK_OUTPUT}${SDKTARGETSYSROOT}
        replace_sysroot_symlink ${SDK_OUTPUT}${SDKPATHNATIVE}
        # Package it up
        cd ${SDK_OUTPUT}/${SDKPATH}
        7za a ${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.7z *
}
