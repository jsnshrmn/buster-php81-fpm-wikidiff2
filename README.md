# buster-php81-fpm-wikidiff2
adds mediawiki-php-wikidiff2 to a buster-php81-fpm container, which I found useful for [mediawiki-docker](https://www.mediawiki.org/wiki/MediaWiki-Docker)

## Usage
1. add the build context below to [docker-compose.override.yml](https://www.mediawiki.org/wiki/MediaWiki-Docker/Configuration_recipes/Example_docker-compose.override.yml_file)
```
  mediawiki:
    build:
      context: https://github.com/jsnshrmn/buster-php81-fpm-wikidiff2.git
      ## optional args
      args:
        image: docker-registry.wikimedia.org/dev/buster-php81-fpm:1.0.0
        php_version: 8.1
```
2. `docker compose build mediawki`
3. `docker compose up`
