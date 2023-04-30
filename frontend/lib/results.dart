import 'package:flutter/material.dart';

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
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
        shortTitle: truncateWithEllipsis(30, json['title']),
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
      appBar: AppBar(title: const Text('Results')),
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
              title: Text(item.shortTitle),
            );
          },
          body: ListTile(
            title: Text(item.title),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.rs),
                  Text(item.droit),
                  Text(item.dateApplicability),
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
