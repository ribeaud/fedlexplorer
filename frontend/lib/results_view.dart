import 'package:fedlexplorer/utilities.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

Future<String> getTerms(String input) async {
  final response = await http.get(Uri.parse('https://bk-fedlexplorer-dev.k8s.karakun.com/term?q=$input'));
  if (response.statusCode == 200) {
    List<String> json = (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>).cast<String>();
    return json.firstOrNull ?? "";
  }
  throw Exception("Failed to load the terms!");
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

class ResultsPage extends StatefulWidget {
  final List<Item> data;

  const ResultsPage({super.key, required this.data});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late List<Item> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data;
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
                          content: Text(content.isEmpty ? "(kein Term)" : content),
                          actions: <Widget>[
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
