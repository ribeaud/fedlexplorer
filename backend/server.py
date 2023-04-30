import falcon
import json
from os import environ
from frictionless import Package
from wsgiref.simple_server import make_server

api = falcon.App()

package = Package('datapackage.json')

def get_paginated_json(req, df):
    per_page = int(req.get_param('per_page', required=False, default=10))
    page = (int(req.get_param('page', required=False, default=1))-1)*per_page
    return df[page:page+per_page].to_json(orient='records')

class DataResource:

    def __init__(self, data):
        self.resource = data

    def on_get(self, req, resp):
        if self.resource.profile == "sparql-json-resource":
            with open(self.resource.path) as f:
                doc = json.loads(f.read())['results']
            resp.text = json.dumps(doc, ensure_ascii=False)
            resp.status = falcon.HTTP_200

for resource in package.resources:
    api.add_route("/%s" % resource.name, DataResource(resource))

if __name__ == '__main__':
    port = int(environ.get('PORT', 8000))
    with make_server('', port, api) as httpd:
        print('Serving on port %d...' % port)
        httpd.serve_forever()
