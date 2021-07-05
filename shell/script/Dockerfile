FROM centos:latest
USER root
ENV PATH=$PATH:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN yum install -y langpacks-zh_CN && echo "LANG=zh_CN.utf8" > /etc/locale.conf
RUN yum install -y wget unzip cronie crontabs python3 nginx openssl gcc automake autoconf libtool make
RUN wget --no-cache https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
    yum localinstall -y google-chrome-stable_current_x86_64.rpm
RUN wget http://chromedriver.storage.googleapis.com/83.0.4103.39/chromedriver_linux64.zip && \
    unzip -d /usr/local/bin chromedriver_linux64.zip
COPY project /project
COPY scrapy.cfg /scrapy.cfg
RUN pip3 install -r /project/require.txt -i https://pypi.douban.com/simple/
####################### 翻墙 ############################
RUN mkdir -p /etc/privoxy && mkdir -p /install
COPY privoxy.tar.gz /install/
COPY shadowsocks.json /etc/
RUN cd /install && tar -zxvf privoxy.tar.gz && cd privoxy-3.0.28-stable && autoheader && autoconf && ./configure && make && useradd privoxy -r -s /usr/sbin/nologin && make install
RUN pip3 install -U -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --upgrade pip
RUN pip3 install shadowsocks
RUN echo 'export http_proxy=http://127.0.0.1:8118'   >> /etc/profile
RUN echo 'export https_proxy=https://127.0.0.1:8118' >> /etc/profile
RUN echo 'forward-socks5t   /     127.0.0.1:1080 .'  >> /etc/privoxy/config
RUN echo 'PATH=$PATH:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin' >> ~/.bashrc
RUN echo 'source /etc/profile' >>  ~/.bashrc
RUN crond
RUN privoxy /etc/privoxy/config
RUN nohup sslocal -c /etc/shadowsocks.json /dev/null 2>&1 &
####################### 翻墙 ############################
WORKDIR /project
VOLUME /project/data
RUN crontab /project/crontab.txt
#CMD /sbin/crond start && tail -f /project/data/root.log
ENTRYPOINT ["/usr/sbin/init"]
# CMD /usr/local/nginx/sbin/nginx -g "daemon off;"
