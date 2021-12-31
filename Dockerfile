FROM archlinux:latest

RUN pacman -Syu --noconfirm
RUN pacman -S base-devel git --noconfirm

RUN mkdir /buildbot
RUN chmod 777 /buildbot
WORKDIR /buildbot

RUN useradd -m -G wheel buildbot
USER buildbot

ADD sudoers /etc/sudoers
ADD src/ /buildbot/src

VOLUME [ "/buildbot/repo" ]
VOLUME [ "/buildbot/packages" ]
VOLUME [ "/buildbot/tmp" ]

ENV REPO_URL=https://github.com/AstolfoOS/packages.git
ENV REPO_NAME=astolfos

CMD [ "/bin/bash", "/buildbot/src/main.sh" ]