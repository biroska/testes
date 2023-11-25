import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/certificate_basic_info.dart';
import '../providers/certificate_provider.dart';
import '../utils/format_utils.dart';

class ListTileScreen extends StatelessWidget {
  const ListTileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTileExample();
  }
}

class ListTileExample extends StatefulWidget {
  const ListTileExample({super.key});

  @override
  State<ListTileExample> createState() =>
      _ListTileExampleState();
}

class _ListTileExampleState extends State<ListTileExample> {
  Future<List<CertificateInfo>?>? _certificateList;

  bool _loading = true;
  String testeState = '';
  List<CertificateInfo> _certificates = List.empty(growable: true);

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

  @override
  void initState() {
    super.initState();
    _loadCertificates(context);
  }

  @override
  Widget build(BuildContext context) {
    String uri =
        "https://api.flutter.dev/flutter/material/ListTile-class.html";

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
                  : certificateListTile( _certificates ), // certificateDataTable(people),
            ),
          ],
        ),
      ),
    );
  }

  Widget certificateListTile(List<CertificateInfo> certificate) {
    return ListView.builder(
      itemCount: certificate.length,
      itemBuilder: (ctx, index) {
        final cer = certificate[index];

        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: index % 2 == 0 ? Colors.white : Colors.black12,
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: FittedBox(
                    child: Text('R\$ $index'),
                  )),
            ),
            title: Text(
              FormatUtils.formatName(cer.requerente),
              // style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(cer.document),
            trailing: ElevatedButton(
              onPressed: () => (),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Renovar')
            ),
          ),
        );
      },
    );
  }
}
