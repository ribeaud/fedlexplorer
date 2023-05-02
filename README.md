# FEDLEXplorer

The purpose of this project is to demonstrate how Swiss federal legislation data can be used in third-party products through a SPARQL endpoint.

We are developing the [frontend](frontend/) and [backend](backend/) in the respective subfolders, where you will find implementation and contribution notes.

In the [data](data/) folder you can find our SPARQL queries and sample outputs.

For more information see https://challenges.openlegallab.ch/project/81

## API doc

Our small (please do not hammer) hackathon API is deployed here for testing:

**Sample**

`/sample` ([demo](http://fedlexplorer.openlegallab.ch/sample))

- Just gets a data sample for quick testing.

**Topics**

`/topics` ([demo](http://fedlexplorer.openlegallab.ch/topics))

- Gets the list of current legal topics. Output example can be found in `frontend/test/topics`.

**Query**

`/query?q=<number>&from=<date>&until=<date>` ([demo](http://fedlexplorer.openlegallab.ch/query?q=235&from=2023-09-01))

- Runs a search query on law changes published in FEDLEX.
- The `q` query is a list of topics, with IDs from the **Topics** above, separated by the pipe (|) character.
- `from` and `until` are dates in the format YYYY-MM-DD

Output example can be found in `frontend/test/data`.

**Terms**

`/term?q=<text>` ([demo](http://fedlexplorer.openlegallab.ch/term?q=UVEK))

- Gets the top result from a TERMDAT search. Tap on a word or highlight a phrase in the app and get a little definition pop-up.

# License

This project is licensed by its maintainers under both the Apache and MIT licenses.

To the best of our knowledge, all data included in this repository is open data. If you intended to use the included data in a public or commercial product, please check the data sources themselves for any specific and current restrictions.
