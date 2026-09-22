FROM docker.io/library/ruby:4.0.7

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y chromium && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["falcon", "serve", "--bind", "http://0.0.0.0:3000"]