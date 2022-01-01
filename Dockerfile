FROM archlinux:latest

RUN pacman -Syu --noconfirm
RUN pacman -S base-devel git doas archiso mktorrent --noconfirm
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
VOLUME [ "/buildbot/iso-src" ]
VOLUME [ "/buildbot/iso" ]

ENV REPO_URL=https://github.com/AstolfoOS/packages.git
ENV REPO_NAME=astolfos
ENV ISO_URL=https://github.com/AstolfoOS/iso.git
ENV ISO_WEB=https://astolfo.laurinneff.ch/iso
ENV SIGN=false
ENV DEBUG=false
ENV BUILD_REPO=true
ENV BUILD_ISO=true

CMD [ "/bin/bash", "/buildbot/src/main.sh" ]
