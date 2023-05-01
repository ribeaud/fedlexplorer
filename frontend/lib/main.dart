import 'package:fedlexplorer/results.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Topic {
  Topic({
    required this.concept,
    required this.conceptKey,
    required this.de,
  });

  String concept;
  String conceptKey;
  String de;

  static Topic fromJson(json) => Topic(
        concept: takeFirst(json['concept']),
        conceptKey: json['conceptKey'],
        de: json['de'],
      );
}

List<Topic> topics = <Topic>[];

getTopics() async {
  final response = await http.get(Uri.parse('http://fedlexplorer.openlegallab.ch/topics'));
  if (response.statusCode == 200) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}

Future<void> main() async {
  topics = (await getTopics()).map<Topic>(Topic.fromJson).toList();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'FEDLEXplorer';

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red, scaffoldBackgroundColor: Colors.white),
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const FedlexForm(),
      ),
    );
  }
}

class FedlexForm extends StatefulWidget {
  const FedlexForm({super.key});

  @override
  FedlexFormState createState() {
    return FedlexFormState();
  }
}

class FedlexFormState extends State<FedlexForm> {
  final _formKey = GlobalKey<FormState>();
  final fromController = TextEditingController();
  final untilController = TextEditingController();

  getData(var from, var until) async {
    final response = await http.get(Uri.parse('http://fedlexplorer.openlegallab.ch/query?from=$from&until=$until'));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
            child: Text(
              "Inkrafttreten",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: fromController,
              decoration: const InputDecoration(
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Von',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: untilController,
              decoration: const InputDecoration(
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Bis',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
            child: Text(
              "Themen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: DropdownButtonFormField<Topic>(
                value: topics.first,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (Topic? value) {
                  print(value);
                },
                items: topics.map<DropdownMenuItem<Topic>>((Topic value) {
                  return DropdownMenuItem<Topic>(
                    value: value,
                    child: Text(value.de),
                  );
                }).toList(),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var data = await getData(fromController.text, untilController.text);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ResultsPage(data: data);
                  }));
                }
              },
              child: const Text('Zeigen'),
            ),
          ),
        ],
      ),
    );
  }
}
