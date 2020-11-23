# rock-content-sre
Site Reliability Engineer - Rock Content Technical Test

## Prerequisites

- Download and configure Minikube by following this [documentation](https://kubernetes.io/docs/tasks/tools/install-minikube/).
- Download and configure Helm3 using your package manager or do it manually from the releases.
- Download and install kubectl by following [these steps](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
- Install Terraform v0.13+
- Install docker version 19+

## Prep and build minikube
Create a Minikube cluster before getting started
  `minikube start --cpus 2 --memory 5400 --driver=virtualbox`

## Building the image
There are 2 ways to use the image defined in the `docker` of this repo.
1. Building and running it locally
2. Building and pushing it to an image repository.

We are going to use the first scenario in our case. To do this, we will reuse the Docker daemon from Minikube with `eval $(minikube docker-env)`  
So to use our custom image without uploading it, you can follow these steps:

- Navigate to docker `folder`
- Set the environment variables with `eval $(minikube docker-env)`
- Build the image with the Docker daemon of Minikube `(docker build -t <image name> .)` eg `docker build -t kungus/wp-sre:1`
- Set the image in the pod spec like the build tag (eg kungus/wp-sre:1)
- We then set the `imagePullPolicy` to `Never`, otherwise Kubernetes will try to download the image.

## Creating the Infrastructure

- Navigate to terraform folder by `cd terraform`
- To check the resources that are going to be created run `terraform plan`. Once you validate resources are okay to create,
- Run `terraform apply -auto-approve`

