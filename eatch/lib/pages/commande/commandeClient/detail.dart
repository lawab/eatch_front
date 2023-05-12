import 'dart:convert';

import 'package:eatch/pages/commande/commandeClient/menuu.dart';
import 'package:eatch/pages/commande/commandeClient/panier.dart';
import 'package:eatch/pages/commande/commandeClient/recapitulatif.dart';
import 'package:eatch/servicesAPI/getCommande.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends ConsumerStatefulWidget {
  final Produits produit;
  final int page;
  const Details({Key? key, required this.produit, required this.page})
      : super(key: key);

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends ConsumerState<Details> {
  @override
  void initState() {
    aa();
    // TODO: implement initState
    super.initState();
  }

  void aa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      panier = prefs.getInt('panier')!.toInt();
    });
    print('panier');
    print(panier);
  }

  int panier = 0;
  bool perso = false;
  bool oignon = false;
  bool sauce = false;
  bool persoboisson = false;
  bool miranda = false;
  bool miranda2 = false;
  bool coca = false;
  bool coca2 = false;
  int count = 1;
  int prix = 100;
  List<ProduitsCommande> listCommander = [];

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataCommandeFuture);
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                //////////////// Interface de gauche avec l'image
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(100),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: AssetImage(widget.produit.imageUrl!),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ),
                ////////////// Interface pour affiche de la commande et des détails
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Palette.violetColor,
                    child: recapitulatif(),
                  ),
                )
              ],
            ),
          ),
          /////////////////// Boutton de retour
          Positioned(
            top: 25,
            right: 50,
            width: 100,
            height: 100,
            child: Container(
              child: Column(
                children: [
                  InkWell(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        Text(
                          'Accueil',
                          style: TextStyle(
                              fontFamily: 'Allerta',
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuClient(
                                    commande: viewModel.listCommande,
                                    page: widget.page,
                                  )));
                    },
                  ),
                ],
              ),
            ),
          ),
          panier == 0
              ? Container()
              : Positioned(
                  left: 0,
                  top: MediaQuery.of(context).size.height / 2 - 50,
                  width: 100,
                  height: 100,
                  child: InkWell(
                    child: Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Palette.marronColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'Panier',
                              style: TextStyle(
                                  fontFamily: 'Boogaloo',
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '2 produits',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                        /**/
                        ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Panier()));
                    },
                  ),
                ),
        ],
      )),
    );
  }

  Widget recapitulatif() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(alignment: Alignment.center, children: [
        /////////////////// Boutton de validation de la commande
        Positioned(
          bottom: 20,
          width: 300,
          height: 50,
          child: Container(
              child: ElevatedButton(
            onPressed: (() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var aa = ProduitsCommande(
                id: widget.produit.id,
                imageUrl: widget.produit.imageUrl,
                title: widget.produit.title,
                price: widget.produit.price,
                nombre: count,
                boisson: miranda == true ? 'Miranda' : 'Coca Cola',
                personnalisation: sauce == true && oignon == true
                    ? 'Sauce, Oignon'
                    : sauce == true
                        ? 'Sauce'
                        : oignon == true
                            ? 'Oignon'
                            : 'Rien',
              );

              String tt = prefs.getString('panierCommande').toString();

              int article = 0;
              // ignore: unnecessary_null_comparison
              if (tt != 'null') {
                var panierCommande = jsonDecode(tt);
                for (int i = 0; i < panierCommande.length; i++) {
                  listCommander
                      .add(ProduitsCommande.fromJson(panierCommande[i]));
                }
                print('6');

                listCommander.add(aa);
              } else {
                print('2');
                listCommander.add(aa);
              }

              var jj = jsonEncode(listCommander);

              prefs.setString('panierCommande', jj);
              article = listCommander.length;
              prefs.setInt('panier', article);
              print('list');
              print(prefs.getString('panierCommande').toString());
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Panier()));
            }),
            style: ElevatedButton.styleFrom(
                backgroundColor: Palette.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                minimumSize: Size(180, 50)),
            child: Text("Ajouter au panier $count pour $prix dh"),
          )),
        ),
        /////////////////// Box d'ajout de la quantité
        Positioned(
          bottom: 90,
          width: 100,
          height: 40,
          child: ajout(),
        ),
        ///////////////// Détails du produit
        Container(
          padding: EdgeInsets.all(50),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.produit.title!,
                style: const TextStyle(
                    fontFamily: 'Allerta',
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${widget.produit.price} MAD',
                style: const TextStyle(
                    fontFamily: 'Allerta',
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Notre tacos français est un mélange unique de saveurs françaises  et mexicaines, chaque bouchée est remplie de viande tendre, de fromage fondant, de légumes croquants et de sauces délicieuses préparées au jour en respectant le processus de qualité HACCP',
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 155, 153, 153),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //////////////////// La personnalisation de la commande
              SizedBox(
                height: 50,
                child: InkWell(
                  child: Row(
                    children: [
                      const Text(
                        "Personnaliser votre commande",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container()),
                      perso == false
                          ? const Icon(
                              Icons.arrow_right_rounded,
                              color: Palette.yellowColor,
                              size: 40,
                            )
                          : const Icon(
                              Icons.arrow_drop_down_outlined,
                              color: Palette.yellowColor,
                              size: 40,
                            ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      perso = !perso;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              //////////////////////// SI la personnalisation est choisi les détails s'affichent sinon non
              perso == false ? Container() : personnalisation(),
              const SizedBox(
                height: 20,
              ),
              ////////////////////// Choix de la boisson
              SizedBox(
                height: 50,
                child: InkWell(
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Choisir sa boisson",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  const Text(
                                    "Choisir un article",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Palette.yellowColor,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: const Text(
                                      '   Obligatoire   ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      persoboisson == false
                          ? const Icon(
                              Icons.arrow_right_rounded,
                              color: Palette.yellowColor,
                              size: 40,
                            )
                          : const Icon(
                              Icons.arrow_drop_down_outlined,
                              color: Palette.yellowColor,
                              size: 40,
                            ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      persoboisson = !persoboisson;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              //////////////////////// si selectionner les détails s'affichent sinon non.
              persoboisson == false ? Container() : boisson(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        ///////////////// FIN Détails du produit
      ]),
    );
  }

///////////////////////Widget du box d'ajout de quantité
  Widget ajout() {
    return Container(
      width: 100,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Palette.greenColors),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                setState(() {
                  if (count > 1) {
                    count--;
                    prix = 100 * count;
                  }
                });
              },
              child: Icon(
                Icons.remove,
                color: Colors.white,
                size: 16,
              )),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 3),
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3), color: Colors.white),
              child: Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  count++;
                  prix = 100 * count;
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 16,
              )),
        ],
      ),
    );
  }

////////////////////////// Widget pour la personnalisation. choix multiple
  Widget personnalisation() {
    return Container(
      child: Column(
        children: [
          InkWell(
            child: Row(
              children: [
                const Text(
                  "Sauce",
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(child: Container()),
                sauce == false
                    ? const Icon(
                        Icons.add_circle_outline_outlined,
                        color: Palette.yellowColor,
                      )
                    : const Icon(
                        Icons.done_outline_rounded,
                        color: Palette.yellowColor,
                      ),
              ],
            ),
            onTap: () {
              setState(() {
                sauce = !sauce;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: Row(
              children: [
                const Text(
                  "Sans oignon",
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(child: Container()),
                oignon == false
                    ? const Icon(
                        Icons.add_circle_outline_outlined,
                        color: Palette.yellowColor,
                      )
                    : const Icon(
                        Icons.done_outline_rounded,
                        color: Palette.yellowColor,
                      ),
              ],
            ),
            onTap: () {
              setState(() {
                oignon = !oignon;
              });
            },
          ),
        ],
      ),
    );
  }

////////////////////////// Widget pour les boissons. choix unique
  Widget boisson() {
    return Container(
      child: Column(
        children: [
          InkWell(
            child: Row(
              children: [
                Text(
                  "Miranda",
                  style: TextStyle(
                      color: miranda2 == false ? Colors.white : Colors.grey),
                ),
                Expanded(child: Container()),
                miranda2 == false
                    ? miranda == false
                        ? const Icon(
                            Icons.add_circle_outline_outlined,
                            color: Palette.yellowColor,
                          )
                        : const Icon(
                            Icons.done_outline_rounded,
                            color: Palette.yellowColor,
                          )
                    : const Icon(
                        Icons.add_circle_outline_outlined,
                        color: Colors.grey,
                      ),
              ],
            ),
            onTap: () {
              setState(() {
                if (miranda2 != true) {
                  miranda = !miranda;
                  coca2 = !coca2;
                }
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: Row(
              children: [
                Text(
                  "Coca-Cola",
                  style: TextStyle(
                      color: coca2 == false ? Colors.white : Colors.grey),
                ),
                Expanded(child: Container()),
                coca2 == false
                    ? coca == false
                        ? const Icon(
                            Icons.add_circle_outline_outlined,
                            color: Palette.yellowColor,
                          )
                        : const Icon(
                            Icons.done_outline_rounded,
                            color: Palette.yellowColor,
                          )
                    : const Icon(
                        Icons.add_circle_outline_outlined,
                        color: Colors.grey,
                      ),
              ],
            ),
            onTap: () {
              setState(() {
                if (coca2 != true) {
                  coca = !coca;
                  miranda2 = !miranda2;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class ProduitsCommande {
  String? id;
  String? imageUrl;
  String? title;
  int? price;
  int? nombre;
  String? boisson;
  String? personnalisation;

  ProduitsCommande(
      {this.id,
      this.imageUrl,
      this.title,
      this.price,
      this.nombre,
      this.boisson,
      this.personnalisation});

  ProduitsCommande.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    title = json['title'];
    price = json['price'];
    nombre = json['nombre'];
    boisson = json['boisson'];
    personnalisation = json['personnalisation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['title'] = this.title;
    data['price'] = this.price;
    data['nombre'] = this.nombre;
    data['boisson'] = this.boisson;
    data['personnalisation'] = this.personnalisation;
    return data;
  }
}
