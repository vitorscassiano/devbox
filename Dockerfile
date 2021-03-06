FROM phusion/baseimage

RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
RUN apt-get update
RUN apt-get install -y build-essential git vim perl gcc nodejs nodejs-legacy docker-engine curl postgresql-client mysql-client redis-tools python3-pip dnsutils

RUN useradd dev
RUN mkdir /home/dev
RUN chown dev -R /home/dev
RUN curl -L https://cpanmin.us | perl - --sudo App::cpanminus
RUN cpanm Mojolicious
WORKDIR /home/dev
ENV HOME /home/dev

RUN curl -Lvk -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.tar.gz > /tmp/jdk8.tgz
RUN tar zxf /tmp/jdk8.tgz -C /usr/local/
RUN rm -f /tmp/jdk8.tgz
ENV JAVA_HOME "/usr/local/jdk1.8.0_73"
ENV PATH $PATH:"/usr/local/jdk1.8.0_73/bin"
COPY jtest /usr/bin/jtest

RUN pip3 install virtualenv

#RUN sudo gpasswd -a dev docker

VOLUME /var/run/docker.sock

#USER dev

#RUN git clone https://github.com/tadzik/rakudobrew /home/dev/.rakudobrew
##ENV PATH $PATH:/home/dev/.rakudobrew/bin
#RUN /home/dev/.rakudobrew/bin/rakudobrew build moar
#RUN /home/dev/.rakudobrew/bin/rakudobrew build panda
#
#RUN /home/dev/.rakudobrew/bin/panda install Task::Star

COPY devbox /usr/bin/devbox
COPY create_devbox /usr/bin/create_devbox
COPY ctest /usr/bin/ctest
COPY ptest /usr/bin/ptest

CMD bash

RUN ln -s /bin/bash /etc/service/bash
#CMD ["/sbin/my_init"]
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
