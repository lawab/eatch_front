import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../utils/palettes/palette.dart';

class MenuCard extends ConsumerStatefulWidget {
  const MenuCard(
      {Key? key,
      required this.imageUrl,
      required this.sId,
      required this.title,
      required this.description,
      required this.price,
      required this.prod,
      required this.index})
      : super(key: key);
  final String imageUrl;
  final String sId;
  final String title;
  final String description;
  final double price;
  final List prod;

  final int index;

  @override
  ConsumerState<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends ConsumerState<MenuCard> {
  @override
  Widget build(BuildContext context) {
    String afficheProdMenu = "";
    for (int i = 0; i < widget.prod.length; i++)
      afficheProdMenu += widget.prod[i].productName + ' ';

    return Container(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: const BoxDecoration(
          color: Palette.primaryBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        alignment: Alignment.center,
        height: 153,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Palette.textPrimaryColor,
                    ),
                  ),
                  Text(
                    widget.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 08.0,
                      color: Palette.textsecondaryColor,
                    ),
                  ),
                  Text(
                    afficheProdMenu,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 08.0,
                      color: Palette.textsecondaryColor,
                    ),
                  ),
                  Text(
                    NumberFormat.simpleCurrency(name: "MAD ")
                        .format(widget.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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
                child: Image.network(
                  "http://192.168.1.105:4009${widget.imageUrl}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/*
class _MenuCardState extends ConsumerState<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      //color: const Color.fromARGB(255, 22, 21, 21),
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
                  child: Image.network(
                    "http://192.168.1.105:4009${widget.imageUrl}",
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
*/
