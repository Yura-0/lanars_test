import 'package:flutter/material.dart';

import 'core/routes.dart';

class LanarsApp extends StatelessWidget {
  const LanarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.auth,
      routes: AppRoutes.getRoutes(),
      home: const Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
