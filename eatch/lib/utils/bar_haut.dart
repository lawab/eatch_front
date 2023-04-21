import 'package:flutter/material.dart';

import 'palettes/palette.dart';

class BarreHaute extends StatelessWidget {
  const BarreHaute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.primaryBackgroundColor,
      child: Row(
        children: [
          const Spacer(),
          Container(
            width: 180.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            decoration: const BoxDecoration(
              color: Palette.fourthColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(05.0),
                  child: Image.asset(
                    "assets/profile.jpg",
                    height: 30,
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 05.0,
                    ),
                    child: Text(
                      "Daoud Alima",
                      style: TextStyle(
                        color: Palette.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
