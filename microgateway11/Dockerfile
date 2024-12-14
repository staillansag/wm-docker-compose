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
ADD --chown=wm:root mcgw.script /opt/source/mcgw.script
RUN chmod u+x /opt/source/installer.bin
ADD --chown=wm:root docker-entrypoint.sh /opt/webmethods/Microgateway/docker-entrypoint.sh
RUN chmod +x /opt/webmethods/Microgateway/docker-entrypoint.sh

RUN echo "InstallProducts=${INSTALLER_PRODUCTS}" >> /opt/source/mcgw.script
RUN echo "selectedFixes=${INSTALLER_FIXES}" >> /opt/source/mcgw.script
RUN echo "Username=${INSTALLER_USERNAME}" >> /opt/source/mcgw.script
RUN echo "Password=${INSTALLER_PASSWORD}" >> /opt/source/mcgw.script

USER wm

RUN /opt/source/installer.bin -readScript /opt/source/mcgw.script

RUN rm -rf /opt/webmethods/install/fix/backup/*
RUN rm -rf /opt/webmethods/SAGUpdateManager
RUN rm -rf /opt/webmethods/IntegrationServer
RUN rm -rf /opt/webmethods/UniversalMessaging
RUN rm -rf /opt/webmethods/WS-Stack
RUN rm -rf /opt/webmethods/apigatewayui
RUN rm -rf /opt/webmethods/bin
RUN rm -rf /opt/webmethods/common
RUN rm -rf /opt/webmethods/install
RUN rm -rf /opt/webmethods/jvm
RUN rm -rf /opt/webmethods/Microgateway/microgateway-jre-linux-musl 
RUN rm -rf /opt/webmethods/Microgateway/microgateway-jre-win
RUN rm -rf /opt/webmethods/Microgateway/microgateway.bat

USER root 

RUN chgrp -R root /opt/webmethods && chmod -R g=u /opt/webmethods

FROM redhat/ubi9

ENV PATH=$PATH:/opt/webmethods/Microgateway

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

WORKDIR /opt/webmethods/Microgateway

EXPOSE 4485

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["-p", "4485", "-lv", "ERROR"]
