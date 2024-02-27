FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y curl unzip locales

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN useradd -m -s /bin/bash openolat

WORKDIR /home/openolat

USER openolat

RUN curl -O https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.13/bin/apache-tomcat-10.1.13.tar.gz --output-dir ./downloads --create-dirs \
    && tar -xzf ./downloads/apache-tomcat-10.1.13.tar.gz \
    && ln -s apache-tomcat-10.1.13 tomcat \
    && rm -r ./downloads

RUN curl -OL https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8.1%2B1/OpenJDK17U-jre_x64_linux_hotspot_17.0.8.1_1.tar.gz --output-dir ./downloads --create-dirs \
    && tar -xzf ./downloads/OpenJDK17U-jre_x64_linux_hotspot_17.0.8.1_1.tar.gz \
    && ln -s jdk-17.0.8.1+1-jre jre \
    && rm -r ./downloads

RUN curl -O https://www.openolat.com/releases/openolat_1810.war --output-dir ./downloads --create-dirs \
    && unzip -d openolat-18.1.0 ./downloads/openolat_1810.war \
    && ln -s openolat-18.1.0 webapp \
    && rm -r ./downloads

RUN mkdir bin conf lib run logs

WORKDIR /home/openolat/conf
RUN ln -s ../tomcat/conf/web.xml web.xml

WORKDIR /home/openolat/bin
RUN ln -s ../tomcat/bin/catalina.sh catalina.sh

WORKDIR /home/openolat
RUN ln -s tomcat/bin/startup.sh start
RUN ln -s tomcat/bin/shutdown.sh stop

COPY ./setenv.sh ./bin/setenv.sh
COPY ./server.xml ./conf/server.xml

ENV CATALINA_BASE /home/openolat
ENV CATALINA_HOME /home/openolat/tomcat
ENV JRE_HOME /home/openolat/jre

ENV DB_PASSWORD default
ENV DB_URL jdbc:postgresql://localhost:5432/oodb
ENV OLAT_HOST localhost
ENV EXTRA_PROPERTIES none

COPY ./ROOT.xml /home/openolat/tmp-ROOT.xml

COPY ./olat.local.properties /home/openolat/lib/olat.local.properties

COPY ./entrypoint.sh /home/openolat/entrypoint.sh

EXPOSE 8088

CMD [ "bash", "-c", "/home/openolat/entrypoint.sh" ]
