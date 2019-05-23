FROM centos:7.5.1804 as BASE

WORKDIR /root/preliminary

ARG REPO=repolist.txt
ARG SYS_DEPS=packages.txt
ARG PY_DEPS=python_libs.txt

ADD dependencies .

RUN xargs --arg-file $REPO yum install -y &&\
    xargs --arg-file $REPO yum-config-manager --enable &&\
    xargs --arg-file $SYS_DEPS yum install -y &&\
    xargs --arg-file $REPO yum -y remove &&\
    yum clean all &&\
    python -m pip install --upgrade pip &&\
    python -m pip install --requirement $PY_DEPS ;\
    rm -rf /root/preliminary \
           /var/cache/yum ;


FROM BASE

WORKDIR /root/scripts

ADD scripts/ .

ENTRYPOINT ["/root/scripts/run.sh"]

