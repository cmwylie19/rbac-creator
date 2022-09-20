#!/bin/bash

# Scraping ClusterRole
kubectl apply -f -<<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  ownerReferences:
    - apiVersion: v1
      kind: Namespace
      name: starburst
      uid: $(kubectl get ns $OWNER_NAMESPACE --template='{{ .metadata.uid}}')
  creationTimestamp: null
  name: mso-prometheus-cr
rules:
- apiGroups:
  - ""
  resources:
  - nodes/metrics
  verbs:
  - get
- nonResourceURLs:
  - /metrics
  verbs:
  - get
- apiGroups:
  - ""
  resources:
  - namespaces
  verbs:
  - get
- apiGroups:
  - ""
  resources:
  - services
  - endpoints
  - pods
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - monitoring.coreos.com
  resources:
  - alertmanagers
  verbs:
  - get
- apiGroups:
  - security.openshift.io
  resourceNames:
  - nonroot
  resources:
  - securitycontextconstraints
  verbs:
  - use
EOF

# Bind ClusterRole to MSO ServiceAccount
kubectl apply -f -<<EOF
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: mso-prometheus-crb
  ownerReferences:
    - apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRole
      name: mso-prometheus-cr
      uid: $(kubectl get clusterrole mso-prometheus-cr --template='{{ .metadata.uid }}')
subjects:
  - kind: ServiceAccount
    name: $TARGET_SERVICE_ACCOUNT
    namespace: $OWNER_NAMESPACE
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: mso-prometheus-cr
EOF