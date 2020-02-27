FROM golang:1.13-stretch

ENV VERSION 0.6.0-1
ENV SONAR_SCANNER_VERSION 4.0.0.1744
ENV TIME_ZONE Europe/London

RUN  echo "${TIME_ZONE}" > /etc/timezone \
     && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
RUN apt update
RUN apt-get install -y make g++ libssl-dev openssl git ansible unzip python python-pip

RUN curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.20.0
RUN curl -L https://github.com/AGWA/git-crypt/archive/debian/$VERSION.tar.gz | tar zxv -C /var/tmp \
    && cd /var/tmp/git-crypt-debian-$VERSION \
    && make \
    && make install PREFIX=/usr/local \
    && rm -rf /var/tmp/*

RUN curl -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip \
    && unzip sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip \
    && ln -s $PWD/sonar-scanner-$SONAR_SCANNER_VERSION-linux/bin/sonar-scanner /usr/local/bin/

# Add aws cli
RUN pip install awscli
