FROM ruby:2-slim-buster
WORKDIR /hacker
ADD . /hacker
RUN apt update && \
    apt install -y build-essential locales && \
    locale-gen && \
    bundle install && \
    apt purge -y build-essential && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*
ENV LC_ALL="C.UTF-8" 
ENTRYPOINT ["/usr/local/bin/ruby", "/hacker/bin/hack"]
