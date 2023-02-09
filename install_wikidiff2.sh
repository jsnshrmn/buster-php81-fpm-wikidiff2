#!/usr/bin/env bash
php_version=${1:-$PHP_VERSION}
php=/usr/bin/php${php_version}
phpize=/usr/bin/phpize${php_version}

# Install deps
tmp_pkg_list="gcc libthai-dev make php${php_version}-dev pkg-config"
apt update
DEBIAN_FRONTEND=noninteractive apt install -o Dpkg::Options::="--force-confold"  -y ${tmp_pkg_list} libthai0

# Clone the repo
mkdir -p tmp
cd tmp/
git clone https://github.com/wikimedia/mediawiki-php-wikidiff2.git ||:
cd mediawiki-php-wikidiff2

# Allows this to work with multiple php versions
phpize_api=`$phpize -v | grep 'PHP Api Version'`
api=${phpize_api: -8:8}

# Build the module
${phpize}
PHP_EXECUTABLE=${php} ./configure --with-php-config=/usr/bin/php-config${php_version}
make build-modules
make install

# Installation cribbed from:
# https://www.mediawiki.org/wiki/MediaWiki-Docker/Configuration_recipes/Develop_PHP_extension

# Check for working module
${php} -d "extension=/usr/lib/php/${api}/wikidiff2.so" -i | fgrep wikidiff2

# Enable for Apache and php-cli
echo "extension=/usr/lib/php/${api}/wikidiff2.so" > /etc/php/${php_version}/mods-available/wikidiff2.ini
ln -sf /etc/php/${php_version}/mods-available/wikidiff2.ini /etc/php/${php_version}/apache2/conf.d/wikidiff2.ini
ln -sf /etc/php/${php_version}/mods-available/wikidiff2.ini /etc/php/${php_version}/cli/conf.d/wikidiff2.ini
ln -sf /etc/php/${php_version}/mods-available/wikidiff2.ini /etc/php/${php_version}/fpm/conf.d/wikidiff2.ini

# @FIXME: this cleanup could be skipped if I bothered to make a multistage Dockerfile
cd ../
rm -rf tmp/
DEBIAN_FRONTEND=noninteractive apt remove -o Dpkg::Options::="--force-confold"  -y ${tmp_pkg_list}
apt autoremove -y
apt clean -y
