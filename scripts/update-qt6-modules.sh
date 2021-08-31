#!/bin/bash
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

if [ $# -lt 1 ]; then
    echo "Usage: $0 <gitdir> [<layerdir>]"
    echo "Update SRCREVs for all Qt modules in the current layer."
    echo "The <gitdir> is path to the super repo, where modules' SHA1 is taken."
    exit 1
fi

SHA1S=$(git -C $1 submodule status --recursive |  cut -c2- | awk '{print $1$2}')
SHA1S=${SHA1S,,}
LAYERDIR=${2:-$PWD}

for S in $SHA1S; do
    SHA1=${S:0:40}
    PROJECT=${S:40}
    BASEPROJECT=$(echo $PROJECT | cut -d / -f 1)
    RECIPE="${PROJECT}"
    TAG="SRCREV"

    if [ "${PROJECT}" = "qtquick3d" ]; then
        TAG="SRCREV_qtquick3d"
    elif [ "${PROJECT}" = "qtquick3d/src/3rdparty/assimp/src" ]; then
        RECIPE="qtquick3d"
        TAG="SRCREV_assimp"
    elif [ "${PROJECT}" = "qt3d" ]; then
        TAG="SRCREV_qt3d"
    elif [ "${PROJECT}" = "qt3d/src/3rdparty/assimp/src" ]; then
        RECIPE="qt3d"
        TAG="SRCREV_assimp"
    elif [ "${PROJECT}" = "qtwebengine" ]; then
        TAG="SRCREV_qtwebengine"
    elif [ "${PROJECT}" = "qtwebengine/src/3rdparty" ]; then
        RECIPE="qtwebengine"
        TAG="SRCREV_chromium"
    elif [ "${PROJECT}" = "qtlocation" ]; then
        RECIPE="qtpositioning"
    elif [ "${PROJECT}" = "qtlocation/src/3rdparty/mapbox-gl-native" ]; then
        RECIPE="qtlocation"
        TAG="SRCREV_qtlocation-mapboxgl"
    elif [ "${PROJECT}" = "qttools" ]; then
        TAG="SRCREV_qttools"
    elif [ "${PROJECT}" = "qttools/src/assistant/qlitehtml" ]; then
        RECIPE="qttools"
        TAG="SRCREV_qlitehtml"
    elif [ "${PROJECT}" = "qttools/src/assistant/qlitehtml/src/3rdparty/litehtml" ]; then
        RECIPE="qttools"
        TAG="SRCREV_litehtml"
    fi

    RECIPES=$(find ${LAYERDIR} -regextype egrep -regex ".*/(nativesdk-)?${RECIPE}(-native)?(_git)?\..*")

    if sed -n "/\"${BASEPROJECT}\"/,/status/p" $1/.gitmodules | grep -q ignore ; then
        echo "${PROJECT} -> ignored"
    elif [ "${RECIPES}" != "" ]; then
        sed -i -e "/^${TAG}/s/\".*\"/\"${SHA1}\"/" ${RECIPES}
        echo "${PROJECT} -> ${SHA1}"
    else
        echo -e "\e[31m${PROJECT} -> no recipe found\e[0m "
    fi
done

