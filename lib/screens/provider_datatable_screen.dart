import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/certificate_basic_info.dart';
import '../providers/certificate_provider.dart';

class ProviderDataTableScreen extends StatelessWidget {
  const ProviderDataTableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProviderDataTableExample();
  }
}

class ProviderDataTableExample extends StatefulWidget {
  const ProviderDataTableExample({super.key});

  @override
  State<ProviderDataTableExample> createState() =>
      _ProviderDataTableExampleState();
}

class _ProviderDataTableExampleState extends State<ProviderDataTableExample> {
  Future<List<CertificateInfo>?>? _certificateList;

  bool _loading = true;
  String testeState = '';
  List<CertificateInfo> _certificates = List.empty(growable: true);

  Future<List<CertificateInfo>?> _getCertificates() async {

    await Provider.of<CertificateProvider>(context, listen: false).getCertificates?.then((value) {
      _certificates = value!;
    });

    return _certificates;
  }

  Future<void> _loadCertificates(BuildContext context) async {

    setState(() {
      _loading = true;
    });

    _certificateList = Provider.of<CertificateProvider>(context, listen: false).loadCertificates();

    await _certificateList?.then( (value) {
      _certificates = value!;
    })
    .whenComplete(() {_loading = false;});

    setState(() {
      _certificates;
      _loading;
    });
  }

  Future<void> _clearCertificates(BuildContext context) async {

    setState(() {
      _loading = true;
    });

    await Provider.of<CertificateProvider>(context, listen: false).clearCertificates()
        .then((_) {});

    await _getCertificates().then((cerData) {
      setState(() {
        _certificates = cerData!;
        _loading = false;
      });
    });
  }

  void _updateCertificates(BuildContext context) {
    _loadCertificates(context);
  }

  String _formatName(String commonName){
    if ( commonName.trim().isEmpty ){
      return commonName;
    }

    commonName = commonName.trim();

    int posSeparator = commonName.lastIndexOf(':');

    return commonName.substring( 0, posSeparator ).trim();
  }

  @override
  void initState() {
    super.initState();
    _loadCertificates(context);
  }

  @override
  Widget build(BuildContext context) {
    String uri =
        "https://api.flutter.dev/flutter/material/DataTable-class.html";

    return Scaffold(
      appBar: AppBar(
        title:
            const Center(child: Text('Aplicação teste para estudo de Flutter')),
      ),
      //Padding para que os elementos nao fiquem colados nas bordas das telas
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 30.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
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
                options: const LinkifyOptions(humanize: false, removeWww: true),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _updateCertificates(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  ),
                  child: const Text(
                    'UpdateCertificates',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _clearCertificates(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  ),
                  child: const Text(
                    'ClearCertificates',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 400,
              alignment: Alignment.center,
              child: _loading ? LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return SizedBox(
                          height: constraints.maxHeight * 0.67,
                          child: Image.asset('assets/images/loading.gif',
                              fit: BoxFit.cover),
                        );
                      },
                    )
                  : certificateDataTable( _certificates ), // certificateDataTable(people),
            ),
          ],
        ),
      ),
    );
  }

  Widget certificateDataTable(List<CertificateInfo> certificate) {

    return certificate.isEmpty ?
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                height: constraints.maxHeight * 0.67,
                child: Image.asset('assets/images/no-data-found.png',
                    fit: BoxFit.cover),
              );
            },
          )
        : DataTable(
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
            rows: certificate
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          _formatName(e.requerente),
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          e.document,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          e.type,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          );
  }
}
