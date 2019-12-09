#!/bin/bash
source hadk.env
cd $ANDROID_ROOT
source build/envsetup.sh 2>&1
breakfast $DEVICE
make -j$(nproc) hybris-hal V=s
make -j$(nproc) droidmedia audioflingerglue V=s