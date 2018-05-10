#!/bin/bash -x

# Run OpenShift and log in with oc
# Run git clone and cd commands before running this script with "bash gorh.sh"
#git clone https://github.com/sjbylo/example-voting-app
#cd example-voting-app 

oc new-project my-vote-app || exit 1

oc new-app \
	-e POSTGRESQL_USER=postgres \
	-e POSTGRESQL_PASSWORD=pw \
	-e POSTGRESQL_DATABASE=postgres \
registry.access.redhat.com/rhscl/postgresql-94-rhel7 --name db

oc new-app registry.access.redhat.com/rhscl/redis-32-rhel7 --name=redis

# Start builds in the background 
(
	oc new-build --binary registry.access.redhat.com/rhscl/python-27-rhel7 --name vote
	sleep 5
	oc start-build vote --from-dir=vote -w
	oc new-app vote --name vote
) & 

(
	#oc new-build --binary node:8.9-alpine --name result
	oc new-build --binary registry.access.redhat.com/rhscl/nodejs-6-rhel7 --name result
	sleep 5
	oc start-build result --from-dir=result -w
	oc new-app result  --name result 
) & 

(
	oc new-build --binary microsoft/dotnet:2.0.0-sdk --name worker
	#oc new-build --binary registry.access.redhat.com/dotnet/dotnet-20-runtime-rhel7 --name worker
	sleep 5
	oc start-build worker --from-dir=worker -w
	oc new-app worker --name worker
) & 

wait

oc expose svc/vote 
oc expose svc/result

# Wait for all to roll out
while ! ( oc rollout status dc/vote && oc rollout status dc/result && oc rollout status dc/worker ); do sleep 1; done

