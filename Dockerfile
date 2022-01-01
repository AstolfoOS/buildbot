FROM archlinux:latest

RUN pacman -Syu --noconfirm
RUN pacman -S base-devel git doas --noconfirm
RUN pacman -Rns sudo --noconfirm

RUN mkdir /buildbot
RUN chmod 777 /buildbot
WORKDIR /buildbot

RUN echo 'permit nopass :wheel' > /etc/doas.conf
RUN chmod 400 /etc/doas.conf
RUN echo 'PACMAN_AUTH=("doas")' >> /etc/makepkg.conf

RUN useradd -m -G wheel buildbot
USER buildbot

ADD src/ /buildbot/src

VOLUME [ "/buildbot/repo" ]
VOLUME [ "/buildbot/packages" ]
VOLUME [ "/buildbot/tmp" ]

ENV REPO_URL=https://github.com/AstolfoOS/packages.git
ENV REPO_NAME=astolfos
ENV SIGN=false
ENV DEBUG=false

CMD [ "/bin/bash", "/buildbot/src/main.sh" ]