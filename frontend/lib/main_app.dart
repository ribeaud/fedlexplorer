import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'form_view.dart';

Future<List<Topic>> fetchTopics() async {
  final response = await http.get(Uri.parse('http://fedlexplorer.openlegallab.ch/topics'));
  if (response.statusCode == 200) {
    return jsonDecode(utf8.decode(response.bodyBytes)).map<Topic>(Topic.fromJson).toList();
  }
  throw Exception("Failed to load the topics!");
}

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Future<List<Topic>> _topics;

  @override
  void initState() {
    super.initState();
    _topics = fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'FEDLEXplorer';

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'CH'),
        Locale('fr', 'CH'),
        Locale('en', 'CH'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: FutureBuilder<List<Topic>>(
          future: _topics,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FedlexForm(topics: snapshot.requireData);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return Center(
              child: const CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
