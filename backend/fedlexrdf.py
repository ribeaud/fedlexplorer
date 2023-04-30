from SPARQLWrapper import SPARQLWrapper, JSON

sparql = SPARQLWrapper(
    'https://fedlex.data.admin.ch/sparqlendpoint'
)
sparql.setReturnFormat(JSON)

SPARQL_TEMPLATE = '''
PREFIX jolux: <http://data.legilux.public.lu/resource/ontology/jolux#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

PREFIX DEUTSCH: <http://publications.europa.eu/resource/authority/language/DEU>

select ?dateApplicability (str(?rsNode) as ?rs) ?droit ?title {
  {
    select (str(?dateApplicabilityNode) as ?dateApplicability) ?lang ?legalTopicRegex ?consolidationAbstract  {
      values (?startDate ?endDate ?lang ?legalTopicRegex) {
        ('%s' '%s' DEUTSCH: '^(%s)')
      }
      ?consolidation a jolux:Consolidation ;
                     jolux:dateApplicability ?dateApplicabilityNode ;
                     jolux:isMemberOf ?consolidationAbstract .
      filter(xsd:date(?dateApplicabilityNode) >= xsd:date(?startDate) && xsd:date(?dateApplicabilityNode) <= xsd:date(?endDate))
    }
  } 

  ?consolidationAbstract jolux:classifiedByTaxonomyEntry/skos:notation ?rsNode . 
  optional {
    ?consolidationAbstract jolux:isRealizedBy ?expression .
    ?expression jolux:language ?lang ;
                jolux:title ?title .
  }
  #filter(datatype(?rsNode) = <https://fedlex.data.admin.ch/vocabulary/notation-type/id-systematique>)
  bind(if(strstarts(?rs, '0.'), 'International', 'National') as ?droit)
  
  FILTER(REGEX (?rsNode, ?legalTopicRegex))
}
order by ?dateApplicability ?rsNode
'''

def fedlexQuery(q, d_from, d_until):
    try:
        query = SPARQL_TEMPLATE % (d_from, d_until, q)
        sparql.setQuery(query)
        ret = sparql.query()
        return ret.convert()
    except Exception as e:
        print(e)
        return None