#!/bin/bash

docker network create arangodb --subnet 172.28.0.0/16

docker run -d --name arangodb \
  --network arangodb --ip 172.28.3.1 -p 8529:8529 \
  -e ARANGO_ROOT_PASSWORD=test \
  -v $(pwd)/server.pem:/server.pem docker.io/arangodb/arangodb:3.5.2 \
  arangod --ssl.keyfile /server.pem --server.endpoint ssl://0.0.0.0:8529

docker run --name nifi \
  --network arangodb -p 8080:8080 -p 9999:9999 \
  -v $(pwd)/../nifi-arangodb-nar/target/nifi-arangodb-nar-1.0.1.nar:/opt/nifi/nifi-1.9.2/lib/nifi-arangodb-nar-1.0.1.nar \
  -v $(pwd)/example.truststore:/example.truststore \
  apache/nifi:1.9.2

