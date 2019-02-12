FROM ruby:2.5.3

ENV LANG C.UTF-8

RUN echo "gem: --no-document" > $HOME/.gemrc && \
    touch $HOME/.irb-history && \
    echo "IRB.conf[:SAVE_HISTORY] = 1000\nIRB.conf[:HISTORY_FILE] = '~/.irb-history'" > $HOME/.irbrc
RUN apt-get update -qq && apt-get install -y nodejs

RUN mkdir /rails_app
WORKDIR /rails_app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

# ENV RAILS_ENV $RAILS_ENV

EXPOSE 3000

# Start the main process.
CMD ["bin/rails", "s"]
