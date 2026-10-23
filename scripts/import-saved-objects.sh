#!/bin/sh
set -eu
KIBANA_URL="${KIBANA_URL:-http://kibana:5601}"
ELASTICSEARCH_URL="${ELASTICSEARCH_URL:-http://elasticsearch:9200}"

attempt=0
until curl -fsS "$KIBANA_URL/api/status" >/dev/null; do
  attempt=$((attempt + 1))
  if [ "$attempt" -ge 120 ]; then
    exit 1
  fi
  sleep 5
done

attempt=0
until curl -fsS "$ELASTICSEARCH_URL/springboot-*/_count" | grep -Eq '"count":[1-9][0-9]*'; do
  attempt=$((attempt + 1))
  if [ "$attempt" -ge 120 ]; then
    exit 1
  fi
  sleep 5
done

curl -fsS -X POST "$KIBANA_URL/api/saved_objects/_import?overwrite=true" \
  -H 'kbn-xsrf: true' \
  -F file=@/saved-objects/saved-objects.ndjson
curl -fsS -X POST "$KIBANA_URL/api/data_views/data_view/springboot-logs" \
  -H 'kbn-xsrf: true' \
  -H 'Content-Type: application/json' \
  -d '{"data_view":{"title":"springboot-*","name":"Spring Boot logs","timeFieldName":"@timestamp","allowNoIndex":false},"refresh_fields":true}'
curl -fsS -X POST "$KIBANA_URL/api/data_views/default" \
  -H 'kbn-xsrf: true' \
  -H 'Content-Type: application/json' \
  -d '{"data_view_id":"springboot-logs"}'
