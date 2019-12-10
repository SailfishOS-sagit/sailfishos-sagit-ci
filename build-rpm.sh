#!/bin/bash
source hadk.env

mkdir -p $ANDROID_ROOT
cd $ANDROID_ROOT

export PLATFORM_SDK_ROOT=/srv/mer
curl -k -O http://releases.sailfishos.org/sdk/installers/latest/Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2
sudo mkdir -p $PLATFORM_SDK_ROOT/sdks/sfossdk
sudo tar --numeric-owner -p -xjf Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2 -C $PLATFORM_SDK_ROOT/sdks/sfossdk
echo "export PLATFORM_SDK_ROOT=$PLATFORM_SDK_ROOT" >> ~/.bashrc
echo 'alias sfossdk=$PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot' >> ~/.bashrc
source ~/.bashrc
echo 'PS1="PlatformSDK $PS1"' > ~/.mersdk.profile
echo '[ -d /etc/bash_completion.d ] && for i in /etc/bash_completion.d/*;do . $i;done'  >> ~/.mersdk.profile
sfossdk
echo "Entered sfossdk, well done!"
source ~/work/hadk.env
cd $ANDROID_ROOT
sdk-assistant create xiaomi-vince-latest http://releases.sailfishos.org/sdk/targets/Sailfish_OS-latest-Sailfish_SDK_Tooling-i486.tar.7z -y
sdk-assistant create xiaomi-vince-armv7hl http://releases.sailfishos.org/sdk/targets/Sailfish_OS-latest-Sailfish_SDK_Target-armv7hl.tar.7z -y

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