```
mkdir steve || exit 1
cd steve/
git clone https://github.com/sjbylo/example-voting-app
oc new-project my-vote-app 

oc new-build --binary python:2.7-alpine --name vote 
oc start-build vote --from-dir=vote
oc new-app vote --name vote
oc expose svc/vote 

oc new-build --binary node:8.9-alpine --name result
oc start-build result --from-dir=result
oc new-app result 
oc expose svc/result

oc new-app postgres:9.4 --name=db 

oc adm policy add-scc-to-user anyuid -z default
oc login -u system:admin 
oc adm policy add-scc-to-user anyuid -z default
oc login -u rahul -p redhat

oc new-app redis:alpine --name=redis 

oc new-build --binary microsoft/dotnet:2.0.0-sdk --name worker
oc start-build worker --from-dir=worker
oc new-app worker --name worker

oc export bc,dc,svc,route,is --as-template=my-vote-app > my-vote-app.yaml

----

psql --username=postgres

postgres=# \dt
         List of relations
 Schema | Name  | Type  |  Owner   
--------+-------+-------+----------
 public | votes | table | postgres
(1 row)

postgres=# select * from votes;
        id        | vote 
------------------+------
 1004bb9b5919a51a | a
 8eb089c0f4efe21a | d
 2c5345eba06121dc | d
(3 rows)


```
