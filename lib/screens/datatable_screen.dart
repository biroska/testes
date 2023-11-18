import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DataTableScreen extends StatelessWidget {
  const DataTableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DataTableExample();
  }
}

class DataTableExample extends StatelessWidget {
  const DataTableExample({super.key});

  @override
  Widget build(BuildContext context) {
    String uri = "https://api.flutter.dev/flutter/material/DataTable-class.html";

    List<Person> people = [
      Person(name: 'Sarah', age: 64, role: '1 Lt'),
      Person(name: 'Janine', age: 70, role: '1 Kg') ,
      Person(name: 'Willian', age: 50, role: '1 Kg'),
      Person(name: 'Hermann', age: 130, role: '1 Kg'),
      Person(name: 'Anthony', age: 64, role: '200 Gm')];

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Aplicação teste para estudo de Flutter')),
      ),
      //Padding para que os elementos nao fiquem colados nas bordas das telas
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 30.0),

        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Linkify(
                onOpen: (link) async {
                  if (await canLaunchUrlString(uri)) {
                    await launchUrlString(uri);
                  } else {
                    throw 'Could not launch $uri';
                  }
                },
                text: uri,
                style: const TextStyle(color: Colors.blue),
                linkStyle: const TextStyle(color: Colors.green),
                options:
                const LinkifyOptions(humanize: false, removeWww: true),
              ),
            ),
            const SizedBox(height: 100),
            Container(
              alignment: Alignment.center,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Name',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Age',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Role',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: people
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              e.name,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              e.age.toString(),
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              e.role,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Person {
  String name;
  int age;
  String role;

  Person({required this.name, required this.age, required this.role});
}
