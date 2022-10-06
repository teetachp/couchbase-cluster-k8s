### Install / Uninstall Couchbase Autonomous and CouchbaseCluster
Install the Operator on K8S
```
./secret.sh

kubectl create -f cluster/crd.yaml
kubectl apply -f cluster/sc.yaml

bin/cao create admission -n couchbase
bin/cao create operator -n couchbase

kubectl apply -f cluster/nonprod/secret.yaml -n couchbase
kubectl apply -f cluster/nonprod/cb-cluster-nonprod.yaml -n couchbase

```
Uninstall the Operator on K8S
```
kubectl delete -f cluster/nonprod/secret.yaml -n couchbase
kubectl delete -f cluster/nonprod/cb-cluster-nonprod.yaml -n couchbase

bin/cao delete admission -n couchbase
bin/cao delete operator -n couchbase

kubectl delete -f cluster/sc.yaml
kubectl delete -f cluster/crd.yaml
```

### Add / Remove Server
We control add / remove server from specific the number of server size in couchbase-cluster.yaml file

### Generate work load for specific bucket
1. Go inside cluster by the following command 
```
kubectl exec -i -t {{pod_name}} -n couchbase -- /bin/bash
```
2. Excute workloadgen command by running 
```
/opt/couchbase/bin/cbworkloadgen -n cb-example-0000.cb-example.dev.svc:8091 -u Administrator -p password -b workload-bucket
```
for JSON
```
/opt/couchbase/bin/cbworkloadgen -n cb-example-0000.cb-example.dev.svc:8091 -u Administrator -p password -b workload-bucket --prefix load_ --json

```
running with infinite loop ( for testing read/write paralelly )
```
/opt/couchbase/bin/cbworkloadgen -n cb-example-0000.cb-example.dev.svc:8091 -u Administrator -p password -b workload-bucket --prefix load_ --json --ration-sets 0.6 --loop
```

### Terminate node manually for testing failover
delete the server pod 
```
kubectl delete {{pod_name}} -n couchbase
```

### Import data from csv to couchbase cluster

```
kubectl port-forward {{ svc_couchbase_cluster }} -n couchbase 8091:8091

kubectl cp /Users/teetachphaopanus/Desktop/subscribe_profile.json couchbase/prod-cluster-0000:/tmp/

kubectl exec -i -t {{pod_name}} -n couchbase -- /bin/bash

cd /opt/couchbase/bin

cbimport json --format list -c http://localhost:8091 -u couchbase-prod -p GC2UGaMD3zj5MwBe -d 'file://../../../tmp/subscribe_profile.json' -b 'subscribe-prod' --scope-collection-exp "_default.subscribe_profile" -g %ssoid% 
```

### Create/Remove backup instance
```
bin/cao create backup -n couchbase
kubectl apply -f cluster/prod/backup-prod.yaml -n couchbase

kubectl delete -f cluster/prod/backup-prod.yaml -n couchbase
bin/cao delete backup -n couchbase
```

### Monitor backup
```
kubectl get couchbasebackup prod-backup -o yaml -n couchbase
```

### Restore backup
```
kubectl apply -f cluster/prod/restore.yaml -n couchbase
```