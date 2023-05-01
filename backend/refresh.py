import json
from frictionless import Package

from fedlexrdf import fedlexFetch

package = Package('datapackage.json')


# Refresh results for each Resource in the Data Package
if __name__ == '__main__':
    print("Updating %d resources" % len(package.resources))
    for resource in package.resources:
        if len(resource.sources)>0:
            print("Updating %s" % resource.name)
            tpltfile = resource.sources[0]['path']
            freshJson = fedlexFetch(tpltfile)
            if not freshJson or not type(freshJson) == dict:
                print(freshJson)
                exit()
            freshText = json.dumps(freshJson, ensure_ascii=False)
            with open(resource.path, 'w') as f:
                f.write(freshText)