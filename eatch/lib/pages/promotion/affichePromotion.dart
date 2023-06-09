import 'package:eatch/servicesAPI/getMatiere.dart';
import 'package:eatch/servicesAPI/getMenu.dart';
import 'package:eatch/servicesAPI/get_produits.dart' as p;
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PromotionAffiche extends ConsumerStatefulWidget {
  const PromotionAffiche({Key? key}) : super(key: key);

  @override
  PromotionAfficheState createState() => PromotionAfficheState();
}

class PromotionAfficheState extends ConsumerState<PromotionAffiche> {
  bool ajout = false;
  bool img = false;
  var nomController = TextEditingController();
  var stockController = TextEditingController();

  List<TextEditingController> listDesMenus = [];
  List<TextEditingController> listDesProduits = [];

  MediaQueryData mediaQueryData(BuildContext context) {
    return MediaQuery.of(context);
  }

  Size size(BuildContext buildContext) {
    return mediaQueryData(buildContext).size;
  }

  double width(BuildContext buildContext) {
    return size(buildContext).width;
  }

  double height(BuildContext buildContext) {
    return size(buildContext).height;
  }

  @override
  Widget build(BuildContext context) {
    //final viewModel = ref.watch(getDataMatiereFuture);
    final viewModel = ref.watch(getDataMenuFuture);
    final viewModel1 = ref.watch(p.getDataProduitFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listMenus, viewModel1.listProduit);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listMenus, viewModel1.listProduit);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, context, List<Menus> menus,
      List<p.Products> produits) {
    return AppLayout(
        content: Column(
      children: [
        ajout == false
            ? Container(
                alignment: Alignment.centerRight,
                height: 80,
                color: Palette.yellowColor,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    const Text('Promotions'),
                    Expanded(child: Container()),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(180, 50)),
                      onPressed: () {
                        setState(() {
                          ajout = true;
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter une promotion'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              )
            : Container(
                height: 300,
                color: Palette.secondaryBackgroundColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        height: 50,
                        color: const Color(0xFFFCEBD1),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            Text('Création de promotion'),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: TextFormField(
                          controller: nomController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                              hoverColor: Palette.primaryBackgroundColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 42, vertical: 20),
                              filled: true,
                              fillColor: Palette.primaryBackgroundColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              labelText: "Nom du type",
                              hintText: "Entrer le nom du type",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const Icon(Icons.food_bank)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            hoverColor: Palette.primaryBackgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 42, vertical: 20),
                            filled: true,
                            fillColor: Palette.primaryBackgroundColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          //value: produit,
                          hint: const Text('Veuillez choisir le menu'),
                          validator: (value) {
                            if (value == null) {
                              return "Le choix du menu est obligatoire.";
                            } else {
                              return null;
                            }
                          },
                          isExpanded: true,
                          onChanged: (value) {
                            for (int i = 0; i < menus.length; i++)
                              setState(() {
                                listDesMenus[i].text = value.toString();
                              });
                          },
                          onSaved: (value) {
                            setState(() {
                              for (int i = 0; i < menus.length; i++)
                                listDesMenus[i].text = value.toString();
                            });
                          },
                          items: menus.map((val) {
                            return DropdownMenuItem(
                              value: val.sId,
                              child: Text(
                                val.menuTitle!,
                              ),
                            );
                          }).toList(),
                        ),
                        //const Text('MENU'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            hoverColor: Palette.primaryBackgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 42, vertical: 20),
                            filled: true,
                            fillColor: Palette.primaryBackgroundColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          //value: produit,
                          hint: const Text('Veuillez choisir le produit'),
                          validator: (value) {
                            if (value == null) {
                              return "Le choix du produit est obligatoire.";
                            } else {
                              return null;
                            }
                          },
                          isExpanded: true,
                          onChanged: (value) {
                            //for (int j = 0; j < produits.length; j++)
                            setState(() {
                              //listDesProduits[j].text = value.toString();
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              //for (int j = 0; j < produits.length; j++)
                              //listDesProduits[j].text = value.toString();
                            });
                          },
                          items: produits.map((val) {
                            return DropdownMenuItem(
                              value: val.sId,
                              child: Text(
                                val.productName!,
                              ),
                            );
                          }).toList(),
                        ),
                        // child: const Text('PRODUITS'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: const Text('MATIERE PREMIERE'),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 350,
                          child: Row(children: [
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: (() {
                                setState(() {});
                              }),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.primaryColor,
                                minimumSize: const Size(150, 50),
                                maximumSize: const Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Enregistrer'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: (() {
                                setState(() {
                                  ajout = false;
                                });
                              }),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Palette.secondaryBackgroundColor,
                                minimumSize: const Size(150, 50),
                                maximumSize: const Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text(
                                'Annuler',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ajout == true
            ? const Divider(
                height: 5,
                color: Palette.yellowColor,
              )
            : const SizedBox(
                height: 5,
              ),
        Container(
          height: ajout == false ? height - 147 : height - 371,
          width: width,
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 50,
                  mainAxisExtent: 350),
              itemCount: 5,
              itemBuilder: ((context, index) {
                return index % 2 == 0
                    ? Card(
                        elevation: 10,
                        child: Container(
                            child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  image: DecorationImage(
                                      opacity: 50,
                                      image: AssetImage('boisson.png'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: const Row(
                                      children: [
                                        Expanded(
                                          child: Text('Menu Ramadan'),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '100 DH',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          child: const Text(
                                              'Nombre de Commandes :  '),
                                        ),
                                        const Expanded(
                                          child: Text('158'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 15,
                                    width: 550 / 2,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder: ((context, index) {
                                        return const Icon(
                                          Icons.star,
                                          color:
                                              Color.fromARGB(255, 250, 230, 50),
                                          size: 12,
                                        );
                                      }),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                      "Cette promotion composée d'un burger,une boisson,d'un mini burger,des frites maxi")
                                ],
                              ),
                            ))
                          ],
                        )),
                      )
                    : Card(
                        elevation: 10,
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                          children: const [
                                            Expanded(
                                              child: Text('Menu Ramadan'),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '100 DH',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              child: const Text(
                                                  'Nombre de Commandes :  '),
                                            ),
                                            const Expanded(
                                              child: Text('158'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 15,
                                        width: 550 / 2,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 5,
                                          itemBuilder: ((context, index) {
                                            return const Icon(
                                              Icons.star,
                                              color: Color.fromARGB(
                                                  255, 250, 230, 50),
                                              size: 12,
                                            );
                                          }),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                          "Cette promotion composée d'un burger,une boisson,d'un mini burger,des frites maxi")
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                        opacity: 50,
                                        image: AssetImage('boisson.png'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              })),
        ),
      ],
    ));
  }

  Widget verticalView(double height, double width, context, List<Menus> menus,
      List<p.Products> produits) {
    return AppLayout(
        content: Column(
      children: [
        ajout == false
            ? Container(
                alignment: Alignment.centerRight,
                height: 80,
                color: Palette.yellowColor,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    const Text('Promotions'),
                    Expanded(child: Container()),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(180, 50)),
                      onPressed: () {
                        setState(() {
                          ajout = true;
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter un type de matière'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              )
            : Container(
                height: 300,
                color: Palette.secondaryBackgroundColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        height: 50,
                        color: const Color(0xFFFCEBD1),
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 50,
                            ),
                            Text('Création de Type de matière première'),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: TextFormField(
                          controller: nomController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                              hoverColor: Palette.primaryBackgroundColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 42, vertical: 20),
                              filled: true,
                              fillColor: Palette.primaryBackgroundColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              labelText: "Nom du type",
                              hintText: "Entrer le nom du type",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const Icon(Icons.food_bank)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: const Text('MENU'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: const Text('PRODUITS'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: const Text('MATIERE PREMIERE'),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 350,
                          child: Row(children: [
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: (() {
                                setState(() {});
                              }),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.primaryColor,
                                minimumSize: const Size(150, 50),
                                maximumSize: const Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Enregistrer'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: (() {
                                setState(() {
                                  ajout = false;
                                });
                              }),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Palette.secondaryBackgroundColor,
                                minimumSize: const Size(150, 50),
                                maximumSize: const Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text(
                                'Annuler',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ajout == true
            ? const Divider(
                height: 5,
                color: Palette.yellowColor,
              )
            : const SizedBox(
                height: 5,
              ),
        Container(
          height: ajout == false ? height - 226 : height - 436,
          width: width,
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 50,
                mainAxisExtent: 350),
            itemCount: 5,
            itemBuilder: ((context, index) {
              return index % 2 == 0
                  ? Card(
                      elevation: 10,
                      child: Container(
                          child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(
                                    opacity: 50,
                                    image: AssetImage('boisson.png'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        child: Text('Menu Ramadan'),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '100 DH',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: const Text(
                                            'Nombre de Commandes :  '),
                                      ),
                                      const Expanded(
                                        child: Text('158'),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 15,
                                  width: 550 / 2,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder: ((context, index) {
                                      return const Icon(
                                        Icons.star,
                                        color:
                                            Color.fromARGB(255, 250, 230, 50),
                                        size: 12,
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                    "Cette promotion composée d'un burger,une boisson,d'un mini burger,des frites maxi")
                              ],
                            ),
                          ))
                        ],
                      )),
                    )
                  : Card(
                      elevation: 10,
                      child: Container(
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Row(
                                        children: const [
                                          Expanded(
                                            child: Text('Menu Ramadan'),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '100 DH',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: const Text(
                                                'Nombre de Commandes :  '),
                                          ),
                                          const Expanded(
                                            child: Text('158'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 15,
                                      width: 550 / 2,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 5,
                                        itemBuilder: ((context, index) {
                                          return const Icon(
                                            Icons.star,
                                            color: Color.fromARGB(
                                                255, 250, 230, 50),
                                            size: 12,
                                          );
                                        }),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                        "Cette promotion composée d'un burger,une boisson,d'un mini burger,des frites maxi")
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  image: DecorationImage(
                                      opacity: 50,
                                      image: AssetImage('boisson.png'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            }),
          ),
        ),
      ],
    ));
  }

  Future dialogDelete(String nom) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Confirmez la suppression",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ),
            actions: [
              ElevatedButton.icon(
                  icon: const Icon(
                    Icons.close,
                    size: 14,
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  label: const Text("Quitter   ")),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                  icon: const Icon(
                    Icons.delete,
                    size: 14,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.deleteColors),
                  onPressed: () {},
                  label: const Text("Supprimer."))
            ],
            content: Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 150,
              child: Text(
                "Voulez vous supprimer $nom ?",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ),
          );
        });
  }
}
