FROM archlinux:latest

RUN pacman -Syu --noconfirm
RUN pacman -S base-devel git --noconfirm

RUN mkdir /buildbot
RUN chmod 777 /buildbot
WORKDIR /buildbot

ADD --chown=root:root sudoers /etc/sudoers
RUN chmod 440 /etc/sudoers

RUN useradd -m -G wheel buildbot
USER buildbot

ADD src/ /buildbot/src

VOLUME [ "/buildbot/repo" ]
VOLUME [ "/buildbot/packages" ]
VOLUME [ "/buildbot/tmp" ]

ENV REPO_URL=https://github.com/AstolfoOS/packages.git
ENV REPO_NAME=astolfos

CMD [ "/bin/bash", "/buildbot/src/main.sh" ]