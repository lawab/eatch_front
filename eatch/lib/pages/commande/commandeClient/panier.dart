import 'dart:convert';

import 'package:eatch/pages/commande/commandeClient/detail.dart';
import 'package:eatch/pages/commande/commandeClient/menuu.dart';
import 'package:eatch/pages/commande/commandeClient/recapitulatif.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Panier extends ConsumerStatefulWidget {
  const Panier({Key? key}) : super(key: key);

  @override
  PanierState createState() => PanierState();
}

class PanierState extends ConsumerState<Panier> {
  double prixTotal = 0;
  List<ProduitsCommande> listPanier = [];
  @override
  void initState() {
    panierr();
    // TODO: implement initState
    super.initState();
  }

  void panierr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tt = prefs.getString('panierCommande').toString();
    print('object');
    var panierCommande = jsonDecode(tt);
    for (int i = 0; i < panierCommande.length; i++) {
      setState(() {
        listPanier.add(ProduitsCommande.fromJson(panierCommande[i]));
        prixTotal = prixTotal +
            ((listPanier[i].price!.toInt()) * (listPanier[i].nombre!.toInt()))
                .toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                //////////////// Interface de gauche avec l'image
                Expanded(
                  child: Container(
                    color: Palette.violetColor,
                    padding: const EdgeInsets.all(100),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        image: const DecorationImage(
                            image: AssetImage('logo_vert.png'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                ////////////// Interface pour affiche de la commande et des détails
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Palette.violetColor,
                    child: //panier(),
                        ListView.builder(
                      itemCount: listPanier.length,
                      itemBuilder: (contextT, index) {
                        int count = listPanier[index].nombre!;
                        return Card(
                          elevation: 5,
                          child: Container(
                            height: 150,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  listPanier[index].imageUrl!),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                        flex: 6,
                                        child: Container(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              listPanier[index].title!,
                                              style: TextStyle(
                                                  fontFamily: 'Allerta',
                                                  fontSize: 25,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${listPanier[index].price} MAD',
                                              style: TextStyle(
                                                  fontFamily: 'Allerta',
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                '${listPanier[index].personnalisation},${listPanier[index].boisson}'),
                                          ],
                                        ))),
                                  ]),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    child: /*ajout(
                        listPanier[index].nombre!, listPanier[index].price!),*/
                                        Container(
                                      width: 100,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  prixTotal = 0;
                                                  if (count > 0) {
                                                    count--;
                                                    listPanier[index].nombre =
                                                        count;

                                                    for (int i = 0;
                                                        i < listPanier.length;
                                                        i++) {
                                                      prixTotal = prixTotal +
                                                          ((listPanier[i]
                                                                      .price!
                                                                      .toInt()) *
                                                                  (listPanier[i]
                                                                      .nombre!
                                                                      .toInt()))
                                                              .toDouble();
                                                    }
                                                  }
                                                });
                                              },
                                              child: const Icon(
                                                Icons.remove,
                                                color: Colors.black,
                                                size: 16,
                                              )),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3, vertical: 2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: Colors.white),
                                              child: Center(
                                                child: Text(
                                                  listPanier[index]
                                                      .nombre!
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  prixTotal = 0;
                                                  count++;
                                                  listPanier[index].nombre =
                                                      count;

                                                  for (int i = 0;
                                                      i < listPanier.length;
                                                      i++) {
                                                    prixTotal = prixTotal +
                                                        ((listPanier[i]
                                                                    .price!
                                                                    .toInt()) *
                                                                (listPanier[i]
                                                                    .nombre!
                                                                    .toInt()))
                                                            .toDouble();
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                Icons.add,
                                                color: Palette.yellowColor,
                                                size: 16,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          /////////////////// Boutton de retour
          Positioned(
            top: 25,
            left: 50,
            width: 100,
            height: 100,
            child: Container(
              child: Column(
                children: [
                  InkWell(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.close,
                          color: Palette.yellowColor,
                        ),
                        Text(
                          'Retour',
                          style: TextStyle(
                              fontFamily: 'Allerta',
                              fontSize: 15,
                              color: Palette.yellowColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuClient()));*/
                    },
                  ),
                ],
              ),
            ),
          ),
          ///////////////////////////// Bouton de validation du panier
          Positioned(
            bottom: 20,
            width: 300,
            height: 50,
            child: Container(
              child: ElevatedButton(
                onPressed: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Recapitulatif(
                                listRecap: listPanier,
                                prix: prixTotal,
                              )));
                }),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    minimumSize: Size(180, 50)),
                child: Text("Valider le panier pour $prixTotal dh"),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
