# Wordpress and MySQL application deployment with Monitoring.

This repo is used deploy the named services laveraging the use of Infrastructure as Code.

## Prerequisites

- Download and configure Minikube v1.15+ by following this [documentation](https://kubernetes.io/docs/tasks/tools/install-minikube/).
- Download and configure Helm3 using your package manager or do it manually from the releases.
- Download and install kubectl 1.17+ by following [these steps](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
- Install Terraform v0.13+
- Install docker version 19+

## Prep and build minikube
Create a Minikube cluster before getting started
  `minikube start --cpus 2 --memory 5400 --driver=virtualbox`

## Building the image
There are 2 ways to use the image defined in the `docker` directory of this repo.
1. Building, running, and using it locally
2. Building and pushing it to an image repository.

### Building locally (development)
To do this, we will reuse the Docker daemon from Minikube with.
To use our custom image without uploading it, you can follow these steps:

- Navigate to `docker` folder by running `cd docker`
- Set the environment variables with `eval $(minikube docker-env)`
- Build the image with the Docker daemon of Minikube `(docker build -t <image name> .)` eg `docker build -t kungus/wp-sre:1.0.1`
- Set the image in the pod spec like the build tag (eg kungus/wp-sre:1)
- We then set the `imagePullPolicy` to `Never`, otherwise Kubernetes will try to download the image.

### Building and pushing the image to a remote repository
- Build and tag the image `(docker build -t <image name> .)` eg `docker build -t kungus/wp-sre:1.0.1`
- Push the image to a repository `docker push kungus/wp-sre:1.0.1`
- You can set the `imagePullPolicy` to `Always`, and allow Kubernetes to always try and download the latest image

## Creating the Infrastructure

We are going to create the infrastructure using terraform. And using helm provider to install and configure grafana and prometheus declaratively and have complete IaC.   
This is advantageous as it is also used to automatically add dashboards, install plugins on grafana upon initial installation.  
Both wordpress and MYSQl services will be deployed via Helm. This brings in consistency in installation of both monitoring tools and the application. 

- Navigate to terraform folder by `cd terraform`
- To check the resources that are going to be created run `terraform plan`. Once you validate resources are okay to create,
- Run `terraform apply -auto-approve`

## Accessing Grafana Dashboard
Since the terraform script we have is deploying to `monitoring` namespace by default, we can get the grafana service that will help us access the dashboard. To do that   
- list the services running there 

```
    ➜ kubectl get svc -n <monitoring-namespace>
NAME                                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
grafana-release                         ClusterIP   10.103.49.125   <none>        80/TCP     3m41s
prometheus-release-alertmanager         ClusterIP   10.101.167.72   <none>        80/TCP     3m33s
prometheus-release-kube-state-metrics   ClusterIP   10.99.84.176    <none>        8080/TCP   3m33s
prometheus-release-node-exporter        ClusterIP   None            <none>        9100/TCP   3m33s

```

- To access the dashboard in the browser, we have to port-forward the requests from `grafana-release` service to our localhost. Run  
`kubectl -n <monitoring-namespace> port-forward service/grafana-release 3000:80`
- Using a browser visit `http://localhost:3000` to access grafana UI
- Grafana dashboard's `username` and `password` are set during infrastructure creation using the file located at `terraform/terraform.tfvars`
- We can verify that from the k8s `Secrets` by running the following command  
```
kubectl get secret -n <monitoring-namespace> grafana-release -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

NOTE: Don't forget to replace `<monitoring-namespace>` with the namespace defined/used in terraform build process.

## Accessing wordpress Website
The process is the same with the above instructions.   
- Get the services running from `app` namespace
`kubectl get svc -n <app-namespace>`  

- Use kubernetes Port-forward to access the website     

  `kubectl -n <grafana-namespace> port-forward service/grafana-release 8000:8080`  

- visit `http://localhost:8080` to access the wordpress website
- Or use `minikube service wordpress-sre -n <namespace>` to get the full  `NodePort`  eg `http://192.168.99.113:31075`
