from SPARQLWrapper import SPARQLWrapper, JSON


def getSparqlTemplate(name):
    """Loads a template from a file by name."""
    if not '.sparql' in name:
        name = '%s.sparql' % name
    with open(name) as f:
        return f.read()


def fedlexQuery(q, d_from, d_until):
    """Runs a SPARQL query."""
    try:

        query = SPARQL_TEMPLATE % (d_from, d_until, q)
        sparql.setQuery(query)
        ret = sparql.query()
        return ret.convert()
    except Exception as e:
        print(e)
        return None


def fedlexFetchWithTemplate(template):
    """Runs a SPARQL query with any template."""
    try:
        sparql.setQuery(template)
        ret = sparql.query()
        return ret.convert()
    except Exception as e:
        print(e)
        return None


def fedlexFetch(name):
    """Runs a SPARQL query by name of template."""
    template = getSparqlTemplate(name)
    return fedlexFetchWithTemplate(template)



def flattenMe(doc):
    """Transforms RDF results to simple JSON list."""
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



sparql = SPARQLWrapper(
    'https://fedlex.data.admin.ch/sparqlendpoint'
)
sparql.setReturnFormat(JSON)

SPARQL_TEMPLATE = getSparqlTemplate('inkraftquery')