FROM centos:7.5.1804 as BASE

ARG python
ARG DEFAULT_PYTHON_VERSION=2
ENV PYTHON_VERSION ${python:-$DEFAULT_PYTHON_VERSION}

ARG REPO=repolist.txt
ARG PYTHON_DEPS=python_libs.txt
ENV SYSTEM_DEPS python$PYTHON_VERSION

WORKDIR /root/preliminary
ADD dependencies .

RUN xargs --arg-file $REPO yum install -y\
    && xargs --arg-file $REPO yum-config-manager --enable\
    && xargs --arg-file $SYSTEM_DEPS yum install -y\
    && yum clean all\
    && ln -sfv /usr/bin/python$PYTHON_VERSION /usr/bin/python\
    && python -m pip install --upgrade pip\
    && python -m pip install --requirement $PYTHON_DEPS ;\
    rm -rf /root/preliminary\
           /var/cache/yum ;


FROM BASE

WORKDIR /root/scripts
ADD scripts/ .

ADD mibs/* /usr/share/snmp/mibs/

ENTRYPOINT ["/bin/bash", "/root/scripts/run_simple_agent_over_tcpsocket.sh"]

