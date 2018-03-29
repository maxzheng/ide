FROM ubuntu:rolling

# If USER is changed, be sure to update hardcoded value in "COPY --chown" below.
ARG USER=mzheng
ARG GROUP=root
ARG NAME="Max Zheng"
ARG EMAIL="maxzheng.os@gmail.com"

##############################################################################
###                         OS Customization                               ###
##############################################################################

RUN apt-get update && \
    apt-get install -y \
        default-jdk \
        git \
        openssh-server \
        python3 \
        python python-pip \
        python3-dev \
        python3-pip \
        python3-venv \
        screen \
        silversearcher-ag \
        tox \
        sudo \
        vim && \
    useradd $USER -g $GROUP --shell /bin/bash && \
        mkdir /home/$USER && \
        chown $USER /home/$USER && \
        echo "%$GROUP ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p \
        /etc/ssh/agents \
        /var/run/sshd && \
        chmod 0777 /etc/ssh/agents && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd

# Staging area to avoid rebuild of everything. Merge above once awhile.
RUN apt-get install -y \
        librdkafka-dev \
        mysql-client \
        iputils-ping \
        curl

##############################################################################
###                         User Customization                             ###
##############################################################################
USER $USER:$GROUP
WORKDIR /home/$USER

RUN mkdir .virtualenvs workspace && \
    python3 -m venv .virtualenvs/tools && \
        .virtualenvs/tools/bin/pip3 install -U pip && \
        .virtualenvs/tools/bin/pip3 install xonsh workspace-tools twine

# chown doesn't support args yet: https://github.com/moby/moby/issues/35018
COPY --chown=mzheng:root user /home/$USER

RUN cd workspace && \
    ../.virtualenvs/tools/bin/wst setup -a

# These "echo"s need to be run by themselves to work.
RUN echo "\n\
# Setup ssh-agent on login\n\
. /etc/ssh/agents/$USER &> /dev/null || . /etc/setup-ssh-agent\n\
\n\
# Make Python tools available
export PATH=$PATH:/home/$USER/.virtualenvs/tools/bin\n\
" >> .bashrc && \
    echo "\n\
[user]\n\
	name = $NAME\n\
	email = $EMAIL\n\
" >> .gitconfig

COPY root /

WORKDIR /home/$USER/workspace

EXPOSE 22

CMD ["sudo", "/usr/sbin/sshd", "-D"]
