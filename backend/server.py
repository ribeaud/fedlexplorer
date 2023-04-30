import falcon
import json

from os import environ
from frictionless import Package
from wsgiref.simple_server import make_server

from fedlexrdf import fedlexQuery

MAX_RESULTS = 1000


package = Package('datapackage.json')

api = falcon.App()


def flattenMe(doc):
    transformed = []
    vars = doc['head']['vars']
    for r in doc['results']['bindings']:
        row = {}
        for v in vars:
            row[v] = r[v]['value']
        transformed.append(row)
        if len(transformed) > MAX_RESULTS:
            break
    return transformed


class DataResource:

    def __init__(self, data):
        self.resource = data

    def on_get(self, req, resp):
        if self.resource.profile == "sparql-json-resource":
            with open(self.resource.path) as f:
                doc = json.loads(f.read())
                jsonDoc = flattenMe(doc)

            resp.text = json.dumps(jsonDoc, ensure_ascii=False)
            resp.status = falcon.HTTP_200


# Create end-points for each Resource in the Data Package
for resource in package.resources:
    api.add_route("/%s" % resource.name, DataResource(resource))



class DataQuery:

    def on_get(self, req, resp):
        q = req.get_param('q', required=False, default='')
        d_from = req.get_param('from', required=False, default='2023-09-01')
        d_until = req.get_param('until', required=False, default='9999-12-31')

        rawData = fedlexQuery(q, d_from, d_until)
        jsonDoc = flattenMe(rawData)

        resp.text = json.dumps(jsonDoc, ensure_ascii=False)
        resp.status = falcon.HTTP_200


# Create end-point for our SPARQL query
api.add_route("/query", DataQuery())


# Standalone app
if __name__ == '__main__':
    port = int(environ.get('PORT', 8000))
    with make_server('', port, api) as httpd:
        print('Serving on port %d...' % port)
        httpd.serve_forever()
