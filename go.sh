#!/bin/bash -xe 

git clone https://github.com/sjbylo/example-voting-app
cd example-voting-app 

oc new-project my-vote-app 

oc new-app postgres:9.4 --name=db 
oc new-app redis:alpine --name=redis 

(
oc new-build --binary python:2.7-alpine --name vote 
oc start-build vote --from-dir=vote -w
) & 

(
oc new-build --binary node:8.9-alpine --name result
oc start-build result --from-dir=result -w
) & 

(
oc new-build --binary microsoft/dotnet:2.0.0-sdk --name worker
oc start-build worker --from-dir=worker -w
) & 

wait 

oc new-app vote --name vote

oc new-app worker --name worker

oc new-app result  --name result 

oc expose svc/vote 
oc expose svc/result

# Wait for all to roll out
while ! ( oc rollout status dc/vote && oc rollout status dc/result && oc rollout status dc/worker ); do sleep 1; done

while ! oc rollout status dc/vote && oc rollout status dc/result && oc rollout status dc/worker
do
	sleep 1
done

