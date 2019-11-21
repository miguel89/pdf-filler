FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y nodejs && apt-get install -y pdftk-java

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV MONGOHQ_URL mongo:27017

RUN mkdir /pdf-filler
WORKDIR /pdf-filler
COPY Gemfile /pdf-filler/Gemfile
COPY Gemfile.lock /pdf-filler/Gemfile.lock
RUN gem install bundler -v '2.0.2'
RUN bundle config --global frozen 1
RUN bundle install --without development test
COPY . /pdf-filler

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
