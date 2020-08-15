# ubuntu-18.04
FROM nvidia/cuda:10.2-devel-ubuntu18.04

# installation
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

# nvtop
# see https://github.com/Syllo/nvtop/issues/42
RUN cd /tmp \
    && ln -s /usr/local/cuda-10.2/targets/x86_64-linux/lib/stubs/libnvidia-ml.so /usr/local/lib/libnvidia-ml.so \
    && ln -s /usr/local/cuda-10.2/targets/x86_64-linux/lib/stubs/libnvidia-ml.so /usr/local/lib/libnvidia-ml.so.1  \
    && git clone https://github.com/Syllo/nvtop.git \
    && mkdir -p nvtop/build \
    && cd nvtop/build \
    && cmake .. \
    && make \
    && make install \
    && cd ../.. \
    && rm -r /tmp/nvtop \
    && rm /usr/local/lib/libnvidia-ml.so \
    && rm /usr/local/lib/libnvidia-ml.so.1

# miniconda prefers non-root user,
# so first make user
USER root
RUN echo "root:Docker!" | chpasswd \
    && useradd user -m --groups sudo \
    && echo "user:Docker!" | chpasswd user 
# EXPOSE 22

# change user to any name
USER user
ENV HOME /home/user
ENV CONDADIR ${HOME}/.miniconda
RUN cd ${HOME} \
    && wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash miniconda.sh -b -p ${CONDADIR} \
    && rm miniconda.sh \
    # install basic libraries
    && ${CONDADIR}/bin/conda install -y -q pytorch torchvision cudatoolkit=10.1 -c pytorch \
    && ${CONDADIR}/bin/pip install ipython glances neovim nvidia-ml-py3\
    && ${CONDADIR}/bin/conda clean -afy

# install linuxbrew
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" \
    && ${HOME}/.linuxbrew/bin/brew upgrade \
    && ${HOME}/.linuxbrew/bin/brew cleanup

# ssh
RUN mkdir ${HOME}/.ssh \
    && touch ${HOME}/.ssh/authorized_keys 
