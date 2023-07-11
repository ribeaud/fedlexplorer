# FEDLEXplorer Backend

In this folder we will develop a simple backend to proxy the results of queries from the app frontend to the SPARQL API and other remote data sources.

This repository contains a minimalist backend service API based on the [Falcon Framework](http://falconframework.org/). See this [Medium post](https://lynn-kwong.medium.com/build-apis-with-falcon-in-python-all-essentials-you-need-9e2c2a5e1759) for an introduction to the framework.

We also use these great libraries to make the magic happen:

- [SPARQLWrapper](https://pypi.org/project/SPARQLWrapper/) (W3C license)
- [Frictionless](https://pypi.org/project/frictionless/) (MIT license)
- [orjson](https://pypi.org/project/orjson/) (Apache-2.0 or MIT)

## Installation

To run:

```
python -m venv venv
source venv/bin/activate
pip install -Ur requirements.txt
cd ../data
python ../backend/server.py
```

(Alternatively: use [Poetry](https://python-poetry.org/docs/) or [Pipenv](https://pipenv.pypa.io/en/latest/))

At this point you should see the message "Serving on port..."

Test the API using a REST client such as [RESTer](https://github.com/frigus02/RESTer) with queries such as:

`http://localhost:8000/[my resource name]?[column]=[query]`

You can adjust the amount of output with a `page` and `per_page` parameter in your query.

## Docker

To run:

```
docker build -t fedlexplorer-backend:latest .
docker run -d -p 80:8000 --name fedlexplorer-backend -it fedlexplorer-backend
```

Then access the server at http://localhost/.

## Kubernetes

### Local

1. Follow the instructions given [here](https://minikube.sigs.k8s.io/docs/handbook/pushing/#1-pushing-directly-to-the-in-cluster-docker-daemon-docker-env) to directly push the images to the `in-cluster` **Docker** daemon (`docker-env` - assuming you're using **minikube**)
1. Build the image as described above
1. `kubectl apply -f k8s.yml` (without the `Ingress` part). The service is listening on port `8080` (the pods however are using port `8000`).
1. `kubectl port-forward service/fedlexplorer-backend 8080:8080` to access **fedlexplorer-backend** on port `8080`.

Then access the server at http://localhost:8080/.

### Karakun Kubernetes

1. Follow instructions given at https://jira.karakun.com/browse/IT-2615.
1. Access **backend** at https://bk-fedlexplorer-dev.k8s.karakun.com/.
