FROM ubuntu:latest

# Disable any Ubuntu interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Update the image to the latest base packages
RUN apt update
RUN apt -y upgrade

# Install required software
RUN apt -y install \
    build-essential \
    clang \
    curl \
    git \
    lldb \
    llvm \
    nasm \
    qemu-system \
    zsh

ENTRYPOINT [ "zsh" ]
