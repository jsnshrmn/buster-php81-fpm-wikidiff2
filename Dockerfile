FROM docker-registry.wikimedia.org/dev/buster-php81-fpm:1.0.0
ADD install_wikidiff2.sh /
RUN /install_wikidiff2.sh