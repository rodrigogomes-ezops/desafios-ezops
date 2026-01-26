#!/bin/sh
set -e

# Substitui a variável de ambiente PROMETHEUS_URL no arquivo de datasource
if [ -n "$PROMETHEUS_URL" ]; then
  echo "Configurando Prometheus URL: $PROMETHEUS_URL"
  sed -i "s|\${PROMETHEUS_URL:-http://prometheus-service:9090}|$PROMETHEUS_URL|g" /etc/grafana/provisioning/datasources/prometheus.yml
else
  echo "Usando URL padrão do Prometheus: http://prometheus-service:9090"
fi

# Executa o entrypoint padrão do Grafana
exec /run.sh "$@"

