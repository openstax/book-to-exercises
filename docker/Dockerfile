FROM ruby:2.6.6-slim

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

RUN apt-get update && apt-get install -y \
  git \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

RUN gem install bundler:2.1.4 && \
    bundle config set silence_root_warning 'true'

#COPY src/Gemfile* /tmp/
#
#RUN cd /tmp && \
#    bundle install && \
#   rm -rf /root/.bundle/cache/*


