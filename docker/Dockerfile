FROM ruby:2.7.2
RUN apt-get update \
      && apt-get install -y --no-install-recommends nodejs \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Define where our application will live inside the image
ENV RAILS_ROOT /usr/src/app

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

# config boton repository
COPY Gemfile* $RAILS_ROOT/
RUN bundle install --jobs=3 --retry=3

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
