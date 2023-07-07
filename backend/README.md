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
