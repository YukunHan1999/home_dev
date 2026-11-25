FROM ubuntu:latest 

RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \ 
    sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \ 
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    fcitx5-frontend-gtk3 \
    file \
    fonts-noto-cjk \
    fzf \
    git \
    jq \
    locales \
    libasound2t64 \
    libatk1.0-0t64 \
    libatk-bridge2.0-0 \
    libgtk-3-0t64 \
    libgbm1 \
    libglib2.0-bin \
    libnspr4 \
    libnss3 \
    make \
    pulseaudio \
    python3 \
    ripgrep \
    silversearcher-ag \
    sudo \
    tmux \
    unzip \
    wget \
    xclip

RUN usermod -l hyk -d /home/hyk -m ubuntu && \
    groupmod -n hyk ubuntu && \
    usermod -aG sudo hyk && \
    echo "hyk ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    locale-gen en_US.UTF-8 && \
    locale-gen zh_CN.UTF-8 && \
    update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# 支持docker命令
RUN ALL_PROXY=http://172.17.0.2:7897 curl -L https://download.docker.com/linux/static/stable/x86_64/docker-29.4.1.tgz | tar xz && \
    mv docker/docker /usr/local/bin/ 

# 支持docker-compose命令
RUN mkdir -p /usr/lib/docker/cli-plugins && \
    ALL_PROXY=http://172.17.0.2:7897 curl -L https://github.com/docker/compose/releases/download/v5.8.0/docker-compose-linux-x86_64 -o /usr/lib/docker/cli-plugins/docker-compose && \
   chmod +x /usr/lib/docker/cli-plugins/docker-compose

USER hyk 
WORKDIR /workspace

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]
CMD ["/bin/bash"]
