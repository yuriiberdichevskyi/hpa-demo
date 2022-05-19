Useful Links
-----------

- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack).
- [prometheus-adapter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-adapter)
- [metric-server](https://github.com/kubernetes-sigs/metrics-server)
- [HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [HPA Behaviour](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior)
- [Resources management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits)
- [Resources management walkthrough](https://learnk8s.io/setting-cpu-memory-limits-requests)
- [Instance calculator](https://learnk8s.io/kubernetes-instance-calculator)
- [Lens](https://k8slens.dev)

### Instalation:

```shell
make all
```

### make load:

```shell
make test
```

### cleanup:

```shell
make clean
```

### troubleshooting:

make sure that custom.metric have created:

```shell
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/services/metric-app/metric_app_http_requests_total" | jq
```

if not, create one:

```shell
curl 127.0.0.1:30500
curl 127.0.0.1:30500/metrics
```
