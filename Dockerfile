FROM ubuntu:16.04

RUN set -xe \
  && apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-unstable \
    && rm -rf /var/lib/apt/lists/*
 
# basics
RUN apt-get update
RUN apt-get install -y build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison
RUN apt-get update && apt-get install -y git
RUN apt-get install -y libcurl4-gnutls-dev
RUN apt-get install -y curl
ARG CHROME_DRIVER_VERSION=2.29
RUN apt-get install -y unzip
RUN wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip 
RUN rm -rf /opt/selenium/chromedriver 
RUN unzip /tmp/chromedriver_linux64.zip -d /opt/selenium 
RUN rm /tmp/chromedriver_linux64.zip 
RUN mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION 
RUN chmod 755 /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION 
RUN ln -fs /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/
RUN mv /opt/selenium/chromedriver-2.29 /usr/local/bin/chromedriver

# install RVM, Ruby, and Bundler
RUN \curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c 'rvm install 2.3.0'
RUN apt-get install -y ruby-dev
RUN /bin/bash -l -c 'gem install bundler --no-ri --no-rdoc'
RUN gem install nokogiri

EXPOSE 92

ENTRYPOINT [ "google-chrome" ]

