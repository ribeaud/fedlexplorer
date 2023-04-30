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
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.home),
          ),
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
      return jsonDecode(response.body);
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
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var data = await getData();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ResultsPage(data: data);
                  }));
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
