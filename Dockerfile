FROM node:4.1.1
RUN npm install -g elm
ENV ELM_HOME /usr/local/lib/node_modules/elm/share
RUN mkdir /data
WORKDIR /data
ADD . /data
RUN elm-make --yes
