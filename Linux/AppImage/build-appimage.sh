#/bin/sh

# this is script for github action
# run from root directory !!!

# get linuxdeploy-x86_64.AppImage
wget -nv -c https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage

# get and build sdl2 2.28 for ubuntu 20.04
# ubuntu 20.02 have deprecated sdl2
wget -nv -c https://www.libsdl.org/release/SDL2-2.28.5.tar.gz
tar xzpf SDL2-2.28.5.tar.gz
cd SDL2-2.28.5
mkdir build && cd build 
../configure
make -j4
sudo make install
cd ..
cd ..

# get and build sdl2-image 2.8.2 for ubuntu 20.04
# ubuntu 20.02 have deprecated sdl_image
wget -nv -c https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.8.2.tar.gz
tar xzpf SDL2_image-2.8.2.tar.gz
cd SDL2_image-2.8.2
mkdir build && cd build 
../configure
make -j4
sudo make install
cd ..
cd ..

# add appimage sources
cp -ax Linux/AppImage/Sources/appimage.* Quake

# apply appimage patch and compile
patch -p1 Linux/AppImage/patches/0001-ironwail-AppImage.patch

# if use cmake
# mkdir build && cd build
# cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE=Release ..
cd Quake
make -j4
cd ..

# if use cmake
# cp -ax build/ironwail Linux/AppImage/AppDir/usr/bin
cp -ax Quake/ironwail Linux/AppImage/AppDir/usr/bin
cp -ax Quake/ironwail.pak Linux/AppImage/AppDir/usr/bin
cp -ax Linux/AppImage/Img/ironwail.jpg Linux/AppImage/AppDir/usr/bin

# create appimage
SIGN=1 ./linuxdeploy-x86_64.AppImage --executable Linux/AppImage/AppDir/usr/bin/ironwail --desktop-file Linux/AppImage/AppDir/usr/share/applications/io.github.andrei-drexler.ironwail.desktop --icon-file Linux/AppImage/AppDir/usr/share/icons/hicolor/128x128/apps/ironwail.png --appdir Linux/AppImage/AppDir --output appimage

# rename appimage
mv ironwail-x86_64.AppImage ironwail-0.8.0-x86_64.AppImage
chmod +x ironwail-0.8.0-x86_64.AppImage
