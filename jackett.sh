#!/bin/bash

set -x

minikube status

if [ $? -ne 0 ]; then
	minikube start
fi

kubectl get svc/ingress-nginx-controller -ningress-nginx

if [ $? -ne 0 ]; then
	helm upgrade --install ingress-nginx ingress-nginx \
  		--repo https://kubernetes.github.io/ingress-nginx \
  		--namespace ingress-nginx --create-namespace \
		-f values.yaml
fi

kubectl get ns/jackett

if [ $? -ne 0 ]; then
	kubectl apply -f /home/cflor/git/personal.d/scripts_util/k8s/jackett/namespace.yaml
	kubectl apply -f /home/cflor/git/personal.d/scripts_util/k8s/jackett/ingress.yaml
	kubectl apply -f /home/cflor/git/personal.d/scripts_util/k8s/jackett
	kubectl wait --for=jsonpath='{.status.readyReplicas}'=1 sts/jackett -njackett
	kubectl wait --for=jsonpath='{.status.loadBalancer.ingress}' -njackett service/jackett-svc
fi

# Replace qbittorrent plugin jackett configuration with the api_key in case it changes
sed -i "s|\"api_key\": \".*\"|\"api_key\": \"$(kubectl exec -it -njackett sts/jackett -- cat /config/Jackett/ServerConfig.json | jq -r '.APIKey')\"|" ~/.local/share/qBittorrent/nova3/engines/jackett.json

echo http://mary-jackett.io:$(kubectl get svc/ingress-nginx-controller -ningress-nginx -o go-template='{{ (index .spec.ports 0).nodePort }}')
