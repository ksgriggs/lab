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

### DaemonSets

[DaemonSets Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

DaemonSet example daemon-set-definition.yaml

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: monitoring-daemon
spec:
  selector:
    matchLabels:
      app: monitoring-daemon
  template:
    metadata:
      labels:
        app: monitoring-daemon
    spec:
      containers:
        - name: monitoring-agent
          image: monitoring-agent
```

### Static Pods

[Static Pods Documentation](https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)

Manifests for static pods usually found in /etc/kubernets/manifests.

### Priority Classes

[Priority Classes Documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/)

Priority Class example priority-class.yaml

```yaml
apiVersion: schduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 1000000000
description: "Priority class for mission critical pods"
```

pod-definition.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    name: nginx
spec:
  containers:
    - name: nginx
      image: nginx
      ports:
        - containerPort: 8080
  priorityClassName: high-priority
```

### Multiple Schedulers

[Multiple Schedulers Documentation](https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/)

Example pod-definition.yaml

This pod manifest uses default-scheduler.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: annotation-default-scheduler
  labels:
    name: multischeduler-example
spec:
  schedulerName: default-scheduler
  containers:
    - name: pod-with-default-annotation-container
      image: registry.k8s.io/pause:3.8
```

### Scheduler Profiles

[Scheduler Profiles Documentation](https://kubernetes.io/docs/reference/scheduling/config/#multiple-profiles)

Example my-scheduler-2-config.yaml

```yaml
apiVersion: kubescheduler.config.k8s.io/v1
kind: KubeSchedulerConfiguration
profiles:
  - schedulerName: my-scheduler-2
    plugins:
      score:
        disabled:
          - name: TaintToleraion
        enabled:
          - name: MyCustomPluginA
          - name: MyCustomPluginB
  - schedulerName: my-scheduler-3
    plugins:
      preScore:
        disabled:
          - name: "*"
      score:
        disabled:
          -name: "*"
  - schedulerName: my-scheduler-4
```

### Admission Controllers

[Admission Controllers Documentation](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)

### Commands and Arguements in a pod definition file

Example pod-definition.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-pod
spec:
  containers:
    - name: ubuntu-sleeper
      image: ubuntu-sleeper
      command: ["sleep2.0"] # overrides ENTRYPOINT on the image
      args: ["10"] # overrides CMD on the image
```

Command examples:

    # Start the nginx pod using the default command, but use custom arguments (arg1 .. argN) for that command
    kubectl run nginx --image=nginx -- <arg1> <arg2> ... <argN>

    # Start the nginx pod using a different command and custom arguments
    kubectl run nginx --image=nginx --command -- <cmd> <arg1> ... <argN>

### Environment Variables in a pod definition file

Example pod-definition.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-pod
spec:
  containers:
    - name: ubuntu-sleeper
      image: ubuntu-sleeper
      command: ["sleep2.0"] # overrides ENTRYPOINT on the image
      args: ["10"] # overrides CMD on the image
      env:
        - name: TIER
          value: dev
```

Using a ConfigMap:

Imperative:

    kubectl create configmap <config-name> --from-literal=<key>=<value>
    kubectl create configmap app-config --from-literal=APP_COLOR=blue

Declarative:

Example config-map.yaml

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: blue
  APP_MODE: prod
```

Example pod-definition.yaml

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
      envFrom:
        - configMapRef:
          name: app-config
```

Or to use just one of the env variables set in configmap app-config:

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
      env:
        - name: APP_COLOR
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: APP_COLOR
```

Using a Secret:

# DO NOT CHECK YOUR SECRET OBJECTS INTO SCM

Imperative:

    kubectl create secret generic <secret-name> --from-literal=<key>=<value>
    kubectl create secret generic app-secret --from-literal=DB_Host=mysql

    kubectl create secret generic <secret-name> --from-file=<path-to-file>
    kubectl create secret generic app-secret --from-file=app_secret.properties

Declarative:

The secret values must be encoded in this file.

    You can encode the data like this:

    echo -n "mysql" | base64
    echo -n "root" | base64
    echo -n "paswrd" | base64

Example secret-data.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_Host: bXlzcWw=
  DB_User: cm9vdA==
  DB_Password: cGFzd3Jk
```

Example pod-definition.yaml

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
      envFrom:
        - secretRef:
            name: app-secret
```

Or to use just one of the env variables set in secrets app-config:

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
      env:
        - name: DB_Password
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: DB_Password
```

### Multi Container Pods

Example pod-definition.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp
  labels:
    name: simple-webapp
spec:
  containers:
    - name: simple-webapp
      image: simple-webapp
      ports:
        - containerPort: 8080
    - name: log-agent
      image: log-agent
```

### Autoscaling

- Horizontal Pod Autoscalier (HPA)
  - Adds / removes Pods based on load.
  - Keeps existing Pods running.
  - Avoids unnecessary idle Pods.
  - Best for web apps, microservices, stateless services.
- Vertical Pod Autoscaler (VPA)
  - Increases CPU & memory of existing Pods.
  - Restarts Pods to apply new resource values.
  - Prevents over-provisioning of CPU/memory.
  - Best for stateful workloads, CPU/memory heavy apps (DBs, ML workloads)

[Autoscaling Documentation](https://kubernetes.io/docs/concepts/workloads/autoscaling/)

Example my-app-hpa.xml

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 1
  maxReplicas: 10
  metrics:
    - type: Resources
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50
```

To install VPA run:

    kubectl apply -f https://github.com/kubernetes/autoscaler/releases/latest/downloads/vertical-pod-autoscaler.yaml

Example my-app-vpa.yaml

```yaml
apiServer: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-ap
  updatePolicy:
    updateMode: "Auto"
  resourcePolicy:
    containerPolicy:
      containerPolicies:
        - containername: "my-app"
          minAllowed:
            cpu: "250m"
          maxAllowed:
            cpu: "2"
          controllerResources: ["cpu"]
```

### Cluster Maintenance

OS Upgrades

    kubectl drain node-01
    kubectl cordon node-01
    kubectl uncordon node-01

Kubernetes Upgrade Process

[Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)

    Upgrade one node at a time. Start with control plane(s).
