#!/bin/sh
set -e

jar='/prometheus/jmx_prometheus_httpserver-*.jar'
java $JVM_OPTS -jar $jar $SERVICE_PORT $CONFIG_FILE
