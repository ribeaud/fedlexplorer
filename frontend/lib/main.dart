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
  final _formKey = GlobalKey<FormState>();

  getData() async {
    final response = await http.get(Uri.parse('http://fedlexplorer.openlegallab.ch/sample'));
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte ein Datum eingeben (JJJJ-MM-TT)';
                }
                return null;
              },
              decoration: const InputDecoration(
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Inkrafttreten von',
                        ),
                      ),
                      WidgetSpan(
                        child: Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var data = await getData();
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
