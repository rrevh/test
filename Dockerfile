FROM java:8-jre

MAINTAINER rrh
#FROM http://diethardsteiner.github.io/pdi/2016/04/21/PDI-Docker-Part-1.html

# Set required environment vars
ENV PDI_RELEASE=6.1 \
    PDI_VERSION=6.1.0.1-196 \
    PENTAHO_JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    PENTAHO_HOME=/home/pentaho

# Create user
RUN mkdir ${PENTAHO_HOME} && \
    groupadd -r pentaho && \
    useradd -s /bin/bash -d ${PENTAHO_HOME} -r -g pentaho pentaho && \
    chown pentaho:pentaho ${PENTAHO_HOME}

# Add files
#RUN mkdir $PENTAHO_HOME/docker-entrypoint.d 

RUN chown -R pentaho:pentaho $PENTAHO_HOME 
USER pentaho

# Download PENTAHO SERVER
RUN /usr/bin/wget \
    --progress=dot:giga \
    http://downloads.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/${PDI_RELEASE}/biserver-ce-${PDI_VERSION}.zip \
    -O /tmp/biserver-ce-${PDI_VERSION}.zip && \
    /usr/bin/unzip -q /tmp/biserver-ce-${PDI_VERSION}.zip -d  $PENTAHO_HOME && \
    rm /tmp/biserver-ce-${PDI_VERSION}.zip

ENV KETTLE_HOME=$PENTAHO_HOME/biserver-ce \
PATH=$KETTLE_HOME:$PATH

WORKDIR $KETTLE_HOME

#ENTRYPOINT ["../scripts/docker-entrypoint.sh"]
