from ubuntu:16.04 as builder

run apt update \
# dependencies
    && apt install -y \
        build-essential \
        g++ \
        cmake \
        git \
        wget \
        libfreetype6-dev \
        libjpeg-dev \
        xorg-dev \
        libxrandr-dev \
        xcb \
        libx11-xcb-dev \
        libxcb-randr0-dev \
        libxcb-image0-dev \
        libgl1-mesa-dev \
        libflac-dev \
        libogg-dev \
        libvorbis-dev \
        libopenal-dev \
        libpthread-stubs0-dev \
        libudev-dev \
# get
    && mkdir /build && cd build \
    && git clone https://github.com/SFML/SFML.git && cd SFML \
# apply a patch due to gcc bug
    && wget -O gcc.patch https://gitlab.peach-bun.com/pinion/SFML/commit/3383b4a472f0bd16a8161fb8760cd3e6333f1782.patch \
    && git apply gcc.patch \
    && mkdir build && cd build \
    && mkdir ../out \
# Release build
    && cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/build/SFML/out/usr/local/ \
        .. \
    && make install \
# Debug build
    && cmake \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_INSTALL_PREFIX=/build/SFML/out/usr/local/ \
        .. \
    && make install

# final image
from ubuntu:16.04

copy --from=builder /build/SFML/out/ /

# runtime dependencies and basic building setup
run apt update \
    && apt upgrade -y \
    && apt install -y \
        build-essential \
        g++ \
        cmake \
        git \
        libfreetype6 \
        libjpeg8 \
        xorg \
        libxrandr2 \
        xcb \
        libx11-xcb1 \
        libxcb-randr0 \
        libxcb-image0 \
        libgl1-mesa-glx \
        libflac8 \
        libogg0 \
        libvorbis0a \
        libvorbisenc2 \
        libopenal1 \
        libudev1
