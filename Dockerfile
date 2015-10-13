FROM node:4.1.1
RUN npm install -g elm@2.0.0
ENV ELM_HOME /usr/local/lib/node_modules/elm/share
RUN apt-get update && apt-get install -y \
         locales
RUN dpkg-reconfigure locales && \
        locale-gen C.UTF-8 && \
        update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8
RUN mkdir /data
WORKDIR /data
ADD . /data
RUN elm-make --yes
