FROM ruby:2.3.0-slim

MAINTAINER Max Lund <lundmax@gmail.com>

RUN apt-get update && apt-get install -qq -y nodejs build-essential libpq-dev postgresql-client-9.4 git-all --fix-missing --no-install-recommends

RUN ln -s /usr/bin/nodejs /usr/bin/node

ENV INSTALL_PATH /portfolio
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile
RUN bundle install

COPY . .

RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname SECRET_TOKEN=pickasecuretoken assets:precompile

VOLUME ["$INSTALL_PATH/public"]

CMD bundle exec puma -C config/puma.rb
