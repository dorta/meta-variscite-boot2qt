SUMMARY = "GammaRay Qt introspection probe"
HOMEPAGE = "http://www.kdab.com/gammaray"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE.GPL.txt;md5=a5b28ec9718d4516f7a621cd0232afc1"

inherit cmake_qt5

SRC_URI = "git://github.com/KDAB/GammaRay;branch=${BRANCH};protocol=https"

BRANCH = "5.9"
SRCREV = "87656b9c344077d84682b53ba3e4676e18b57f9e"
PV = "${BRANCH}+git${SRCPV}"

DEPENDS = "qtdeclarative qtlocation qtsvg qttools qtconnectivity qt3d qtivi qtscxml qtscxml-native \
           ${@bb.utils.contains("DISTRO_FEATURES", "wayland", "qtwayland", "", d)}"

S = "${WORKDIR}/git"

EXTRA_OECMAKE += " -DGAMMARAY_BUILD_UI=OFF -DGAMMARAY_CORE_ONLY_LAUNCHER=ON"

FILES_${PN}-dev += " \
    /usr/lib/cmake/* \
    /usr/mkspecs/modules/* \
"
FILES_${PN}-dbg += " \
    /usr/lib/.debug/* \
    /usr/lib/gammaray/*/*/.debug \
    /usr/lib/gammaray/*/*/styles/.debug \
"
