#!/bin/bash
source hadk.env
cd $ANDROID_ROOT

./hybris-patches/apply-patches.sh --mb

source build/envsetup.sh 2>&1
breakfast $DEVICE

echo "clean .repo folder"
rm -rf $ANDROID_ROOT/.repo

make -j$(nproc --all) hybris-hal $(external/droidmedia/detect_build_targets.sh $PORT_ARCH $(gettargetarch)) libbiometry_fp_api_32 fake_crypt hybris/mw/sailfish-fpd-community/rpm/copy-hal.sh
