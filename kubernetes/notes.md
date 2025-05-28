# Cluster Architecture

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

### Service

[Service Documentation](https://kubernetes.io/docs/concepts/services-networking/service/)

A Service is a method for exposing a network application that is running as one or more Pods in your cluster.

Service Types

- NodePort

  Exposes the Service on each Node's IP at a static port (the NodePort). To make the node port available, Kubernetes sets up a cluster IP address, the same as if you had requested a Service of type: ClusterIP.

  Example service-definition.yaml

  ```yaml
  apiVersion: v1
  name: Service
  metadata:
    name: myapp-service
  spec:
    type: NodePort
    ports:
      - targetPort: 80
        port: 80
        nodePort: 30008
    selector:
      app: myapp
      type: front-end
  ```

- ClusterIP

  Exposes the Service on a cluster-internal IP. Choosing this value makes the Service only reachable from within the cluster. This is the default that is used if you don't explicitly specify a type for a Service. You can expose the Service to the public internet using an Ingress or a Gateway.

  Example service-definition.yaml

  ```yaml
  apiVersion: v1
  name: Service
  metadata:
    name: back-end
  spec:
    type: ClusterIP
    ports:
      - targetPort: 80
        port: 80
    selector:
      app: myapp
      type: back-end
  ```

- LoadBalancer

  Exposes the Service externally using an external load balancer. Kubernetes does not directly offer a load balancing component; you must provide one, or you can integrate your Kubernetes cluster with a cloud provider.

  Example service-definition.yaml

  ```yaml
  apiVersion: v1
  name: Service
  metadata:
    name: myapp-service
  spec:
    type: LoadBalancer
    ports:
      - targetPort: 80
        port: 80
        nodePort: 30008
  ```

### Namespaces

[Namespaces Documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)

Namespaces provide a mechanism for isolating groups of resources within a single cluster

Example namespace-definition.yaml

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
```

Example compute-quota.yaml

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: 5Gi
    limits.cpu: "10"
    limits.memory: 10Gi
```

Namespaces command examples:

    kubectl get namespaces
    kubectl create namespace dev
    kubectl get pods --namespace=dev
    kubectl create -f pod-definition.yaml --namespace=dev

### Labels and Selectors

[Labels and Selectors Documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
  labels:
    app: App1
    function: Front-end
spec:
  containers:
    - name: nginx
      image: nginx
```

Command examples:

    kubectl get pods --selector app=App1
    kubectl get pods --selector function=Front-end

### Taints and Tolerations

[Taints and Tolerations Documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)

Command examples:

    kubectl taint nodes node-name key=value:taint-effect

    There are three taint effects:
      - NoSchedule
      - PreferNoSchedule
      - NoExecute

    kubectl taint nodes node1 app=blue:NoSchedule

Tolerations example pod-definition.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
spec:
  containers:
    - name: nginx-container
      image: nginx
  tolerations:
    - key: "app"
      operator: "Equal"
      value: "blue"
      effect: "NoSchedule"
```

### Node Selectors

[Node Selector Documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)

Example pod-definition.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
spec:
  containers:
    - name: data-processor
      image: data-processor
  nodeSelector:
    size: Large
```

Command examples:

    kubectl label nodes <node-name> <label-key>=<label-value>
    kubectl label nodes node-1 size=Large

Node selectors is limited such that we can't say place the pod on nodes labeled "Medium" or "Large". We can't use OR or NOT.

### Node Affinity

[Node Affinity Documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)

To place a pod in a node labeled size=Large or size=Medium, use the example below.

Example pod-definition.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
spec:
  containers:
    - name: data-processor
      image: data-processor
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: size
                operator: In
                values:
                  - Large
                  - Medium
```

Node affinity types:

- Available
  - requiredDuringSchedulingIgnoredDuringExecution
  - preferedDuringSchedulingIgnoredDuringExecution
- Planned
  - requiredDuringSchedulingRequiredDuringExecution

### Resource Requirements and Limits

[Resource Requirements and Limits Documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)

Example pod-defninition.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp-color
  labels:
    name: simple-webapp-color
spec:
  containers:
    - name: simple-webapp-color
      image: simple-webapp-color
    ports:
      - containerPort: 8080
    resources:
      requests:
        memory: "4Gi"
        cpu: 2
```

1 CPU is equal to:

- 1 AWS vCPU
- 1 GCP Core
- 1 Azure Core
- 1 Hyperthread

Memory:

- 1 G (Gigabyte) = 1,000,000,000 bytes
- 1 M (Megabyte) = 1,000,000 bytes
- 1 K (kilobyte) = 1,000 bytes
- 1 Gi (Gibibyte) = 1,073,741,824 bytes
- 1 Mi (Mebibyte) = 1,048,576 bytes
- 1 Ki (Kibibyte) = 1,024 bytes

Example pod-defninition.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp-color
  labels:
    name: simple-webapp-color
spec:
  containers:
    - name: simple-webapp-color
      image: simple-webapp-color
    ports:
      - containerPort: 8080
    resources:
      requests:
        memory: "1Gi"
        cpu: 1
      limits:
        memory: "2Gi"
        cpu: 2
```

[Limit Ranges Documentation](https://kubernetes.io/docs/concepts/policy/limit-range/)

Example limit-range-cpu.yaml

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-resource-constraint
spec:
  limits:
    - default:
        cpu: 500m
      defaultRequest:
        cpu: 500m
      max:
        cpu: "1"
      min:
        cpu: 100m
      type: Container
```

[Resource Quotas Documentation](https://kubernetes.io/docs/concepts/policy/resource-quotas/)

Example resource-quota.yaml

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: my-resource-quota
spec:
  hard:
    requests.cpu: 4
    requests.memory: 4Gi
    limits.cpu: 10
    limits.memory: 10Gi
```
