import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.yellow,
          child: const Text("Navigation"),
        ),
      ),
    );
  }
}
