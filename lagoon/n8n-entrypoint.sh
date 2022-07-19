#!/bin/sh

echo "Running N8N specific entrypoint"

if [ -d /root/.n8n ] ; then
  chmod o+rx /root
  chown -R node /root/.n8n
  ln -s /root/.n8n /home/node/
fi

echo "Settng N8N_EDITOR_BASE_URL to $LAGOON_ROUTE"
export N8N_EDITOR_BASE_URL=$LAGOON_ROUTE

chown -R node /home/node