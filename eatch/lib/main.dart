import 'package:flutter/material.dart';

import 'pages/dashboard/dashboard_manager.dart';

void main() {
  runApp(const Eatch());
}

class Eatch extends StatelessWidget {
  const Eatch({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardManager(),
    );
  }
}
