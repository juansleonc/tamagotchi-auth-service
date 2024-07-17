# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.4
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /auth_service

# Instala las dependencias necesarias
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Instala las gemas de la aplicación
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia el código de la aplicación
COPY . .

# Asegúrate de que los directorios tmp y log existan
RUN mkdir -p tmp log


# Expone el puerto 9080
EXPOSE 9080

# El comando se especificará en docker-compose.yml
CMD ["rails", "server", "-b", "0.0.0.0"]