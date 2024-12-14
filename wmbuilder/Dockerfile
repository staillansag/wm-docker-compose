FROM registry.access.redhat.com/ubi9/ubi:latest

RUN yum -y update ;\
    yum -y install \
        procps \
        shadow-utils \
        findutils \
        nmap-ncat \
        ;\
    yum clean all ;\
    rm -rf /var/cache/yum ;\
    useradd -u 1724 -m -g 0 -d /opt/webmethods wm

RUN chmod 770 /opt/webmethods

USER wm

EXPOSE 5555
EXPOSE 9999
EXPOSE 5553

ENTRYPOINT "/bin/bash" 