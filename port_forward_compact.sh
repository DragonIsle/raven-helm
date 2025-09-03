#!/bin/bash
trap 'kill 0' SIGINT

PG_PW=$(kubectl get secret raven-setup-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
CH_PW=$(kubectl get secret raven-setup-clickhouse -o jsonpath="{.data.admin-password}" | base64 -d)
REDIS_PW=$(kubectl get secret --namespace default raven-setup-redis -o jsonpath="{.data.redis-password}" | base64 -d)

echo "PG_PW: $PG_PW"
echo "CH_PW: $CH_PW"
echo "REDIS_PW: $REDIS_PW"

kubectl port-forward svc/raven-compact-service -n default 8080:8080 &
#kubectl port-forward svc/raven-setup-clickhouse -n default 8123:8123 &
#kubectl port-forward svc/raven-setup-postgresql -n default 5432:5432 &
kubectl port-forward svc/raven-dashboard-service 5173:5173 &

wait
