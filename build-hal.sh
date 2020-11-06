#!/bin/bash
source hadk.env
cd $ANDROID_ROOT
source build/envsetup.sh 2>&1
breakfast $DEVICE

echo "clean .repo folder"
rm -rf $ANDROID_ROOT/.repo

make -j$(nproc --all) hybris-hal $(external/droidmedia/detect_build_targets.sh $PORT_ARCH $(gettargetarch))