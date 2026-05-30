# echo-api -  DevOps Assignment

This repository runs a small Node.js API in Docker, publishes the image to GitHub Container Registry (GHCR) with GitHub Actions, and deploys it to Minikube using the files in `k8s/`.

---

## Before you start

Install these tools:

- Git
- Docker Desktop
- Minikube
- kubectl

Also make sure:

1. You pushed your code to the `main` branch.
2. GitHub Actions finished successfully.
3. The image exists in GHCR: `ghcr.io/aggmegalou/echo-api:latest`
4. The GHCR package is **public** (or Minikube cannot pull the image).

---

## Task 4.1 -  Deploy and test the app

### Step 1: Clone the repository

```bash
git clone https://github.com/aggmegalou/seip_assignment_1_2026.git
cd seip_assignment_1_2026
```

### Step 2: Start Minikube

```bash
minikube start
kubectl config current-context
```

You should see a Minikube context (for example `minikube`).

### Step 3: Apply the Kubernetes manifests

Apply the files one by one:

```bash
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

Or apply everything at once:

```bash
kubectl apply -f k8s/
```

### Step 4: Check that everything is running

```bash
kubectl rollout status deployment/echo-api --timeout=180s
kubectl get pods -l app=echo-api
kubectl get svc echo-api
kubectl get all -n default
kubectl get configmap,secret
```

You should see:

- 3 pods in `Running` state
- 1 deployment named `echo-api`
- 1 service named `echo-api` with type `ClusterIP`

---

## Task 4.2 -  Port forwarding and endpoints

The service runs inside the cluster. To open it on your computer, use port forwarding.

### Step 1: Forward the service to localhost

Run this command and leave the terminal open:

```bash
kubectl port-forward service/echo-api 8080:80
```

This maps:

- cluster service port `80`
- to your machine at `http://localhost:8080`

### Step 2: Test the endpoints

Open a second terminal and run:

```powershell
curl.exe http://localhost:8080/
curl.exe http://localhost:8080/secure-config
curl.exe http://localhost:8080/health
```

You can also open these URLs in your browser:

- `http://localhost:8080/`
- `http://localhost:8080/secure-config`
- `http://localhost:8080/health`

### What you should see

- `/` -  your custom welcome message from the ConfigMap
- `/secure-config` -  `"status": "Authorized"` and a masked secret suffix
- `/health` -  `"status": "Healthy"`

---

## Troubleshooting

| Problem | What to check |
| :--- | :--- |
| `ImagePullBackOff` | Image name in `k8s/deployment.yaml`, GHCR package exists, package is public |
| Pods not ready | `kubectl describe pod -l app=echo-api` |
| App keeps crashing | `kubectl logs deploy/echo-api` |
| Port-forward fails | Pods must be running and the port-forward command must stay open |

---