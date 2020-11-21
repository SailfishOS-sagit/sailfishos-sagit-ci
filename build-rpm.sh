#!/bin/bash

set -x

source /home/nemo/work/ci/ci/hadk.env
export ANDROID_ROOT=/home/nemo/work/hadk_16.0

sudo chown -R nemo:nemo $ANDROID_ROOT
cd $ANDROID_ROOT

cd ~/.scratchbox2
cp -R SailfishOS-*-$PORT_ARCH $VENDOR-$DEVICE-$PORT_ARCH
cd $VENDOR-$DEVICE-$PORT_ARCH
sed -i "s/SailfishOS-$SAILFISH_VERSION/$VENDOR-$DEVICE/g" sb2.config
sudo ln -s /srv/mer/targets/SailfishOS-$SAILFISH_VERSION-$PORT_ARCH /srv/mer/targets/$VENDOR-$DEVICE-$PORT_ARCH
sudo ln -s /srv/mer/toolings/SailfishOS-$SAILFISH_VERSION /srv/mer/toolings/$VENDOR-$DEVICE

# 3.3.0.16 hack
sudo zypper in kmod
sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -m sdk-install -R chmod 777 /boot

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
rpm/dhd/helpers/build_packages.sh --mw=https://git.sailfishos.org/mer-core/nfcd.git
rpm/dhd/helpers/build_packages.sh --mw=https://github.com/mer-hybris/libnciplugin.git
rpm/dhd/helpers/build_packages.sh --mw=https://github.com/mer-hybris/dummy_netd.git
rpm/dhd/helpers/build_packages.sh --build=hybris/mw/sailfish-fpd-community --spec=rpm/droid-biometry-fp.spec --do-not-install
rpm/dhd/helpers/build_packages.sh --build=hybris/mw/sailfish-fpd-community

rpm/dhd/helpers/build_packages.sh --droid-hal

cat /home/nemo/work/hadk_16.0/droid-hal-$DEVICE.log
