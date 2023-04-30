import falcon
import json
from os import environ
from frictionless import Package
from wsgiref.simple_server import make_server

MAX_RESULTS = 1000

package = Package('datapackage.json')

api = falcon.App()


class DataResource:

    def __init__(self, data):
        self.resource = data

    def on_get(self, req, resp):
        if self.resource.profile == "sparql-json-resource":
            transformed = []
            with open(self.resource.path) as f:
                doc = json.loads(f.read())
                vars = doc['head']['vars']
                for r in doc['results']['bindings']:
                    row = {}
                    for v in vars:
                        row[v] = r[v]['value']
                    transformed.append(row)
                    if len(transformed) > MAX_RESULTS:
                        break

            resp.text = json.dumps(transformed, ensure_ascii=False)
            resp.status = falcon.HTTP_200




# Create end-points for each Resource in the Data Package
for resource in package.resources:
    api.add_route("/%s" % resource.name, DataResource(resource))

# Create end-point for our SPARQL query
#api.add_route("/query", DataQuery())

if __name__ == '__main__':
    port = int(environ.get('PORT', 8000))
    with make_server('', port, api) as httpd:
        print('Serving on port %d...' % port)
        httpd.serve_forever()
