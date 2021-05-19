FROM ubuntu:20.04

RUN apt-get -y update && apt-get -y dist-upgrade && apt-get -y autoremove && apt-get clean
RUN apt-get -y install dialog apt-utils locales

RUN echo "LC_ALL=en_US.UTF-8" > /etc/environment
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get -y install \
    wget git gcc make gdb python3 python-is-python3 \
    python3-pip python3-dev libssl-dev libffi-dev \
    build-essential sudo vim nano zsh

RUN chsh -s /bin/zsh

RUN useradd -ms /bin/zsh pwner
RUN echo '%pwner ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER pwner
WORKDIR /home/pwner

ENV PATH /home/pwner/.local/bin:$PATH

RUN git clone https://github.com/pwndbg/pwndbg /home/pwner/pwndbg && cd /home/pwner/pwndbg && ./setup.sh

RUN echo "source /home/pwner/pwndbg/gdbinit.py" >> /home/pwner/.gdbinit

RUN wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

RUN python -m pip install --upgrade pip

RUN python -m pip install --upgrade pwntools

COPY .zshrc /home/pwner/.zshrc

ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ENTRYPOINT ["/bin/zsh"]