FROM ubuntu:19.04

# If USER is changed, be sure to update hardcoded value in "COPY --chown" below.
ARG USER=mzheng
ARG GROUP=root
ARG NAME="Max Zheng"
ARG EMAIL="maxzheng.os@gmail.com"
ARG AUTOPIP_APPS="autopip developer-tools"

##############################################################################
###                         OS Customization                               ###
##############################################################################

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    rm /etc/dpkg/dpkg.cfg.d/excludes
RUN apt-get update -qq && \
    apt-get install -yqq \
        build-essential \
        checkinstall \
        cron \
        curl \
        docker.io \
        doxygen \
        exuberant-ctags \
        fuse \
        git \
        gradle \
        iputils-ping \
        libbz2-dev \
        libc6-dev \
        libgdbm-dev \
        libncursesw5-dev \
        librdkafka-dev \
        libreadline-gplv2-dev \
        libsqlite3-dev \
        libssl-dev \
        locales \
        lsb-core \
        man \
        maven \
        mysql-client \
        openjdk-8-jdk \
        openssh-server \
        parallel \
        postgresql-client \
        python \
        python-pip \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        rlwrap \
        rsync \
        screen \
        silversearcher-ag \
        telnet \
        tk-dev \
        tox \
        strace \
        sudo \
        unzip \
        vim \
        wget \
        zip && \
    update-java-alternatives --set java-1.8.0-openjdk-amd64 && \
    useradd $USER -g $GROUP --shell /bin/bash && \
        mkdir /home/$USER && \
        chown $USER /home/$USER && \
        echo "%$GROUP ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p \
        /etc/ssh/agents \
        /var/run/sshd && \
        chmod 0777 /etc/ssh/agents && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    pip3 install -U \
        pip \
        autopip \
        neovim \
        wheel && \
    wget -q https://s3-us-west-2.amazonaws.com/confluent.cloud/cli/ccloud-latest.tar.gz && \
        tar xzf ccloud-latest.tar.gz && \
        cp -r ccloud-*/* /usr/local && \
        rm -rf ccloud-* && \
    wget -q https://releases.hashicorp.com/terraform/0.11.6/terraform_0.11.6_linux_amd64.zip && \
        unzip terraform*.zip -d /usr/local/bin && \
        rm terraform*.zip && \
    wget -q https://releases.hashicorp.com/packer/1.2.3/packer_1.2.3_linux_amd64.zip && \
        unzip packer_1.2.3_linux_amd64.zip -d /usr/local/bin && \
        rm packer_1.2.3_linux_amd64.zip && \
    wget -q https://releases.hashicorp.com/vagrant/2.1.5/vagrant_2.1.5_x86_64.deb && \
        dpkg -i vagrant_2.1.5_x86_64.deb && \
        rm vagrant_2.1.5_x86_64.deb && \
    echo "locales locales/default_environment_locale select C.UTF-8" | debconf-set-selections && \
        dpkg-reconfigure locales && \
    autopip install $AUTOPIP_APPS && \
        echo "*/5 *   * * *   $USER   bin/generate-ctags 2>&1 > /tmp/cron-generate-ctags.log" >> /etc/crontab && \
    apt install -y --reinstall coreutils procps && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
        echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
        apt update && \
        apt install  -yqq google-cloud-sdk && \
    curl -O https://download.clojure.org/install/linux-install-1.10.0.442.sh && \
        chmod +x linux-install-1.10.0.442.sh && \
        sudo ./linux-install-1.10.0.442.sh && \
        rm ./linux-install-1.10.0.442.sh && \
    wget -q https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -P /usr/local/bin && \
        chmod +x /usr/local/bin/lein && \
    wget -q https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tar.xz && \
        tar xvf Python-3.6.8.tar.xz && \
        cd Python-3.6.8 && \
        ./configure && \
        make altinstall && \
        cd .. && rm -rf Python-3.6.8 && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
        sudo apt update && sudo apt install -yqq yarn



# Staging area to avoid rebuild of everything. Merge above once awhile.

##############################################################################
###                         User Customization                             ###
##############################################################################
USER $USER:$GROUP
WORKDIR /home/$USER

# chown doesn't support args yet: https://github.com/moby/moby/issues/35018
COPY --chown=mzheng:root user /home/$USER
# Everything after this need to run after COPY as they need/modify stuff from user templates.

RUN vim +PlugInstall +qall && \
    mkdir .m2

RUN echo "\n\
. /etc/setup-ssh-agent\n\
/etc/setup-jobs $AUTOPIP_APPS\n\
\n\
" >> .bashrc && \
    echo "\n\
[user]\n\
	name = $NAME\n\
	email = $EMAIL\n\
" >> .gitconfig

# Do copy last so changes don't trigger rebuild
COPY root /

WORKDIR /home/$USER/workspace

RUN wst setup -a && sudo autopip update

EXPOSE 22

CMD ["sudo", "/usr/sbin/sshd", "-D"]
