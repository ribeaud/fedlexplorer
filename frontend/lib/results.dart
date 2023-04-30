import 'package:flutter/material.dart';

class Item {
  Item({
    required this.dateApplicability,
    required this.title,
    this.isExpanded = false,
  });

  String dateApplicability;
  String title;
  bool isExpanded;

  static Item fromJson(json) => Item(title: json['title'], dateApplicability: json['dateApplicability']);
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
              title: Text(item.dateApplicability),
            );
          },
          body: ListTile(title: Text(item.title)),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
