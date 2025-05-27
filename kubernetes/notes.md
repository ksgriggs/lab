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

Pods are the smallest deployable units of computing that you can create and manage in Kubernetes.

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
  name: myapp-pod
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

A ReplicaSet's purpose is to maintain a stable set of replica Pods running at any given time. Usually, you define a Deployment and let that Deployment manage ReplicaSets automatically.

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
    kubectl get replicasets.app
    kubectl delete replicaset myapp-replicaset
    kubectl replace -f replicaset-definition.yaml
    kubectl scale -replicas=6 -f replicaset-definition.yaml

### Deployments

[Deployments Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

A Deployment manages a set of Pods to run an application workload, usually one that doesn't maintain state.

Example deployment-definition.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    name: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        name: myapp
        type: front-end
    spec:
      containers:
        - name: nginx-controller
          image: nginx
  replicas: 3
  selector:
    matchLabels:
      type: front-end
```

Deployment command examples:

    # Create a deployment named my-dep that runs the busybox image
    kubectl create deployment my-dep --image=busybox

    # Create a deployment with a command
    kubectl create deployment my-dep --image=busybox -- date

    # Create a deployment named my-dep that runs the nginx image with 3 replicas
    kubectl create deployment my-dep --image=nginx --replicas=3

    # Create a deployment named my-dep that runs the busybox image and expose port 5701
    kubectl create deployment my-dep --image=busybox --port=5701

    # Create a deployment named my-dep that runs multiple containers
    kubectl create deployment my-dep --image=busybox:latest --image=ubuntu:latest --image=nginx
