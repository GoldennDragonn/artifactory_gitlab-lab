#!/bin/bash

set -e

echo "Getting artifactory container ID after it was created"

con_id=$(docker container ls --all --quiet --filter 'name=artifactory*')

echo "Let me accept an EULA agreement for you"

docker exec -it "${con_id}" curl -XPOST -vu admin:password "http://$1:8082/artifactory/ui/jcr/eula/accept"

echo "EULA agreement has been accepted, let's continue"
