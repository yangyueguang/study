FROM centos:latest
USER root
ENV PATH=$PATH:/usr/node/bin
RUN mkdir /app
WORKDIR /app
RUN yum install -y langpacks-zh_CN && echo "LANG=zh_CN.utf8" > /etc/locale.conf
RUN yum install -y wget unzip cronie crontabs python3 nginx openssl gcc automake autoconf libtool make
RUN wget --no-cache https://nodejs.org/dist/v14.17.4/node-v14.17.4-linux-x64.tar.xz
RUN tar -xvf node-v14.17.4-linux-x64.tar.xz && mv node-v14.17.4-linux-x64 /usr/node && rm -f node-v14.17.4-linux-x64.tar.xz
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --upgrade pip
RUN pip install Cython --install-option="--no-cython-compile"
RUN npm i yarn -g && npm i cnpm -g
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN echo "alias ll='ls -l'" >> ~/.bashrc
CMD /bin/bash
