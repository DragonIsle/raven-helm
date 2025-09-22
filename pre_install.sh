#!/bin/bash

helm repo add jetstack https://charts.jetstack.io
helm repo add flink-operator https://archive.apache.org/dist/flink/flink-kubernetes-operator-1.12.0/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add cnpg https://cloudnative-pg.github.io/charts

helm repo update

helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --set installCRDs=true \
  --create-namespace

helm install flink-operator flink-operator/flink-kubernetes-operator --namespace default

helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace

helm upgrade --install loki grafana/loki -n monitoring --reset-values -f loki-values.yaml
helm upgrade --install promtail grafana/promtail \
  -n monitoring \
  --set "config.clients[0].url=http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push"

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.service.type=ClusterIP

helm install raven-setup-postgresql cnpg/cloudnative-pg

