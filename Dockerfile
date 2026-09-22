FROM docker.io/library/ruby:4.0.7

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y chromium nodejs npm && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN npm install tailwindcss @tailwindcss/cli

COPY . .

RUN npx @tailwindcss/cli -i ./web/tailwind.css -o ./web/tw.css

CMD ["falcon", "serve", "--bind", "http://0.0.0.0:3000"]