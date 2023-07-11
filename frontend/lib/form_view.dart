import 'package:fedlexplorer/results_view.dart';
import 'package:fedlexplorer/utilities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Item>> fetchData(String? from, String? until, String? conceptKey) async {
  final response = await http
      .get(Uri.parse('https://bk-fedlexplorer-dev.k8s.karakun.com/query?from=$from&until=$until&q=$conceptKey'));
  if (response.statusCode == 200) {
    return jsonDecode(utf8.decode(response.bodyBytes)).map<Item>(Item.fromJson).toList();
  }
  throw Exception("Failed to load the data!");
}

class Topic {
  Topic({
    required this.concept,
    required this.conceptKey,
    required this.de,
  });

  final String concept;
  final String conceptKey;
  final String de;

  static Topic fromJson(json) => Topic(
        concept: takeFirst(json['concept']),
        conceptKey: json['conceptKey'],
        de: json['de'],
      );
}

class FedlexForm extends StatefulWidget {
  final List<Topic> _topics;

  FedlexForm({super.key, required List<Topic> topics}) : _topics = topics;

  @override
  FedlexFormState createState() {
    return FedlexFormState();
  }
}

class FedlexFormState extends State<FedlexForm> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateTime _firstDate = DateTime(1970, 1, 1);
  final DateTime _lastDate = DateTime(DateTime.now().year + 100);
  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController();
  final _untilController = TextEditingController();
  Topic? _selectedTopic;

  Future<void> _selectDate(final BuildContext context, final TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('de', 'CH'),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    setState(() {
      controller.text = picked != null ? _dateFormat.format(picked) : "";
    });
  }

  TextFormField _createTextFormField(
      final BuildContext context, final String label, final TextEditingController controller) {
    return TextFormField(
      readOnly: true,
      onTap: () {
        _selectDate(context, controller);
      },
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.calendar_month),
        label: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              WidgetSpan(
                child: Text(
                  label,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                "Inkrafttreten",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _createTextFormField(context, 'Von', _fromController),
            _createTextFormField(context, 'Bis', _untilController),
            Padding(
              padding: const EdgeInsets.only(top: 64.0, bottom: 8.0),
              child: Text(
                "Themen",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<Topic>(
                  icon: const Icon(Icons.arrow_downward),
                  onChanged: (Topic? topic) {
                    _selectedTopic = topic;
                  },
                  items: [
                    ...[
                      DropdownMenuItem(
                        value: null,
                        child: Text("(kein Thema)"),
                      )
                    ],
                    ...widget._topics.map<DropdownMenuItem<Topic>>((Topic value) {
                      return DropdownMenuItem<Topic>(
                        value: value,
                        child: Text(
                          truncateWithEllipsis(35, "${value.conceptKey} - ${value.de}"),
                        ),
                      );
                    }).toList()
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var conceptKey = _selectedTopic?.conceptKey ?? "";
                    var data = await fetchData(
                      _fromController.text,
                      _untilController.text,
                      conceptKey,
                    );
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
      ),
    );
  }
}
