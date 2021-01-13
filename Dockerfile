# links
# https://github.com/Tremeschin/ardour-crosscompile-arch
# https://github.com/garyritchie/ardour-build
# https://musicsecrets.euniversity.pub/ardour.html
# https://guysherman.com/2015/08/16/building-ardour-on-windows-with-msys2/

FROM archlinux

WORKDIR /opt

RUN pacman -Syu --noconfirm sudo git python3 python-pip fakeroot make base-devel

RUN git clone https://github.com/Tremeschin/ardour-crosscompile-arch.git

RUN pip install pyunpack neotermcolor GitPython tqdm wget bs4

## add yay
RUN git clone https://aur.archlinux.org/yay-git.git; \
  chmod -R go+w -R yay-git

RUN groupadd sudo; useradd docker -G sudo; echo 'docker: ' | chpasswd docker; \
  mkdir /home/docker; chown -R docker:docker /home/docker
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
RUN cd /opt/yay-git/; makepkg -si --noconfirm
RUN pwd; ls; sudo rm -R yay-git/; cd ardour-crosscompile-arch/; python main.py

ADD build_ardour /usr/local/bin/build_ardour
RUN chmod +x /usr/local/bin/build_ardour

ENTRYPOINT ["build_ardour"]
