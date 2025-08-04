#!/bin/sh

export NODE_OPTIONS="--require /opt/chessu/server/instrumentation.js"

otelcol --config=/etc/otel/config.yaml &

exec pnpm --filter server start >> /tmp/app.log 2>&1
