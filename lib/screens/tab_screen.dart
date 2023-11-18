import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TabScreen extends StatelessWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TabBarExample();
  }
}

class TabBarExample extends StatelessWidget {
  const TabBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    String uri = "https://api.flutter.dev/flutter/material/TabBar-class.html";

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Tab Bar'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp),
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("It's cloudy here"),
                Linkify(
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
              ],
            ),
            const Center(
              child: Text("It's rainy here"),
            ),
            const Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ),
    );
  }
}
