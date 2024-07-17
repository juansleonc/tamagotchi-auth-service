ARG RUBY_VERSION=3.3.4
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /auth_service

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN bundle exec rails assets:precompile

RUN mkdir -p tmp log

EXPOSE 9080

CMD ["rails", "server", "-b", "0.0.0.0"]