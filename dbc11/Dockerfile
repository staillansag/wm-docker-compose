FROM redhat/ubi9 AS builder

ARG INSTALLER_USERNAME
ARG INSTALLER_PASSWORD
ARG INSTALLER_PRODUCTS
ARG INSTALLER_FIXES

RUN yum -y update ;\
    yum -y install \
        procps \
        ;\
    yum clean all ;\
    rm -rf /var/cache/yum ;\
    useradd -u 1724 -m -g 0 -d /opt/webmethods wm

RUN chmod 770 /opt/webmethods && mkdir /opt/source
ADD --chown=wm:root installer.bin /opt/source/installer.bin
ADD --chown=wm:root dbc.script /opt/source/dbc.script
RUN chmod u+x /opt/source/installer.bin

RUN echo "InstallProducts=${INSTALLER_PRODUCTS}" >> /opt/source/dbc.script
RUN echo "selectedFixes=${INSTALLER_FIXES}" >> /opt/source/dbc.script
RUN echo "Username=${INSTALLER_USERNAME}" >> /opt/source/dbc.script
RUN echo "Password=${INSTALLER_PASSWORD}" >> /opt/source/dbc.script

USER wm

RUN /opt/source/installer.bin -readScript /opt/source/dbc.script

RUN rm -rf /opt/webmethods/install/fix/backup/*
RUN rm -rf /opt/webmethods/SAGUpdateManager

USER root 

RUN chgrp -R root /opt/webmethods && chmod -R g=u /opt/webmethods


FROM redhat/ubi9

ENV JAVA_HOME=/opt/webmethods/jvm/jvm/ \
    JRE_HOME=/opt/webmethods/jvm/jvm/ \
    JDK_HOME=/opt/webmethods/jvm/jvm/ \
    PATH=$PATH:/opt/webmethods/common/db/bin

RUN yum -y update ;\
    yum -y install \
        procps \
        shadow-utils \
        findutils \
        nmap-ncat \
        ;\
    yum clean all ;\
    rm -rf /var/cache/yum ;\
    useradd -u 1724 -m -g 0 -d /opt/webmethods wm ;\
    chmod 770 /opt/webmethods

COPY --from=builder /opt/webmethods /opt/webmethods

USER wm

EXPOSE 5555
EXPOSE 9999
EXPOSE 5553

CMD ["/bin/bash"]
