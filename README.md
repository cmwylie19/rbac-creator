# RBAC Creator
_Mini-controller running as a Kubernetes job to create ClusterRole and ClusterRoleBinding specifically needed for MSO service account._

The Job takes two parameters as environment variables, `OWNER_NAMESPACE` and `TARGET_SERVICE_ACCOUNT`.

- TARGET_SERVICE_ACCOUNT - the service account to receive permissions
- OWNER_NAMESPACE - the namespace that owns the RBAC and the Service Account

## Usage

```bash
kubectl apply -f k8s
```

output

```bash
job.batch/rbac-creator created
configmap/rbac-creator created
serviceaccount/rbac-creator created
clusterrolebinding.rbac.authorization.k8s.io/rbac-creator-admin created
namespace/starburst created
```

Verify Job worked:

```bash
kubectl get clusterrole mso-prometheus-cr --no-headers

kubectl get clusterrolebinding mso-prometheus-crb --no-headers
```

output

```bash
mso-prometheus-cr   2022-09-20T21:07:10Z
mso-prometheus-crb   ClusterRole/mso-prometheus-cr   60s
```

Delete the namespace and ensure RBAC is cleaned:


```bash
kubectl delete ns starburst

kubectl get clusterrole mso-prometheus-cr

kubectl get clusterrolebinding mso-prometheus-crb
```

output

```bash
namespace "starburst" deleted
Error from server (NotFound): clusterroles.rbac.authorization.k8s.io "mso-prometheus-cr" not found
Error from server (NotFound): clusterrolebindings.rbac.authorization.k8s.io "mso-prometheus-crb" not found
```