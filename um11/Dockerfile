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
ADD --chown=wm:root um.script /opt/source/um.script
RUN chmod u+x /opt/source/installer.bin

RUN echo "InstallProducts=${INSTALLER_PRODUCTS}" >> /opt/source/um.script
RUN echo "selectedFixes=${INSTALLER_FIXES}" >> /opt/source/um.script
RUN echo "Username=${INSTALLER_USERNAME}" >> /opt/source/um.script
RUN echo "Password=${INSTALLER_PASSWORD}" >> /opt/source/um.script

USER wm

RUN /opt/source/installer.bin -readScript /opt/source/um.script

RUN rm -rf /opt/webmethods/install/fix/backup/*
RUN rm -rf /opt/webmethods/SAGUpdateManager

RUN cp /opt/webmethods/UniversalMessaging/tools/docker/configure.sh /opt/webmethods/configure.sh
RUN cp /opt/webmethods/UniversalMessaging/tools/docker/uminitialize.sh /opt/webmethods/uminitialize.sh
RUN cp /opt/webmethods/UniversalMessaging/tools/docker/umstart.sh /opt/webmethods/umstart.sh
RUN cp /opt/webmethods/UniversalMessaging/tools/docker/log4j2.xml /opt/webmethods/UniversalMessaging/lib/classes/log4j2.xml

RUN chmod u+x /opt/webmethods/configure.sh ; /opt/webmethods/configure.sh
RUN chmod u+x /opt/webmethods/uminitialize.sh
RUN chmod u+x /opt/webmethods/umstart.sh

RUN mkdir /opt/webmethods/UniversalMessaging/server/umserver/logs

USER root

RUN chgrp -R root /opt/webmethods && chmod -R g=u /opt/webmethods


FROM redhat/ubi9

ENV SAG_HOME="/opt/webmethods"
ENV JAVA_HOME="/opt/webmethods/jvm/jvm"
ENV JDK_HOME="/opt/webmethods/jvm/jvm"
ENV JRE_HOME="/opt/webmethods/jvm/jvm"
ENV UM_HOME="/opt/webmethods/UniversalMessaging"
ENV PATH="/opt/webmethods/UniversalMessaging/tools/runner:/opt/webmethods/jvm/jvm/bin:/opt/webmethods:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

ENV PORT=9000
ENV JMX_AGENT_PORT=9200
ENV DATA_DIR="/opt/webmethods/UniversalMessaging/server/umserver/data"
ENV LOG_DIR="/opt/webmethods/UniversalMessaging/server/umserver/logs"
ENV LIC_DIR="/opt/webmethods/UniversalMessaging/server/umserver/licence"
ENV USERS_DIR="/opt/webmethods/common/conf"
ENV TOOLS_DIR="/opt/webmethods/UniversalMessaging/tools"
ENV SERVER_COMMON_CONF_FILE=Server_Common.conf
ENV CUSTOM_SERVER_COMMON_CONF_FILE=Custom_Server_Common.conf
ENV INSTANCE_NAME="umserver"


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

WORKDIR /opt/webmethods

VOLUME ["/opt/softwareag/UniversalMessaging/server/umserver/data", \
        "/opt/softwareag/UniversalMessaging/server/umserver/logs", \
        "/opt/softwareag/UniversalMessaging/server/umserver/licence", \
        "/opt/softwareag/common/conf"]

ENTRYPOINT ["/bin/sh", "-c", "umstart.sh"]
EXPOSE 9000/tcp
EXPOSE 9200/tcp

HEALTHCHECK --interval=15s --timeout=30s --start-period=2m \
  CMD curl --fail http://localhost:$PORT/health/ || exit 1