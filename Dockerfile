FROM centos:7.5.1804 as BASE

WORKDIR /root/preliminary

ARG repo=repolist.txt
ARG deps=packages.txt

ADD dependencies .

RUN xargs --arg-file $repo yum install -y &&\
    xargs --arg-file $repo yum-config-manager --enable &&\
    xargs --arg-file $deps yum install -y &&\
    python -m pip install --upgrade pip &&\
    python -m pip install netsnmpagent &&\
    xargs --arg-file $repo yum -y remove &&\
    yum clean all &&\
    rm -rf /root/preliminary \
           /var/cache/yum


FROM BASE

WORKDIR /root/scripts

ADD scripts/ .

ENTRYPOINT ["/root/scripts/run.sh"]

