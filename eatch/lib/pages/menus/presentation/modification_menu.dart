// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:eatch/servicesAPI/get_categories.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../servicesAPI/getMenu.dart';

import 'package:http/http.dart' as http;
import '../../../servicesAPI/multipart.dart';
import 'menu.dart';

class ModificationMenu extends ConsumerStatefulWidget {
  const ModificationMenu({
    Key? key,
    required this.imageUrl,
    required this.sId,
    required this.title,
    required this.description,
    required this.price,
    required this.products,
  }) : super(key: key);

  final String imageUrl;
  final String sId;
  final String title;
  final String description;
  final double price;
  final List products;

  @override
  ConsumerState<ModificationMenu> createState() => ModificationMenuState();
}

class ModificationMenuState extends ConsumerState<ModificationMenu> {
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

  late var nomcontroller = TextEditingController(text: widget.title);
  late var prixcontroller =
      TextEditingController(text: widget.price.toString());
  late var descriptioncontroller =
      TextEditingController(text: widget.description);

  final List<TextEditingController> _controllerInput = [];
  //final List<Widget> _textFieldInput = [];

  List<String> listProduitsAffiche = [];
  List<String> listProdId = [];

  bool ajout = false;
  bool test = false;

  List<int>? _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  Uint8List? selectedImageInBytes;
  bool filee = false;

  bool isLoading = false;
  bool _selectFile = false;
  String? menuImage;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataCategoriesFuture);

    return AppLayout(
      content: SizedBox(
        child: Container(
          color: Palette.secondaryBackgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  height: 80,
                  color: const Color(0xFFFCEBD1),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      const Text('Modification de menu'),
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.textsecondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(150, 50)),
                        onPressed: () {
                          setState(() {
                            ref.refresh(getDataMenuFuture);
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Menu(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.backspace),
                        label: const Text('Retour'),
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
                      suffixIcon: const Icon(Icons.food_bank),
                    ),
                  ),
                ),
                /////////////////////////////////////////// - début du champ prix
                const SizedBox(
                  height: 20,
                ),

                ///
                SizedBox(
                  child: TextFormField(
                    controller: prixcontroller,
                    keyboardType: TextInputType.number,
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
                      labelText: "Prix",
                      hintText: "Entrer le prix du menu",
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: const Icon(Icons.monetization_on_outlined),
                    ),
                  ),
                ),

                ////////////////////////////////////////////////////////////// - fin du champ prix
                ///

                const SizedBox(
                  height: 20,
                ),

                ///
                //////////////////////////////// - debut du champ description
                ///
                SizedBox(
                  child: TextFormField(
                    maxLength: 500,
                    maxLines: 5,
                    controller: descriptioncontroller,
                    keyboardType: TextInputType.text,
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
                      labelText: "Description",
                      hintText: "Entrer une description pour ce menu",
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      //suffixIcon: const Icon(Icons.monetization_on_outlined),
                    ),
                  ),
                ),

                ///
                //////////////////////////////// - fin du champ description
                const SizedBox(
                  height: 10,
                ),
                ////////////////////////////// - Affichage des produits qui constitu le menu
                ///
                Column(
                  children: [
                    for (int j = 0; j < widget.products.length; j++)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                child: const Icon(Icons.remove_circle),
                                onTap: () {
                                  setState(() {
                                    widget.products.remove(
                                      widget.products[j],
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    color: Palette.secondaryBackgroundColor,
                                    child: DropdownButtonFormField(
                                      hint:
                                          Text(widget.products[j].productName),
                                      decoration: InputDecoration(
                                        enabled: false,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onChanged: null,
                                      items:
                                          viewModel.listCategories.map((val) {
                                        for (int i = 0;
                                            i <
                                                viewModel.listCategories[j]
                                                    .products!.length;
                                            i++) {
                                          listProduitsAffiche.add(viewModel
                                              .listCategories[j]
                                              .products![i]
                                              .productName!);
                                        }
                                        return DropdownMenuItem(
                                          value: val,
                                          child: Text(
                                            val.title!,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                  ],
                ),

                ///
                const SizedBox(
                  height: 20,
                ),

                ///
                SizedBox(
                  height: 150,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 500,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 50),
                    itemCount: viewModel.listCategories.length,
                    itemBuilder: (context, index) {
                      List<String> listProduits = [];
                      String? produit;
                      final inputController = TextEditingController();
                      _controllerInput.add(inputController);
                      for (int i = 0;
                          i < viewModel.listCategories[index].products!.length;
                          i++) {
                        listProduits.add(viewModel
                            .listCategories[index].products![i].productName!);
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
                          hint: Text(viewModel.listCategories[index].title!),
                          isExpanded: true,
                          onChanged: (value) {
                            setState(
                              () {
                                produit = value!;
                                print('Valeur : ${produit}');
                                ////////////////////////////

                                for (int j = 0; j < listProduits.length; j++) {
                                  if (produit == listProduits[j]) {
                                    listProdId.add(viewModel
                                        .listCategories[index]
                                        .products![j]
                                        .sId!);
                                  }
                                }
                                print(listProdId);
                                /////////////////////////////////

                                inputController.text = value;
                              },
                            );
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
                /////////// - Ici se trouve le bouton pour l'image
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    onTap: () async {
                      /////////////////////
                      result = await FilePicker.platform
                          .pickFiles(type: FileType.custom, allowedExtensions: [
                        "png",
                        "jpg",
                        "jpeg",
                      ]);
                      if (result != null) {
                        file = result!.files.single;

                        Uint8List fileBytes =
                            result!.files.single.bytes as Uint8List;
                        //print(base64Encode(fileBytes));
                        //List<int>
                        _selectedFile = fileBytes;
                        setState(() {
                          filee = true;
                          selectedImageInBytes = result!.files.first.bytes;
                        });
                      } else {
                        setState(() {
                          filee = false;
                        });
                      }
                      ////////////////////
                    },
                    //splashColor: Colors.brown.withOpacity(0.5),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Palette.greenColors,
                        image: DecorationImage(
                            opacity: 100,
                            image: NetworkImage(
                                'http://13.39.81.126:4009${widget.imageUrl}'), //13.39.81.126
                            fit: BoxFit.cover),
                      ),
                      child: const Text(
                        "Modifier",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 80,
                ),

                /// - fin du choix de l'image

                ElevatedButton(
                  onPressed: (() {
                    for (int i = 0; i < _controllerInput.length; i++) {
                      //print(i);
                      if (_controllerInput[i].text.isNotEmpty) {
                        print(_controllerInput[i].text);
                      }
                    }
                    print("Je suis là");
                    modificationMenu(
                      context,
                      nomcontroller.text,
                      descriptioncontroller.text,
                      prixcontroller.text,
                      listProdId,
                      _selectedFile!,
                      result,
                      widget.sId,
                    );
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primaryColor,
                    minimumSize: const Size(150, 50),
                    maximumSize: const Size(200, 70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Modifier'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///// - Modification de menu
  ///
  Future<void> modificationMenu(
    BuildContext context,
    String nomMenu,
    String descriptionMenu,
    String prixMenu,
    List<String> idProduits,
    List<int> selectedFile,
    FilePickerResult? result,
    String idMenu,
  ) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var restaurantId = prefs.getString('idRestaurant').toString();
    var token = prefs.getString('token');

    //String adressUrl = prefs.getString('ipport').toString();
    //print(idMenu);

    var url = Uri.parse(
        "http://13.39.81.126:4009/api/menus/update/$idMenu"); //$adressUrl
    final request = MultipartRequest(
      'PUT',
      url,
      // ignore: avoid_returning_null_for_void
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );

    //print('la liste : ${listProdId}');
    var dd = jsonEncode(idProduits);

    var json = {
      'restaurant': restaurantId,
      'menu_title': nomMenu,
      'description': descriptionMenu,
      'price': prixMenu,
      '_creator': id,
      'products': dd,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    if (result != null) {
      request.files.add(
        http.MultipartFile.fromBytes('file', selectedFile,
            contentType: MediaType('application', 'octet-stream'),
            filename: result.files.first.name),
      );
    }
    print("RESPENSE SEND STEAM FILE REQ");
    //var responseString = await streamedResponse.stream.bytesToString();
    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);

    print("Je me situe maintenant ici");
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
            backgroundColor: Palette.greenColors,
            message: "Le menu a été modifié",
          ),
        );
        ref.refresh(getDataMenuFuture);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Menu(),
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.deleteColors,
            message: "Le menu n'a pas été modifié",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
