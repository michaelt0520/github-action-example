FROM ruby:2.6.5

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get install nodejs -y

RUN npm install -g yarn

RUN mkdir /test_coding

WORKDIR /test_coding

ENV BUNDLE_PATH /test_coding/bundle

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .