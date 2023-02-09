ARG image=docker-registry.wikimedia.org/dev/buster-php81-fpm:1.0.0
FROM $image
ARG php_version=${PHP_VERSION}
ADD install_wikidiff2.sh /
RUN /install_wikidiff2.sh $php_version
