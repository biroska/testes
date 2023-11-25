import 'package:flutter/material.dart';

import '../utils/app_routes.dart';

class MainScreen extends StatelessWidget {

  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Aplicação teste para estudo de Flutter')),
      ),
      //Padding para que os elementos nao fiquem colados nas bordas das telas
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.TAB),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    ),
                    child: const Text(
                      'Simple TabBar',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.DATA_TABLE),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    ),
                    child: const Text(
                      'Simple Data Table',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.LIST_TILE),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    ),
                    child: const Text(
                      'Provider ListTile',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.PROVIDER_DATA_TABLE),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    ),
                    child: const Text(
                      'Provider Data Table',
                    ),
                  ),
                ],
              ),
          )
      ),
    );
  }
}