import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/palettes/palette.dart';

class MenuCard extends StatefulWidget {
  const MenuCard(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.price,
      required this.index})
      : super(key: key);
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final int index;

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      color: Palette.primaryBackgroundColor,
      child: InkWell(
        onTap: () {
          print('object ${widget.index}');
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Palette.primaryBackgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          alignment: Alignment.center,
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Palette.textPrimaryColor,
                      ),
                    ),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 08.0,
                        color: Palette.textsecondaryColor,
                      ),
                    ),
                    Text(
                      NumberFormat.simpleCurrency(name: "MAD ")
                          .format(widget.price),
                      style: const TextStyle(
                        fontSize: 08,
                        fontWeight: FontWeight.bold,
                        color: Palette.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 05.0),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  child: Image.asset(
                    widget.imageUrl,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
