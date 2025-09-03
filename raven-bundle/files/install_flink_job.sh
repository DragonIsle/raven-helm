set -e

apt-get update && apt-get install -y jq

echo "Downloading Flink Job (version $FLINK_JOB_VERSION)..."
mkdir -p /jars
ASSET_ID=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/DragonIsle/raven-flink/releases/tags/$FLINK_JOB_VERSION |
  jq --arg NAME "flink-job.jar" '.assets[] | select(.name == $NAME) | .id')
curl --http1.1 --tlsv1.2 -L -o /jars/flink-job.jar -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/octet-stream" "https://api.github.com/repos/DragonIsle/raven-flink/releases/assets/$ASSET_ID"

echo "Waiting for Flink REST API..."
until curl -sf "http://$FLINK_SERVICE:8081/overview"; do
  echo "Still waiting..."
  sleep 5
done
echo "Flink REST API is up!"

echo "Stopping existing Raven flink Job(s)..."
flink list -m "http://${FLINK_SERVICE}:8081" | grep "Raven" | while read -r line; do
  JOB_ID=$(echo "$line" | awk -F ':' '{print $4}' | awk '{print $1}' | xargs)
  JOB_NAME=$(echo "$line" | cut -d ':' -f 3- | xargs)
  echo "Stopping job: $JOB_NAME ($JOB_ID)"
  flink cancel -m "http://${FLINK_SERVICE}:8081" "$JOB_ID"
done

echo "Submitting Flink Job..."
flink run -m "http://${FLINK_SERVICE}:8081" -d /jars/flink-job.jar \
  --config /opt/flink/conf/flink-job.conf --clickhouse.user $CLICKHOUSE_USER --clickhouse.password $CLICKHOUSE_PASSWORD
