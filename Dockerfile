FROM ubuntu:16.04 
USER root

WORKDIR /tests

ARG TEST_CONFIG="{'error':'missing_config'}"

ENV MOZ_HEADLESS="1"

RUN apt-get -y update && \
    apt-get install -y -qq software-properties-common && \
    apt-get install -y -qq wget unzip \ 
                       libreadline-gplv2-dev libncursesw5-dev \
                       libssl-dev libsqlite3-dev tk-dev libgdbm-dev \
                       libc6-dev libbz2-dev libgtk-3-0 libdbus-glib-1-2 \
                       libgtk-3-dev libglib2.0-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN mkdir -p /mnt/extra/mozilla-central/services && \
    mkdir -p /mnt/extra/mozilla-central/testing/tps && \
    wget -q https://github.com/mozilla/gecko-dev/archive/master.zip 

# services/sync
RUN unzip master.zip 'gecko-dev-master/services/sync/*' -d /tmp && \
    mv /tmp/gecko-dev-master/services/sync /mnt/extra/mozilla-central/services 

# testing/modules
RUN unzip master.zip 'gecko-dev-master/testing/modules/*' -d /tmp && \
    mv /tmp/gecko-dev-master/testing/modules /mnt/extra/mozilla-central/testing 

# testing/tps
RUN unzip master.zip 'gecko-dev-master/testing/tps/*' -d /tmp && \
    mv /tmp/gecko-dev-master/testing/tps /mnt/extra/mozilla-central/testing 

RUN wget -O firefox-nightly.tar.bz2 'https://download.mozilla.org/?product=firefox-nightly-latest-ssl&os=linux64&lang=en-US' && \
    tar xjf firefox-nightly.tar.bz2 && \
    mv -i firefox firefox-nightly && \
    rm -rf /tmp master.zip firefox-nightly.tar.bz2

RUN cd /mnt/extra/mozilla-central/testing/tps && \
    ./create_venv.py /tests/venv 

CMD . /tests/venv/bin/activate && \
    echo ${TEST_CONFIG} > config.json && \
    /tests/venv/bin/runtps --debug --binary="/tests/firefox-nightly/firefox" --configfile=/tests/config.json
