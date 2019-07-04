#!/bin/bash
set -e
set -x

# Enable varnish repo
apt-get update
apt-get -y install curl
curl -s https://packagecloud.io/install/repositories/varnishcache/varnish${VARNISH_VERSION/./}/script.deb.sh | /bin/bash

# Install varnish & build deps
apt-get -y install varnish varnish-dev python-yaml python-pip libtool automake python-docutils
pip install --no-cache-dir jinja2-cli

mkdir -p /vmod/d7
curl -L https://github.com/fpfis/vmod-drupal7/archive/${VARNISH_VERSION}.tar.gz | tar --strip=1 -xzvC /vmod/d7
mkdir -p /vmod/vmods
curl -L https://github.com/varnish/varnish-modules/archive/0.15.0.tar.gz | tar --strip=1 -xzvC /vmod/vmods


# Build vmod d7
pushd /vmod/d7
./autogen.sh
./configure
make -j$(nproc)
make install DESTDIR=/usr/lib/varnish/vmods
popd
rm -Rf /vmod/d7

# Build vmods
pushd /vmod/vmods
./bootstrap
./configure
make -j$(nproc)
make install DESTDIR=/usr/lib/varnish/vmods
popd
rm -Rf /vmod/vmods

ldconfig -n /usr/lib/varnish/vmods

# Clean
apt-get autoremove -y --purge curl python-pip varnish-dev libtool automake python-docutils
apt-get clean
rm -rf /var/lib/apt/lists/*