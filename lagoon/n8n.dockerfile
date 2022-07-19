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
ENV N8N_USER_FOLDER /app/storage
ENV EXECUTIONS_DATA_PRUNE true

ENV DB_TYPE mysqldb 

EXPOSE 3000

COPY /app /app
COPY lagoon/n8n-entrypoint.sh /lagoon/entrypoints/71-n8n-entrypoint

CMD ["/app/start-n8n-simple"]
