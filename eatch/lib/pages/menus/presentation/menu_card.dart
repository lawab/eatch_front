import 'package:eatch/servicesAPI/getMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../utils/palettes/palette.dart';

class MenuCard extends ConsumerStatefulWidget {
  const MenuCard(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.price,
      required this.categorie,
      required this.index})
      : super(key: key);
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final Category categorie;
  final int index;

  @override
  ConsumerState<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends ConsumerState<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      //color: const Color.fromARGB(255, 22, 21, 21),
      child: Column(
        children: [
          Container(
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
                    //crossAxisAlignment: CrossAxisAlignment.start,
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
                      "http://192.168.11.110:4009${widget.imageUrl}",
                    ),
                  ),
                ),
              ],
            ),
          ),
          /////////
          const SizedBox(height: 1),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => null,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Palette.secondaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text("Modification"),
                  ),
                ),
              ),
              const SizedBox(height: 0.5),
              Expanded(
                child: InkWell(
                  onTap: () => null,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Palette.deleteColors,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text("Suppression"),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
  ///////
}





/*

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      color: const Color.fromARGB(255, 22, 21, 21),
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
                    "http://192.168.11.110:4009${widget.imageUrl}",
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