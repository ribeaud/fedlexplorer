import 'package:fedlexplorer/results.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const MainApp());

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
  final List<String> list = <String>['One', 'Two', 'Three', 'Four'];
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
              child: DropdownButtonFormField<String>(
                value: list.first,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  print(value);
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
