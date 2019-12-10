#!/bin/bash
source /home/nemo/work/ci/ci/hadk.env

mkdir -p $ANDROID_ROOT
cd $ANDROID_ROOT

cd ~/.scratchbox2
cp -R SailfishOS-*-armv7hl $VENDOR-$DEVICE-$PORT_ARCH
cd $VENDOR-$DEVICE-$PORT_ARCH
sed -i 's/SailfishOS-3.1.0.11/xiaomi-vince/g' sb2.config 
sudo ln -s /srv/mer/targets/SailfishOS-3.1.0.11-armv7hl /srv/mer/targets/xiaomi-vince-armv7hl
sudo ln -s /srv/mer/toolings/SailfishOS-3.1.0.11 /srv/mer/toolings/xiaomi-vince

sdk-assistant list

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

AUDIOFLINGERGLUE_VERSION=$(git --git-dir external/audioflingerglue/.git describe --tags | sed \
-r "s/\-/\+/g")
rpm/dhd/helpers/pack_source_audioflingerglue-localbuild.sh $AUDIOFLINGERGLUE_VERSION
mkdir -p hybris/mw/audioflingerglue-localbuild/rpm
cp rpm/dhd/helpers/audioflingerglue-localbuild.spec \
hybris/mw/audioflingerglue-localbuild/rpm/audioflingerglue.spec
sed -ie "s/0.0.0/$AUDIOFLINGERGLUE_VERSION/" \
hybris/mw/audioflingerglue-localbuild/rpm/audioflingerglue.spec
mv hybris/mw/audioflingerglue-$AUDIOFLINGERGLUE_VERSION.tgz hybris/mw/audioflingerglue-localbuild
rpm/dhd/helpers/build_packages.sh --build=hybris/mw/audioflingerglue-localbuild

rpm/dhd/helpers/build_packages.sh --droid-hal

zip -r droid-local-repo.zip droid-local-repo