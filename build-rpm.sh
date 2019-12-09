#!/bin/bash
source hadk.env
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