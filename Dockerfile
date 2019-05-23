FROM centos:7.5.1804 as BASE

WORKDIR /root/preliminary

ARG python
ENV PYTHON_VERSION ${python:-2}

ARG REPO=repolist.txt
ARG PYTHON_LIBS=python_libs.txt
ENV SYSTEM_DEPS python$PYTHON_VERSION

ADD dependencies .

RUN xargs --arg-file $REPO yum install -y &&\
    xargs --arg-file $REPO yum-config-manager --enable &&\
    xargs --arg-file $SYSTEM_DEPS yum install -y &&\
    xargs --arg-file $REPO yum -y remove &&\
    yum clean all &&\
    ln -sfv /usr/bin/python$PYTHON_VERSION /usr/bin/python &&\
    python -m pip install --upgrade pip &&\
    python -m pip install --requirement $PYTHON_LIBS ;\
    rm -rf /root/preliminary \
           /var/cache/yum ;


FROM BASE

WORKDIR /root/scripts

ADD scripts/ .

ENTRYPOINT ["/root/scripts/run.sh"]

