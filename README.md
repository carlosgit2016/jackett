## Jackett

from jackett's github "Jackett works as a proxy server: it translates queries from apps (Sonarr, Radarr, SickRage, CouchPotato, Mylar3, Lidarr, DuckieTV, qBittorrent, Nefarious etc.) into tracker-site-specific http queries, parses the html or json response, and then sends results back to the requesting software. This allows for getting recent uploads (like RSS) and performing searches. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps." https://github.com/Jackett/Jackett

## This repository
This is a set of k8s resources that can be used to deploy jackett and exposes it through an ingress using ingress-nginx controller https://github.com/kubernetes/ingress-nginx. It also provides a simple script to have it running out of the box with minikube.

You can basically apply the resources in this repo using `kubectl` to have it running or you can use the script to set it up locally in minikube.

### Script execution pre-requisites
- minikube
- kubectl
- helm
- Bbitorrent installed
- qBittorrent jackett plugin

### Usage
```bash
./jackett.sh
```

This script will use minikube context and deploy ingress-nginx with helm and then apply the repo resources to have jackett working, afterwards it configure the `api_key` in qbittorrent `jackett.json` configuration files (It is necessary to have qBittorrent plugin)

