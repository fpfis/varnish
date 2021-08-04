#!/bin/bash
set -e
set -x

# Enable varnish repo
apt-get update
apt-get install -qq curl
curl -s https://packagecloud.io/install/repositories/varnishcache/varnish${VARNISH_VERSION/./}lts/script.deb.sh | /bin/bash

# Install varnish & build deps
apt-get install -qq varnish varnish-dev python-yaml python-pip libtool automake python-docutils libgetdns1 libgetdns-dev
pip install --no-cache-dir jinja2-cli

mkdir -p /vmod/d7
curl -L https://github.com/fpfis/vmod-drupal7/archive/${VARNISH_VERSION}.tar.gz | tar --strip=1 -xzvC /vmod/d7
mkdir -p /vmod/vmods
curl -L https://github.com/varnish/varnish-modules/archive/0.15.0.tar.gz | tar --strip=1 -xzvC /vmod/vmods
mkdir -p /vmod/dynamics
curl -L https://github.com/nigoroll/libvmod-dynamic/archive/refs/heads/6.0.tar.gz  | tar --strip=1 -xzvC vmod/dynamics

# Build vmod d7
pushd /vmod/d7
./autogen.sh
./configure
make -j$(nproc)
/usr/bin/install -c src/.libs/libvmod_drupal7.so /usr/lib/varnish/vmods/libvmod_drupal7.so
/usr/bin/install -c src/.libs/libvmod_drupal7.lai /usr/lib/varnish/vmods/libvmod_drupal7.la
#vmoddir=/usr/lib/varnish/vmods make install
popd
rm -Rf /vmod/d7

# Build vmods
pushd /vmod/vmods
./bootstrap
./configure
make -j$(nproc)
make install
popd
rm -Rf /vmod/vmods

ldconfig -n /usr/lib/varnish/vmods

pushd /vmod/dynamics
./autogen.sh
./configure  
echo "127.0.0.1 www.localhost img.localhost" >> /etc/hosts && rm /vmod/dynamics/src/tests/resolver/cfg.vtc /vmod/dynamics/src/tests/service/basic.vtc
make check
make install
popd

# Clean
apt-get autoremove -y --purge curl python-pip varnish-dev libtool automake python-docutils libgetdns-dev
apt-get clean
rm -rf /var/lib/apt/lists/*
