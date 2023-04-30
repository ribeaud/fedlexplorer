import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search App',
      home: MyHomePage(title: 'Search App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> data = [    {      'date': '2022-05-01',      'content':          'This is some content for May 1st. It can be as long as you want it to be.'    },    {      'date': '2022-05-02',      'content':          'This is some content for May 2nd. It can be as long as you want it to be.'    },    {      'date': '2022-05-03',      'content':          'This is some content for May 3rd. It can be as long as you want it to be.'    },    {      'date': '2022-05-04',      'content':          'This is some content for May 4th. It can be as long as you want it to be.'    },    {      'date': '2022-05-05',      'content':          'This is some content for May 5th. It can be as long as you want it to be.'    },  ];

  late List<Map<String, dynamic>> filteredData;

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredData = List.from(data);
  }

  void filterData(String query) {
    setState(() {
      filteredData = data
          .where((item) =>
              item['date'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    filterData('');
                  },
                ),
              ),
              onChanged: (value) {
                filterData(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(filteredData[index]['date']),
                  subtitle: Text(filteredData[index]['content']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
