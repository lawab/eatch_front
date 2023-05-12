import 'dart:html';

import 'package:eatch/pages/commande/commandeClient/detail.dart';
import 'package:eatch/pages/commande/commandeClient/menuu.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Recapitulatif extends ConsumerStatefulWidget {
  final List<ProduitsCommande> listRecap;
  final double prix;
  Recapitulatif({Key? key, required this.listRecap, required this.prix})
      : super(key: key);

  @override
  RecapitulatifState createState() => RecapitulatifState();
}

class RecapitulatifState extends ConsumerState<Recapitulatif> {
  bool espace = false;
  bool carte = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.yellowColor,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Palette.marronColor),
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width / 2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Votre commande',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 100 - 420,
                  child: ListView.builder(
                    itemCount: widget.listRecap.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            //strokeAlign: StrokeAlign.center,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 30,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text:
                                        '${widget.listRecap[index].nombre}x  ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${widget.listRecap[index].title}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              height: 30,
                              child: Text(
                                '${widget.listRecap[index].price.toString()} MAD',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Mode de paiement',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            color: espace == true
                                ? Palette.yellowColor
                                : Colors.grey,
                            child: Text('En Espece'),
                          ),
                          onTap: () {
                            setState(() {
                              espace = true;
                              carte = false;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            color: carte == true
                                ? Palette.yellowColor
                                : Colors.grey,
                            child: Text('Par carte'),
                          ),
                          onTap: () {
                            setState(() {
                              espace = false;
                              carte = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Palette.marronColor,
                    borderRadius: BorderRadius.circular(15.0),
                    image: const DecorationImage(
                        opacity: 150,
                        image: AssetImage('commande.jpg'),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Expanded(child: Container()),
                          Text(
                            '${widget.prix} Mad',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: (() {}),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              minimumSize: Size(180, 50)),
                          child: Text("Commander"),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
