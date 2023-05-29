// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eatch/servicesAPI/get_categories.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/menus_repository.dart';
import 'menu_card.dart';

class Menu extends ConsumerStatefulWidget {
  const Menu({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Menu> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
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

  final List<TextEditingController> _controllerInput = [];
  final List<Widget> _textFieldInput = [];
  String? matiere;

  bool ajout = false;
  bool test = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataCategoriesFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listCategories);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listCategories);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, context, List<Categorie> categoriee) {
    return AppLayout(
      content: SizedBox(
        height: height,
        width: width,
        child: Column(
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
                        const Text('Menus'),
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
                          label: const Text('Ajouter un menu'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 400,
                    child: Creation(categoriee, height, width),
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
              height: ajout == false ? height - 145 : height - 465,
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 500,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 30,
                            mainAxisExtent: 200),
                    itemBuilder: (context, index) {
                      return Container(
                        child: MenuCard(
                          description: menusList[index].description,
                          imageUrl: menusList[index].imageUrl,
                          price: menusList[index].price,
                          title: menusList[index].title,
                          index: index,
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

  Widget verticalView(
      double height, double width, context, List<Categorie> categoriee) {
    return AppLayout(
      content: SizedBox(
        height: height,
        width: width,
        child: Column(
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
                        const Text('Menus'),
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
                          label: const Text('Ajouter un menu'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 400,
                    child: Creation(categoriee, height, width),
                  ),
            ajout == true
                ? const Divider(
                    height: 5,
                    color: Palette.yellowColor,
                  )
                : const SizedBox(
                    height: 5,
                  ),
            SizedBox(
              height: ajout == false ? height - 216 : height - 536,
              child: SingleChildScrollView(
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 500,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 50,
                            mainAxisExtent: 200),
                    itemBuilder: (context, index) {
                      return Container(
                        child: MenuCard(
                          description: menusList[index].description,
                          imageUrl: menusList[index].imageUrl,
                          price: menusList[index].price,
                          title: menusList[index].title,
                          index: index,
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

  Widget Creation(List<Categorie> categoriee, heigth, width) {
    return Container(
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
            SizedBox(
              width: width - 50,
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
                    labelText: "Nom",
                    hintText: "Entrer le nom du menu",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: const Icon(Icons.food_bank)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: width - 50,
              height: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 500,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 50),
                itemCount: categoriee.length,
                itemBuilder: (context, index) {
                  List<String> listProduits = [];
                  String? produit;
                  final inputController = TextEditingController();
                  _controllerInput.add(inputController);
                  for (int i = 0; i < categoriee[index].products!.length; i++) {
                    listProduits
                        .add(categoriee[index].products![i].productName!);
                  }

                  return SizedBox(
                    height: 50,
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
                      value: produit,
                      hint: Text(
                        categoriee[index].title!,
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          produit = value!;

                          inputController.text = value;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          produit = value;
                        });
                      },
                      items: listProduits.map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 40,
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
                      for (int i = 0; i < _controllerInput.length; i++) {
                        print(i);
                        if (_controllerInput[i].text.isNotEmpty) {
                          print(_controllerInput[i].text);
                        }
                      }
                      setState(() {
                        ajout = false;
                      });
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
                      backgroundColor: Palette.secondaryBackgroundColor,
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
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
