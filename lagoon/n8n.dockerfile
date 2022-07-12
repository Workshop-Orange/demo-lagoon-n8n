FROM uselagoon/node-16

ARG N8N_VERSION=latest

WORKDIR /app

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata git tini su-exec

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python3 build-base ca-certificates && \
	npm config set python "$(which python3)" && \
	npm_config_user=root npm install -g full-icu n8n@${N8N_VERSION} && \
	apk del build-dependencies \
	&& rm -rf /root /tmp/* /var/cache/apk/* && mkdir /root;

# Install fonts
RUN apk --no-cache add --virtual fonts msttcorefonts-installer fontconfig && \
	update-ms-fonts && \
	fc-cache -f && \
	apk del fonts && \
	find  /usr/share/fonts/truetype/msttcorefonts/ -type l -exec unlink {} \; \
	&& rm -rf /root /tmp/* /var/cache/apk/* && mkdir /root

ENV NODE_ICU_DATA /usr/local/lib/node_modules/full-icu

ENV N8N_PORT 3000
ENV N8N_PROTOCOL http

ENV DB_TYPE mysqldb 
ENV DB_MYSQLDB_DATABASE lagoon
ENV DB_MYSQLDB_HOST mariadb
ENV DB_MYSQLDB_PORT 3306 
ENV DB_MYSQLDB_USER lagoon
ENV DB_MYSQLDB_PASSWORD lagoon 


#COPY docker-entrypoint.sh /docker-entrypoint.sh
#ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

EXPOSE 3000

COPY lagoon/n8n-entrypoint.sh /lagoon/entrypoints/71-n8n-entrypoint

CMD ["n8n","start"]
