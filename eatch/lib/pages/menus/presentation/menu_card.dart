import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
    for (int i = 0; i < widget.prod.length; i++) {
      afficheProdMenu += widget.prod[i].productName + ' ';
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 7,
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  "http://13.39.81.126:4009${widget.imageUrl}",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          "Pas d'image",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 180,
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0.8),
                    ],
                        stops: const [
                      0.6,
                      1
                    ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Palette.primaryBackgroundColor,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Palette.primaryBackgroundColor,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    Text(
                      afficheProdMenu,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Palette.primaryBackgroundColor,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    Text(
                      NumberFormat.simpleCurrency(name: "MAD ")
                          .format(widget.price),
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Palette.primaryColor,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                    "http://13.39.81.126:4009${widget.imageUrl}",
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