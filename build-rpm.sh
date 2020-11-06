#!/bin/bash

set -x

source /home/nemo/work/ci/ci/hadk.env
export ANDROID_ROOT=/home/nemo/work/hadk_14.1

sudo chown -R nemo:nemo $ANDROID_ROOT
cd $ANDROID_ROOT

cd ~/.scratchbox2
cp -R SailfishOS-*-armv7hl $VENDOR-$DEVICE-$PORT_ARCH
cd $VENDOR-$DEVICE-$PORT_ARCH
sed -i 's/SailfishOS-$SAILFISH_VERSION/xiaomi-vince/g' sb2.config 
sudo ln -s /srv/mer/targets/SailfishOS-$SAILFISH_VERSION-armv7hl /srv/mer/targets/xiaomi-vince-armv7hl
sudo ln -s /srv/mer/toolings/SailfishOS-$SAILFISH_VERSION /srv/mer/toolings/xiaomi-vince

sdk-assistant list

cd $ANDROID_ROOT
rpm/dhd/helpers/build_packages.sh --droid-hal

DROIDMEDIA_VERSION=$(git --git-dir external/droidmedia/.git describe --tags | sed \
-r "s/\-/\+/g")
rpm/dhd/helpers/pack_source_droidmedia-localbuild.sh $DROIDMEDIA_VERSION
mkdir -p hybris/mw/droidmedia-localbuild/rpm
cp rpm/dhd/helpers/droidmedia-localbuild.spec \
hybris/mw/droidmedia-localbuild/rpm/droidmedia.spec
sed -ie "s/0.0.0/$DROIDMEDIA_VERSION/" \
hybris/mw/droidmedia-localbuild/rpm/droidmedia.spec
mv hybris/mw/droidmedia-$DROIDMEDIA_VERSION.tgz hybris/mw/droidmedia-localbuild
rpm/dhd/helpers/build_packages.sh --build=hybris/mw/droidmedia-localbuild

rpm/dhd/helpers/build_packages.sh --droid-hal
