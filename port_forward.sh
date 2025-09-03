#!/bin/bash
trap 'kill 0' SIGINT

kubectl port-forward svc/ingress-nginx-controller -n ingress-nginx 8080:80 &
kubectl port-forward svc/raven-setup-clickhouse -n default 8123:8123 &
kubectl port-forward svc/raven-setup-flink-rest -n default 8081:8081 &
kubectl port-forward svc/raven-setup-postgresql -n default 5432:5432 &
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80 &
kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090 &
kubectl port-forward svc/raven-setup-kafka-ui -n default 8000:80 &
kubectl port-forward svc/raven-setup-kafka-controller-0-external 30001:9094 &
kubectl port-forward svc/raven-setup-kafka-controller-1-external 30002:9094 &
kubectl port-forward svc/raven-setup-kafka-controller-2-external 30003:9094 &
kubectl port-forward svc/raven-dashboard-service 5173:5173 &

wait
