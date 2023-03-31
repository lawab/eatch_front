import 'package:flutter/material.dart';

class BarHaute extends StatelessWidget {
  const BarHaute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.red,
          child: const Text("Bar Haute"),
        ),
      ),
    );
  }
}
