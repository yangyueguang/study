FROM python:3.8
MAINTAINER xuechao <2829969299@qq.com>
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ADD app /app
RUN pip install -U -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --upgrade pip
RUN pip install --no-cache-dir -r /apps/requirs.txt -i https://pypi.douban.com/simple/ && rm -rf /root/.cache
# 1. install ssh 这样可以支持远程debug
RUN apt-get update && apt-get -y install openssh-server
RUN mkdir -p /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

WORKDIR /app
EXPOSE 8000
CMD gunicorn run:app -c config.py
