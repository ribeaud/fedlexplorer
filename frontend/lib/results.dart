import 'package:flutter/material.dart';

String takeFirst(String text) {
  return text.split(" ").first;
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
