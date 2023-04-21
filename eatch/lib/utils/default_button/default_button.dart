import 'package:flutter/material.dart';

import '../palettes/palette.dart';
import '../size/size.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textcolor;
  final Color foreground;
  final VoidCallback? onPressed;

  const DefaultButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.color,
    required this.textcolor,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: getProportionateScreenHeight(95.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Palette.colorShadow,
            blurRadius: 4,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: foreground,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textcolor,
          ),
        ),
      ),
    );
  }
}
