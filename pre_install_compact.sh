helm upgrade --install raven-setup-dragonfly oci://ghcr.io/dragonflydb/dragonfly/helm/dragonfly --version v1.33.1

helm repo add cnpg https://cloudnative-pg.github.io/charts
helm repo update
helm install raven-setup-postgresql cnpg/cloudnative-pg
cat <<EOF | kubectl apply -f -
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: raven-setup
spec:
  instances: 3
  storage:
    size: 1Gi
EOF

kubectl get secret raven-setup-app -o jsonpath='{.data.password}' | base64 --decode

helm install raven-setup-clickhouse bitnami/clickhouse