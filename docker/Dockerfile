FROM angegar/hybris-base-image:0.0.1
#FROM stefanlehmann/hybris-base-image:latest as buildcontainer2
MAINTAINER laurent.gil@dxc.com

ENV HYBRIS_VERSION 6.5.0.0

# copy the entrypoint script over
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# copy the build packages over
COPY hybrisServer*.zip $HYBRIS_HOME/

# copy the update system config to image
COPY updateRunningSystem.config $HYBRIS_HOME/updateRunningSystem.config

#COPY local.properties $HYBRIS_HOME/config/local.properties

WORKDIR  $HYBRIS_HOME

RUN echo $HYBRIS_HOME \
    && for z in hybrisServer*.zip; do unzip $z -d $(dirname $HYBRIS_HOME) ; done \
    && ls -al $HYBRIS_HOME \
    && cd $HYBRIS_HOME/bin/platform \
    && . ./setantenv.sh \
    && ant clean all \
    && chown -R hybris $HYBRIS_HOME \
    && chmod +x hybrisserver.sh \
    && rm -f $HYBRIS_HOME/hybrisServer*.zip

# set entrypoint of container
ENTRYPOINT ["/entrypoint.sh"]

CMD ["run"]