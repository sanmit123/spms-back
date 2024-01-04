FROM jruby:9.3

WORKDIR /usr/src/app

RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server"]
