FROM ubuntu:latest

# Disable any Ubuntu interactive frontend
ENV DEBIAN_FRONTEND=noninteractive
ENV NO_AT_BRIDGE=1

# Update the image to the latest base packages
RUN apt update
RUN apt -y upgrade

# Install required software
RUN apt -y install \
    build-essential \
    clang \
    curl \
    gdb \
    git \
    lld \
    lldb \
    llvm \
    nasm \
    qemu-system \
    zsh

ENTRYPOINT [ "zsh" ]
