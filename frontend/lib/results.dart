import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String takeFirst(String text) {
  return text.split(" ").first;
}

getTerms(var terms) async {
  final response = await http.get(Uri.parse('http://fedlexplorer.openlegallab.ch/term?q=$terms'));
  if (response.statusCode == 200) {
    var json = jsonDecode(utf8.decode(response.bodyBytes));
    return json.length == 0 ? "" : json[0];
  }
}

class Item {
  Item({
    required this.dateApplicability,
    required this.title,
    required this.shortTitle,
    required this.rs,
    required this.droit,
    this.isExpanded = false,
  });

  String dateApplicability;
  String title;
  String shortTitle;
  String rs;
  String droit;
  bool isExpanded;

  static Item fromJson(json) => Item(
        shortTitle: takeFirst(json['title']),
        title: json['title'],
        dateApplicability: json['dateApplicability'],
        rs: json['rs'],
        droit: json['droit'],
      );
}

List<Item> generateItems(data) {
  return data.map<Item>(Item.fromJson).toList();
}

class ResultsPage extends StatefulWidget {
  final data;

  const ResultsPage({super.key, this.data});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<Item> _data = [];

  @override
  void initState() {
    super.initState();
    _data = generateItems(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ergebnisse')),
      body: SingleChildScrollView(
        child: Container(
          child: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text("${item.dateApplicability} - ${item.rs} - ${item.shortTitle}"),
            );
          },
          body: ListTile(
            title: Text(item.title),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.droit),
                  ElevatedButton(
                    onPressed: () async {
                      String content = await getTerms(item.title);
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Terme'),
                          content: Text(content),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Terme'),
                  )
                ],
              ),
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
