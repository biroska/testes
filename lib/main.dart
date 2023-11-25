import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testes/providers/certificate_provider.dart';
import 'package:testes/screens/datatable_screen.dart';
import 'package:testes/screens/provider_datatable_screen.dart';
import 'package:testes/screens/listtile_screen.dart';

import 'screens/main_screen.dart';
import 'screens/tab_screen.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CertificateProvider(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainScreen(),
        routes: { AppRoutes.TAB: (context) => const TabScreen( ),
                  AppRoutes.DATA_TABLE: (context) => const DataTableScreen( ),
                  AppRoutes.PROVIDER_DATA_TABLE: (context) => const ProviderDataTableScreen( ),
                  AppRoutes.LIST_TILE: (context) => const ListTileScreen() ,},
      ),
    );
  }
}