import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:eatch/pages/promotion/Modification_promotion.dart';
import 'package:eatch/servicesAPI/getMenu.dart';
import 'package:eatch/servicesAPI/getProduit.dart';
// import 'package:eatch/servicesAPI/get_produits.dart' as p;
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;

import '../../servicesAPI/get_promotion.dart';
import '../../servicesAPI/multipart.dart';

class PromotionAffiche extends ConsumerStatefulWidget {
  const PromotionAffiche({Key? key}) : super(key: key);

  @override
  PromotionAfficheState createState() => PromotionAfficheState();
}

class PromotionAfficheState extends ConsumerState<PromotionAffiche> {
  bool ajout = false;
  bool img = false;

  var nomController = TextEditingController();
  var descriptionPromo = TextEditingController();
  var stockController = TextEditingController();

  var inputController1 = TextEditingController();

  String? menu;
  String? produit;

  List<String> listDesMenus = [];
  List<String> listDesProduits = [];

  List<int>? _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  Uint8List? selectedImageInBytes;
  bool filee = false;

  bool isLoading = false;
  bool _selectFile = false;

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

  bool test = false;
  DateTime date = DateTime.now();
  bool dd = false;

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
    final viewModel = ref.watch(getDataPromotionFuture);
    return AppLayout(
      content: SingleChildScrollView(
        child: Column(
          children: [
            ajout == false
                ? Container(
                    height: height - 65,
                    child: Column(
                      children: [
                        Container(
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                        ),
                        Container(
                          height: ajout == false ? height - 147 : height - 371,
                          width: width,
                          padding: const EdgeInsets.all(10),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 400,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 50,
                                    mainAxisExtent: 350),
                            itemCount: viewModel.listPromotion.length,
                            itemBuilder: ((context, index) {
                              return index % 2 == 0
                                  ? Card(
                                      elevation: 10,
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                child: Image.network(
                                                  "http://13.39.81.126:5005${viewModel.listPromotion[index].image}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(viewModel
                                                                .listPromotion[
                                                                    index]
                                                                .promotionName!),
                                                          ),
                                                          const Expanded(
                                                            child: Text(
                                                              '100 DH',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              height: 15,
                                                              width: 550 / 2,
                                                              child: ListView
                                                                  .builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount: 3,
                                                                itemBuilder:
                                                                    ((context,
                                                                        index) {
                                                                  return const Icon(
                                                                    Icons.star,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            250,
                                                                            230,
                                                                            50),
                                                                    size: 12,
                                                                  );
                                                                }),
                                                              ),
                                                            ),
                                                          )
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
                                                    Text(
                                                      viewModel
                                                          .listPromotion[index]
                                                          .description!,
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    if (viewModel
                                                            .listPromotion[
                                                                index]
                                                            .menu !=
                                                        null)
                                                      Text(
                                                        viewModel
                                                            .listPromotion[
                                                                index]
                                                            .menu!
                                                            .menuTitle!,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    if (viewModel
                                                            .listPromotion[
                                                                index]
                                                            .product !=
                                                        null)
                                                      Text(
                                                        viewModel
                                                            .listPromotion[
                                                                index]
                                                            .product!
                                                            .productName!,
                                                        textAlign:
                                                            TextAlign.start,
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ModificationPromotion(
                                                            description: viewModel
                                                                .listPromotion[
                                                                    index]
                                                                .description!,
                                                            imageUrl: viewModel
                                                                .listPromotion[
                                                                    index]
                                                                .image!,
                                                            menus: viewModel
                                                                    .listPromotion[
                                                                        index]
                                                                    .menu
                                                                    .isNull
                                                                ? ""
                                                                : viewModel
                                                                    .listPromotion[
                                                                        index]
                                                                    .menu!
                                                                    .sId!,
                                                            products: viewModel
                                                                    .listPromotion[
                                                                        index]
                                                                    .product
                                                                    .isNull
                                                                ? ""
                                                                : viewModel
                                                                    .listPromotion[
                                                                        index]
                                                                    .product!
                                                                    .sId!,
                                                            sId: viewModel
                                                                .listPromotion[
                                                                    index]
                                                                .sId!,
                                                            title: viewModel
                                                                .listPromotion[
                                                                    index]
                                                                .promotionName!,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: Palette
                                                            .secondaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                          "Modifier"),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 0.5),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      dialogDelete(
                                                          viewModel
                                                              .listPromotion[
                                                                  index]
                                                              .promotionName!,
                                                          viewModel
                                                              .listPromotion[
                                                                  index]
                                                              .sId!);
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: Palette
                                                            .deleteColors,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                          "Supprimer"),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(viewModel
                                                                .listPromotion[
                                                                    index]
                                                                .promotionName!),
                                                          ),
                                                          const Expanded(
                                                            child: Text(
                                                              '100 DH',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              height: 15,
                                                              width: 550 / 2,
                                                              child: ListView
                                                                  .builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount: 5,
                                                                itemBuilder:
                                                                    ((context,
                                                                        index) {
                                                                  return const Icon(
                                                                    Icons.star,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            250,
                                                                            230,
                                                                            50),
                                                                    size: 12,
                                                                  );
                                                                }),
                                                              ),
                                                            ),
                                                          )
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
                                                    Text(
                                                      viewModel
                                                          .listPromotion[index]
                                                          .description!,
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    if (viewModel
                                                            .listPromotion[
                                                                index]
                                                            .menu !=
                                                        null)
                                                      Text(
                                                        viewModel
                                                            .listPromotion[
                                                                index]
                                                            .menu!
                                                            .menuTitle!,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    if (viewModel
                                                            .listPromotion[
                                                                index]
                                                            .product !=
                                                        null)
                                                      Text(
                                                        viewModel
                                                            .listPromotion[
                                                                index]
                                                            .product!
                                                            .productName!,
                                                        textAlign:
                                                            TextAlign.start,
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                child: Image.network(
                                                  "http://13.39.81.126:5005${viewModel.listPromotion[index].image}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ModificationPromotion(
                                                            description: viewModel
                                                                .listPromotion[
                                                                    index]
                                                                .description!,
                                                            imageUrl: viewModel
                                                                .listPromotion[
                                                                    index]
                                                                .image!,
                                                            menus: viewModel
                                                                    .listPromotion[
                                                                        index]
                                                                    .menu
                                                                    .isNull
                                                                ? ""
                                                                : viewModel
                                                                    .listPromotion[
                                                                        index]
                                                                    .menu!
                                                                    .sId!,
                                                            products: viewModel
                                                                    .listPromotion[
                                                                        index]
                                                                    .product
                                                                    .isNull
                                                                ? ""
                                                                : viewModel
                                                                    .listPromotion[
                                                                        index]
                                                                    .product!
                                                                    .sId!,
                                                            sId: viewModel
                                                                .listPromotion[
                                                                    index]
                                                                .sId!,
                                                            title: viewModel
                                                                .listPromotion[
                                                                    index]
                                                                .promotionName!,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: Palette
                                                            .secondaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                          "Modifier"),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 0.5),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      dialogDelete(
                                                          viewModel
                                                              .listPromotion[
                                                                  index]
                                                              .promotionName!,
                                                          viewModel
                                                              .listPromotion[
                                                                  index]
                                                              .sId!);
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: Palette
                                                            .deleteColors,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                          "Supprimer"),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                            }),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: Palette.secondaryBackgroundColor,
                    child: creation(listDesMenus, listDesProduits),
                  ),
            // ajout == true
            //     ? const Divider(
            //         height: 5,
            //         color: Palette.yellowColor,
            //       )
            //     : const SizedBox(
            //         height: 5,
            //       ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
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
                          child: const Row(
                            children: [
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
                              //for (int i = 0; i < menus.length; i++)
                              setState(() {
                                //listDesMenus[i].text = value.toString();
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                //for (int i = 0; i < menus.length; i++)
                                ///listDesMenus[i].text = value.toString();
                              });
                            },
                            items: listDesMenus.map((val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                              //for (int j = 0; j < listDesProduits.length; j++)
                              // setState(() {
                              //   listDesProduits[j].text = value.toString();
                              // });
                            },
                            onSaved: (value) {
                              // setState(() {
                              //   for (int j = 0; j < produits.length; j++)
                              //     listDesProduits[j].text = value.toString();
                              // });
                            },
                            items: listDesProduits.map((val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
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
                                        child: const Row(
                                          children: [
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
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget creation(List<String> listDesMenus, List<String> listDesProduits) {
    final viewModel1 = ref.watch(getDataMenuFuture);
    final viewModel2 = ref.watch(getDataProduitFuture);
    print('viewModel2.listProduit.length');
    print(viewModel2.listProduit.length);
    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          height: 50,
          color: Palette.yellowColor,
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
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
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
                      hintText: "Entrer le nom du type",
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: const Icon(Icons.food_bank)),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ///////
        SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                  controller: descriptionPromo,
                  maxLines: 2,
                  maxLength: 100,
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
                    hintText: "Entrer la description de la promotion",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: const Icon(Icons.description),
                  ),
                ),
              ),
              const SizedBox(
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
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
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
                  value: menu,
                  hint: const Text('Veuillez choisir le menu'),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      menu = value;
                      print('Valeur : $menu');
                    });
                  },
                  items: viewModel1.listMenus.map((val) {
                    return DropdownMenuItem(
                      value: val.sId,
                      child: Text(
                        val.menuTitle!,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
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
                  hint: const Text('Veuillez choisir le produit'),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      produit = value;
                      print('Valeur 1 : $produit');
                    });
                  },
                  items: viewModel2.listProduit.map((val) {
                    return DropdownMenuItem(
                      value: val.sId,
                      child: Text(
                        val.productName!,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // début --------------------------------------------
        SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          child: Row(
            children: [
              const SizedBox(width: 25),
              const Text(
                "Fin de la promotion",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (newDate == null) return;

                  setState(() {
                    date = newDate;
                    dd = true;
                  });
                  print(date);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primaryColor,
                  minimumSize: const Size(150, 40),
                  maximumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: dd == false
                    ? Text(
                        "${date.year}-${date.month}-${date.day}",
                        style: const TextStyle(fontSize: 18),
                      )
                    : Text(
                        "${date.year}-${date.month}-${date.day}",
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
        // fin --------------------------------------------

        const SizedBox(
          height: 20,
        ),

        Container(
          padding: const EdgeInsets.only(right: 70),
          color: Palette.secondaryBackgroundColor,
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () async {
              result = await FilePicker.platform
                  .pickFiles(type: FileType.custom, allowedExtensions: [
                "png",
                "jpg",
                "jpeg",
              ]);
              if (result != null) {
                setState(() {
                  file = result!.files.single;

                  Uint8List fileBytes = result!.files.single.bytes as Uint8List;

                  _selectedFile = fileBytes;

                  filee = true;

                  selectedImageInBytes = result!.files.first.bytes;
                  _selectFile = true;
                });
              }
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 4,
                  color: Palette.greenColors,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _selectFile == false
                    ? const Icon(
                        Icons.camera_alt_outlined,
                        color: Palette.greenColors,
                        size: 40,
                      )
                    : Image.memory(
                        selectedImageInBytes!,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
          ),
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
                  creationPromotion(
                      context,
                      nomController.text,
                      descriptionPromo.text,
                      menu,
                      produit,
                      date.toString(),
                      _selectedFile!,
                      result);
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
      ],
    );
  }

  Future dialogDelete(String nom, String idPromotions) {
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
                  onPressed: () {
                    deletePromotion(context, idPromotions);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
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

  ///////// - Création de Promotion
  ///
  Future<void> creationPromotion(
    BuildContext context,
    String nomPromo,
    String descriptionPromo,
    String? idDuMenu,
    String? idDuProduit,
    String endPromo,
    List<int> selectedFile,
    FilePickerResult? result,
  ) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var restaurantId = prefs.getString('idRestaurant').toString();
    var token = prefs.getString('token');

    //String adressUrl = prefs.getString('ipport').toString();

    var url = Uri.parse(
        "http://13.39.81.126:5005/api/promotions/create"); // 13.39.81.126:4009
    final request = MultipartRequest(
      'POST',
      url,
      // ignore: avoid_returning_null_for_void
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );

    var json = {
      '_creator': id,
      'restaurant': restaurantId,
      'promotion_name': nomPromo,
      'description': descriptionPromo,
      'menu': idDuMenu,
      'product': idDuProduit,
      'end_date': endPromo,
    };

    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromBytes('file', selectedFile,
        contentType: MediaType('application', 'octet-stream'),
        filename: result?.files.first.name));

    print("RESPENSE SEND STEAM FILE REQ");
    //var responseString = await streamedResponse.stream.bytesToString();
    var response = await request.send();
    print("Upload Response" + response.toString());
    print(response.statusCode);
    print(request.headers);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });
        //stopMessage();
        //finishWorking();
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "La promotion a été crée",
          ),
        );
        ref.refresh(getDataPromotionFuture);
        setState(() {
          //_clear();
        });
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "La promotion n'a pas été crée",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      throw e;
    }
  }

  ////////// - Suppression de Promotion
  ///
  Future<http.Response> deletePromotion(
      BuildContext context, String idPromotion) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getString('IdUser').toString();

      //String adressUrl = prefs.getString('ipport').toString();

      var token = prefs.getString('token');
      String urlDelete =
          "http://13.39.81.126:5005/api/promotions/delete/$idPromotion"; // 13.39.81.126:4008 //$adressUrl

      var json = {
        '_creator': id,
      };
      var body = jsonEncode(json);

      final http.Response response =
          await http.delete(Uri.parse(urlDelete), headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Accept': 'application/json',
        'authorization': 'Bearer $token',
        'body': body,
      });

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "La promotion a été supprimée avec succès",
          ),
        );
        ref.refresh(getDataPromotionFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.deleteColors,
            message: "La promotion n'a pas été supprimée avec succès",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
