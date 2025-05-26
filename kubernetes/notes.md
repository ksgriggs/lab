## Cluster Architecture

[Cluster Architecture Documentation](https://kubernetes.io/docs/concepts/architecture/)

### Master Node

The master node manages the k8s cluster. It manages, plans, schedules, and monitors the nodes.

- etcd - stores information in a key/value format. It stores information about the cluster.

- kube-scheduler - schedules applications or containers on nodes.

- controller-manager

  - node-controller
  - replication-controller

- kube-apiserver - orchestrates all operations within the cluster.

### Worker Node

Worker nodes host applications as containers.

- kubelet - an agent that runs on each node in a cluster. It listens for instructions from the kube-apiserver. It deploys or destroys containers on the node as required.

- kube-proxy - ensures that the necessary rules are in place on the worker nodes to ensure the containers running on them can reach each other.

### Pods

[Pods Documentation](https://kubernetes.io/docs/concepts/workloads/pods/)

The smallest deployable unit you can create in k8s. A pod is a group of one or more containers.

Required properties:

```yaml
apiVersion:
kind:
metadata:

spec:
```

Example pod-definition.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pdo
  labels:
    app: myapp
    type: front-end
spec:
  containers:
    - name: nginx-container
      image: nginx
```

Pod command examples:

    kubectl get pods
    kubectl get pods -o wide
    kubectl run nginx --image nginx
    kubectl describe pod nginx
    kubectl run redis --image=redis123 --dry-run=client -o yaml > redis.yaml

### Replication Controller / Replica Set

[Replication Controller Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/)

[ReplicaSet Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)

Required properties:

```yaml
apiVersion:
kind:
metadata:

spec:
```

Example rc-definition.yaml

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: myapp-rc
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pdo
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
        - name: nginx-container
          image: nginx

  replicas: 3
```

Example replicaset-definition.yaml

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp-replicaset
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
        - name: nginx-container
          image: nginx

  replicas: 3
  selector:
    matchLabels:
      type: front-end
```

ReplicaSet command examples:

    kubectl create -f replicaset-definition.yaml
    kubectl get replicaset
    kubectl delete replicaset myapp-replicaset
    kubectl replace -f replicaset-definition.yaml
    kubectl scale -replicas=6 -f replicaset-definition.yaml
