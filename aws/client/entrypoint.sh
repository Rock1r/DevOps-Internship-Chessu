#!/bin/sh

export NODE_OPTIONS="--require /chessu/client/instrumentation.js"

otelcol --config=/etc/otel/config.yaml &

exec node client/server.js >> /tmp/app.log 2>&1
