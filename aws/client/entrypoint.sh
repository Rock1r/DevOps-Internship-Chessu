#!/bin/sh

otelcol --config=/etc/otel/config.yaml &

NODE_OPTIONS="--require /opt/chessu/server/instrumentation.js"
pnpm start --filter server
