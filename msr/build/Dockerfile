FROM sagcr.azurecr.io/webmethods-microservicesruntime:10.15.0.14-ubi AS builder

ADD --chown=sagadmin:sagadmin wpm /opt/softwareag/wpm
RUN chmod u+x /opt/softwareag/wpm/bin/wpm.sh
ENV PATH=/opt/softwareag/wpm/bin:$PATH

ENV JAVA_UHM_OPTS="-javaagent:./packages/WmE2EMIntegrationAgent/resources/agent/uha-apm-agent.jar=logging.dir=./logs/ -Xbootclasspath/a:./packages/WmE2EMIntegrationAgent/resources/agent/uha-apm-agent.jar"
ENV JAVA_CUSTOM_OPTS="${JAVA_CUSTOM_OPTS} ${JAVA_UHM_OPTS}"
ENV JAVA_UHM_LOG_OPTS="-Dlogback.configurationFile=./packages/WmE2EMIntegrationAgent/resources/agent/config/e2ecustomlogback.xml"
ENV JAVA_CUSTOM_OPTS="${JAVA_CUSTOM_OPTS} ${JAVA_UHM_LOG_OPTS}"	

ARG WPM_TOKEN

WORKDIR /opt/softwareag/wpm
RUN /opt/softwareag/wpm/bin/wpm.sh install -wr licensed -j $WPM_TOKEN -ws https://packages.webmethods.io -d /opt/softwareag/IntegrationServer WmJDBCAdapter:v10.3.4.20
RUN /opt/softwareag/wpm/bin/wpm.sh install -wr supported -j $WPM_TOKEN -ws https://packages.webmethods.io -d /opt/softwareag/IntegrationServer WmStreaming:latest
WORKDIR /

RUN curl https://jdbc.postgresql.org/download/postgresql-42.7.4.jar --output /opt/softwareag/IntegrationServer/packages/WmJDBCAdapter/code/jars/postgresql-42.7.4.jar

USER root 

RUN chgrp -R root /opt/softwareag && chmod -R g=u /opt/softwareag


FROM redhat/ubi9

ENV JAVA_HOME=/opt/softwareag/jvm/jvm/ \
    JRE_HOME=/opt/softwareag/jvm/jvm/ \
    JDK_HOME=/opt/softwareag/jvm/jvm/

RUN yum -y update ;\
    yum -y install \
        procps \
        shadow-utils \
        findutils \
        nmap-ncat \
        ;\
    yum clean all ;\
    rm -rf /var/cache/yum ;\
    useradd -u 1724 -m -g 0 -d /opt/softwareag sagadmin ;\
    chmod 770 /opt/softwareag

COPY --from=builder /opt/softwareag /opt/softwareag

USER sagadmin

EXPOSE 5555
EXPOSE 9999
EXPOSE 5553

ENTRYPOINT "/bin/bash" "-c" "/opt/softwareag/IntegrationServer/bin/startContainer.sh"
