FROM ubuntu:20.04

# installation
# this env avoids timezone selection, which needs interaction
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -qq \
    && apt install -y -qq \
    apt-utils \
    bzip2 \
    build-essential \
    cmake \
    curl \
    git \ 
    libncurses5-dev \
    libncursesw5-dev \
    libboost-all-dev \
    locales \
    nasm \ 
    nvtop \
    openssh-server \
    ruby \
    rsync \ 
    sudo \
    swig \
    tmux \
    unzip \
    wget \
    xorg-dev \ 
    xvfb \
    zlib1g-dev \
    zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ssh server
ENV NOTVISIBLE "in users profile"
RUN mkdir /var/run/sshd \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && echo "export VISIBLE=now" >> /etc/profile 

# utf-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# miniconda prefers non-root user,
# so first make user
USER root
RUN echo "root:Docker!" | chpasswd \
    && useradd user -m --groups sudo \
    && echo "user:Docker!" | chpasswd user 
# EXPOSE 22

USER user
ENV HOME /home/user

# ssh
RUN mkdir ${HOME}/.ssh \
    && touch ${HOME}/.ssh/authorized_keys 
