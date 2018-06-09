FROM ubuntu:18.04

# If USER is changed, be sure to update hardcoded value in "COPY --chown" below.
ARG USER=mzheng
ARG GROUP=root
ARG NAME="Max Zheng"
ARG EMAIL="maxzheng.os@gmail.com"
ARG AUTOPIP_APPS="autopip developer-tools"

##############################################################################
###                         OS Customization                               ###
##############################################################################

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update -qq && \
    apt-get install -yqq \
        cron \
        curl \
        default-jdk \
        docker.io \
        doxygen \
        exuberant-ctags \
        fuse \
        git \
        gradle \
        iputils-ping \
        librdkafka-dev \
        locales \
        man \
        maven \
        mysql-client \
        openssh-server \
        python3 \
        python python-pip \
        python3-dev \
        python3-pip \
        python3-venv \
        rsync \
        screen \
        silversearcher-ag \
        telnet \
        tox \
        strace \
        sudo \
        unzip \
        vim \
        zip && \
    useradd $USER -g $GROUP --shell /bin/bash && \
        mkdir /home/$USER && \
        chown $USER /home/$USER && \
        echo "%$GROUP ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p \
        /etc/ssh/agents \
        /var/run/sshd && \
        chmod 0777 /etc/ssh/agents && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    pip3 install \
        autopip \
        neovim && \
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
    wget -q https://releases.hashicorp.com/vagrant/2.1.0/vagrant_2.1.0_x86_64.deb && \
        dpkg -i vagrant_2.1.0_x86_64.deb && \
        rm vagrant_2.1.0_x86_64.deb && \
    echo "locales locales/default_environment_locale select C.UTF-8" | debconf-set-selections && \
        dpkg-reconfigure locales

# Staging area to avoid rebuild of everything. Merge above once awhile.
RUN autopip install $AUTOPIP_APPS && \
    echo "*/5 *   * * *   $USER   bin/generate-ctags 2>&1 > /tmp/cron-generate-ctags.log" >> /etc/crontab


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

RUN vagrant plugin install vagrant-aws vagrant-hostmanager

# Do copy last so changes don't trigger rebuild
COPY root /

WORKDIR /home/$USER/workspace

# Changing directory, so let's run by itself
RUN wst setup -a

EXPOSE 22

CMD ["sudo", "/usr/sbin/sshd", "-D"]
