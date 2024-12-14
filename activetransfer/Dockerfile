FROM registry.access.redhat.com/ubi9/ubi:latest AS builder

RUN yum -y update ;\
    yum -y install \
        procps \
        ;\
    yum clean all ;\
    rm -rf /var/cache/yum ;\
    useradd -u 1724 -m -g 0 -d /opt/webmethods wm

RUN chmod 770 /opt/webmethods && mkdir /opt/updatemanager && chown wm:root /opt/updatemanager && mkdir /opt/source && chown wm:root /opt/source
ADD --chown=wm:root startContainer.sh /opt/source/startContainer.sh
ADD --chown=wm:root installer.bin /opt/source/installer.bin
ADD --chown=wm:root at.script /opt/source/at.script
ADD --chown=wm:root licenses /opt/source/licenses
ADD --chown=wm:root SAGUpdateManagerInstaller.bin /opt/source/SAGUpdateManagerInstaller.bin
ADD --chown=wm:root at-update.script /opt/source/at-update.script
RUN chmod u+x /opt/source/*.bin 

USER wm

RUN /opt/source/installer.bin -readScript /opt/source/at.script

RUN /opt/source/SAGUpdateManagerInstaller.bin --accept-license -d /opt/updatemanager
RUN /opt/updatemanager/bin/UpdateManagerCMD.sh -readScript /opt/source/at-update.script

USER root 

RUN cp /opt/source/startContainer.sh /opt/webmethods/IntegrationServer/bin/startContainer.sh && chmod +x /opt/webmethods/IntegrationServer/bin/startContainer.sh
ENV INSTANCE_NAME=default

RUN rm -rf /opt/webmethods/install 
RUN rm -rf /opt/webmethods/jvm/jvm*.bck
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/config/backup/*
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/packages/WmMFT/resources/backup/*
RUN rm -rf /opt/webmethods/SAGUpdateManager
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/config/backup/*
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/config/jdbc/pool/mft.xml
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/config/jdbc/pool/cds.xml
RUN rm -rf /opt/webmethods/IntegrationServer/instances/default/config/jdbc/properties/*

RUN rm -f /opt/webmethods/IntegrationServer/config/licenseKey.xml
RUN rm -f /opt/webmethods/IntegrationServer/instances/default/config/licenseKey.xml
RUN rm -f /opt/webmethods/IntegrationServer/instances/default/config/backup/licenseKey.xml
RUN rm -f /opt/webmethods/IntegrationServer/instances/default/packages/WmMFT/config/licenseKey.xml
RUN rm -f /opt/webmethods/IntegrationServer/packages/WmMFT/config/licenseKey.xml

RUN find /opt/webmethods -type f -name '.lock' -exec rm {} \;

RUN chgrp -R root /opt/webmethods && chmod -R g=u /opt/webmethods


FROM registry.access.redhat.com/ubi9/ubi:latest

ENV JAVA_HOME=/opt/webmethods/jvm/jvm/ \
    JRE_HOME=/opt/webmethods/jvm/jvm/ \
    JDK_HOME=/opt/webmethods/jvm/jvm/ \
    INSTANCE_NAME=default

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
COPY --from=builder /opt/webmethods /opt/webmethods

USER wm

EXPOSE 5555
EXPOSE 9999
EXPOSE 5553

ENTRYPOINT "/bin/bash" "-c" "/opt/webmethods/IntegrationServer/bin/startContainer.sh"