# Single Node OpenShift (SNO)

## Set ClusterID
```
 oc edit clusterversions.config.openshift.io
```

## Setup `oc` from dump dir
```
export KUBECONFIG=$(pwd)/dump/sno/auth/kubeconfig
```

## Recover etcd to single instance
```
cp /etc/kubernetes/static-pod-resources/etcd-certs/configmaps/restore-etcd-pod/pod.yaml /tmp/recover.yaml

# Edit /tmp/recover.yaml
```

```
spec:
  containers:
  - name: etcd-recovery
    command:
      - /bin/sh
      - -c
      - |
        #!/bin/sh
        sleep infinity
```

```
# setup recovery
cp /etc/kubernetes/manifests/etcd-pod.yaml /tmp
cp /tmp/recover.yaml /etc/kubernetes/manifests/etcd-pod.yaml

# get recovery container
POD=$(crictl ps --label io.kubernetes.container.name=etcd-recovery -q)

# force to single node
crictl exec $POD etcd --force-new-cluster

# restore etcd-pod
cp /tmp/etcd-pod.yaml /etc/kubernetes/manifests/etcd-pod.yaml
```

## Recover expired certs
```
export KUBECONFIG=/etc/kubernetes/static-pod-resources/kube-apiserver-certs/secrets/node-kubeconfigs/localhost-recovery.kubeconfig

oc get csr -o name | xargs -n1 oc adm certificate approve
```

## Reset kubeadmin password
```
Actual Password: eNaQD-5f5d2-jx9xn-LifvD
Hashed Password: $2a$10$U1tgxaL/VFk1VdL5eFRZJek7tBkZwtMCT/t.bwZzS.YLlqGyJr7Ny
Data to Change in Secret: JDJhJDEwJFUxdGd4YUwvVkZrMVZkTDVlRlJaSmVrN3RCa1p3dE1DVC90LmJ3WnpTLllMbHFHeUpyN055
```
```
oc edit -n kube-system secrets kubeadmin
oc extract -n kube-system secrets/kubeadmin --to=-
```

# Links
- https://docs.openshift.com/container-platform/4.9/backup_and_restore/control_plane_backup_and_restore/replacing-unhealthy-etcd-member.html
- https://blog.andyserver.com/2021/07/rotating-the-openshift-kubeadmin-password
- https://play.golang.org/p/D8c4P90x5du
