import 'package:flutter/material.dart';

class BarHaut extends StatelessWidget {
  const BarHaut({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
        ),
      ),
    );
  }
}
