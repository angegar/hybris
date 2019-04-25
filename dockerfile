FROM stefanlehmann/hybris-base-image:latest as buildcontainer
MAINTAINER laurent.gil@dxc.com

#ENV HYBRIS_VERSION 6.5.0.0
WORKDIR /tmp

ENV ZIP_FILE=hybrisServer_demo.zip
# download hybris
#RUN curl --location --silent -u "USER:PASSWORD" \
#"https://nexus.YOURCOMPANY.com/nexus/repository/thirdparty/de/hybris/platform/hybris-commerce-suite/$HYBRIS_VERSION/hybris-commerce-suite-$HYBRIS_VERSION.zip" \
#-o "hybris-commerce-suite-$HYBRIS_VERSION.zip"

# if you get the zip from build context you can of course copy it into the buildcontainer directly
COPY $ZIP_FILE .

# add custom settings from build context (optional)
COPY custom.properties installer/customconfig/custom.properties

# build production zips
RUN unzip -qq $ZIP_FILE \
&& cd installer \
&& chmod +x install.sh \
&& ./install.sh -r b2c_acc \
&& cd ../hybris/bin/platform \
&& curl -LO https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.zip \
&& unzip --qq mysql-connector-java-5.1.47.zip && cp mysql-connector-java*/*.jar lib/dbdriver \
&& . ./setantenv.sh \
&& ant clean all production

# build real image
FROM stefanlehmann/hybris-base-image:latest
COPY --from=buildcontainer /tmp/hybris/temp/hybris/hybrisServer/*.zip /home/hybris/