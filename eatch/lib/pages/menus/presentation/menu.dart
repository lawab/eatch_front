// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';

import '../../categories/infrastructure/categories_repository.dart';
import '../infrastructure/menus_repository.dart';
import 'menu_card.dart';

class Menu extends StatefulWidget {
  const Menu({
    Key? key,
  }) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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

  var nomcontroller = TextEditingController();
  String? produit;
  List<String> listProduits = [
    "Tacos",
    "Pizza",
    "Burger",
  ];
  String? matiere;
  List<String> listMatiere = [
    "frite",
  ];

  bool ajout = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, context) {
    return AppLayout(
      content: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            ajout == false
                ? Container(
                    alignment: Alignment.centerRight,
                    height: 80,
                    color: Color(0xFFFCEBD1),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Text('Menus'),
                        Expanded(child: Container()),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minimumSize: Size(180, 50)),
                          onPressed: () {
                            setState(() {
                              ajout = true;
                            });
                            /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantCreation()));*/
                          },
                          icon: Icon(Icons.add),
                          label: Text('Ajouter un menu'),
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
                            color: Color(0xFFFCEBD1),
                            child: Row(
                              children: const [
                                SizedBox(
                                  width: 50,
                                ),
                                Text('Création Menu'),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: TextFormField(
                              controller: nomcontroller,
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
                                        color:
                                            Palette.secondaryBackgroundColor),
                                    gapPadding: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color:
                                            Palette.secondaryBackgroundColor),
                                    gapPadding: 10,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color:
                                            Palette.secondaryBackgroundColor),
                                    gapPadding: 10,
                                  ),
                                  labelText: "Nom",
                                  hintText: "Entrer le nom du restaurant",
                                  // If  you are using latest version of flutter then lable text and hint text shown like this
                                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  suffixIcon: Icon(Icons.food_bank)),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              value: matiere,
                              hint: const Text(
                                'Matière première*',
                              ),
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  matiere = value;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  matiere = value;
                                });
                              },
                              /*validator: (String? value) {
                                if (value == null) {
                                  return "Le rôle de l’utilisateur est obligatoire.";
                                } else {
                                  return null;
                                }
                              },*/
                              items: listMatiere.map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              value: produit,
                              hint: const Text(
                                'Produit*',
                              ),
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  produit = value;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  produit = value;
                                });
                              },
                              /*validator: (String? value) {
                                if (value == null) {
                                  return "Le rôle de l’utilisateur est obligatoire.";
                                } else {
                                  return null;
                                }
                              },*/
                              items: listProduits.map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 350,
                              child: Row(children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  onPressed: (() {
                                    setState(() {});
                                  }),
                                  child: Text('Enregistrer'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Palette.primaryColor,
                                    minimumSize: Size(150, 50),
                                    maximumSize: Size(200, 70),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
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
                                  child: Text(
                                    'Annuler',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Palette.secondaryBackgroundColor,
                                    minimumSize: Size(150, 50),
                                    maximumSize: Size(200, 70),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: ajout == false ? height - 175 : height - 395,
              child: SingleChildScrollView(
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: categoriesList.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 500,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 50,
                            mainAxisExtent: 200),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 18),
                        child: MenuCard(
                          description: menusList[index].description,
                          imageUrl: menusList[index].imageUrl,
                          price: menusList[index].price,
                          title: menusList[index].title,
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(
      content: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: categoriesList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 50,
                mainAxisExtent: 200),
            itemBuilder: (context, index) => MenuCard(
              description: menusList[index].description,
              imageUrl: menusList[index].imageUrl,
              price: menusList[index].price,
              title: menusList[index].title,
            ),
          ),
        ),
      ),
    );
  }
  /*AppLayout(
      content: Container(
        child: SingleChildScrollView(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: categoriesList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              mainAxisSpacing: widget.mainAxisSpacing,
              crossAxisSpacing: widget.crossAxisSpacing,
              childAspectRatio: widget.childAspectRatio,
            ),
            itemBuilder: (context, index) => MenuCard(
              description: menusList[index].description,
              imageUrl: menusList[index].imageUrl,
              price: menusList[index].price,
              title: menusList[index].title,
            ),
          ),
        ),
      ),
    );*/
}
