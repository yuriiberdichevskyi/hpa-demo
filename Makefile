
all: dep demo-app hpa-custom

dep: ## Install required dependencies
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm install -f kube-prometheus-stack/values.yaml kube-prometheus-stack prometheus-community/kube-prometheus-stack 
	helm install -f prometheus-adapter/values.yaml prometheus-adapter prometheus-community/prometheus-adapter
	kubectl -n kube-system apply -f metrics-server/metrics-server.yaml

demo-app: ## Apply demo app resources
	kubectl apply -f demo_app.yaml
	kubectl apply -f metric_app.yaml

hpa-custom: hpa-cleanup ## Apply custom hpa
	kubectl apply -f hpa_custom.yaml

hpa-resources:  hpa-cleanup ## Apply resources hpa
	kubectl apply -f hpa_resources.yaml

hpa-cleanup: ## Cleanup hpa resources
	@kubectl delete hpa $(shell kubectl get hpa  | tail -n +2 |  cut -f 1 -d " " 2>/dev/null) 2>/dev/null || echo "nothing to cleanup"

demo-app-cleanup: ## Cleanup demo app resources
	@kubectl delete -f demo_app.yaml 2>/dev/null || echo "nothing to cleanup"
	@kubectl delete -f metric_app.yaml 2>/dev/null || echo "nothing to cleanup"

dep-cleanup: ## Cleanup dependencies 
	@helm uninstall prometheus-adapter prometheus-community/prometheus-adapter 2>/dev/null; true
	@helm uninstall kube-prometheus-stack prometheus-community/kube-prometheus-stack 2>/dev/null; true
	@kubectl delete -f metrics-server/metrics-server.yaml 2>/dev/null; true

cleanup: dep-cleanup demo-app-cleanup hpa-cleanup # Cleanup all resources

upgrade: demo-app ## Upgrade apps and prometheus charts 
	helm upgrade -f kube-prometheus-stack/values.yaml kube-prometheus-stack prometheus-community/kube-prometheus-stack 
	helm upgrade -f prometheus-adapter/values.yaml prometheus-adapter prometheus-community/prometheus-adapter

test: ## Run apache benchmark to make load
	ab -rSqd -c 200 -n 2000 127.0.0.1:30500/

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
