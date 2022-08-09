FROM ubuntu:20.04


ARG ARACHNI_VERSION=arachni-1.6.1.3-0.6.1.1
ENV SERVER_ROOT_PASSWORD arachni
ENV ARACHNI_USERNAME arachni
ENV ARACHNI_PASSWORD password
ENV DB_ADAPTER sqlite
RUN apt-get update

RUN apt-get -y install \
    openssh-server \
    wget \
    curl \
    iproute2 \
    unzip

RUN mkdir /var/run/sshd

#COPY "$PWD"/${ARACHNI_VERSION}-linux-x86_64.tar.gz ${ARACHNI_VERSION}-linux-x86_64.tar.gz
RUN wget https://github.com/Arachni/arachni/releases/download/v1.6.1.3/${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    tar xzvf ${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    mv ${ARACHNI_VERSION}/ /usr/local/arachni && \
    rm -rf *.tar.gz

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt -y install ./google-chrome-stable_current_amd64.deb

COPY "$PWD"/files /
EXPOSE 22 7331 9292 9515

RUN echo 'root:'${SERVER_ROOT_PASSWORD} | chpasswd
RUN  useradd -m arachni && echo "arachni:arachni" | chpasswd && usermod -aG sudo arachni
USER arachni

CMD /usr/local/arachni/bin/arachni_rest_server --addres 0.0.0.0 --authentication-username ${ARACHNI_USERNAME} --authentication-password ${ARACHNI_PASSWORD} --only-positives
