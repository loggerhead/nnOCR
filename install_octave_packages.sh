#!/bin/bash
PACKAGES=( "general-1.3.4.tar.gz" "control-2.6.6.tar.gz" "signal-1.3.0.tar.gz" "image-2.2.2.tar.gz" )

URL_PREDIX="http://downloads.sourceforge.net/project/octave/Octave Forge Packages/Individual Package Releases/"

sudo apt-get install -y liboctave-dev

for PACKAGE in "${PACKAGES[@]}"
do
    wget -c "$URL_PREDIX$PACKAGE"
    octave --eval "pkg install $PACKAGE"
done

echo 'pkg load image' >> $HOME/.octaverc