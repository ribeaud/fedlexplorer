import requests

TERMDAT_BASE_URL = 'https://api.termdat.ch/v2/Search?'
TERMDAT_OPTIONS = '&'.join([
    'Field.Terminus=false',
    'Field.Name=false',
    'Field.Abbreviation=true',
    'Field.Phraseology=false',
    'Field.Definition=false',
    'Field.Note=false',
    'Field.Context=false',
    'ReturnType=Detail',
])
TERMDAT_LANG = '&InLanguageCode=DE'

def getDefinitions(search_term=None, max_entries=1):
    if search_term is None:
        return []
    query = TERMDAT_BASE_URL + TERMDAT_OPTIONS + TERMDAT_LANG
    query = query + '&MaxEntryCount=%d' % max_entries
    query = query + '&SearchTerm=%s' % search_term
    r = requests.get(query)
    jsondata = r.json()
    results = []
    for r in jsondata:
        detaildata = r['languageDetails'][0]
        if 'note' in detaildata:
            results.append(detaildata['note'])
        if 'definition' in detaildata:
            results.append(detaildata['definition'])
    return results