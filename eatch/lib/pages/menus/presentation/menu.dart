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
import '../../../servicesAPI/multipart.dart';
import '../infrastructure/menus_repository.dart';
import 'package:http/http.dart' as http;
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
                                borderRadius: BorderRadius.circular(10),
                              ),
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
              child: const Row(
                children: [
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
                  //List<String> listProdId = [];
                  String? produit;
                  final inputController = TextEditingController();
                  _controllerInput.add(inputController);
                  for (int i = 0; i < categoriee[index].products!.length; i++) {
                    listProduits
                        .add(categoriee[index].products![i].productName!);
                  }
                  //print(listProduits);

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
                          ////////////////////////////
                          print("Produits:${produit}");
                          for (int j = 0; j < listProduits.length; j++) {
                            if (produit == listProduits[j]) {
                              print("Je suis là");
                              print(listProduits[j]);
                              listProdId
                                  .add(categoriee[index].products![j].sId!);
                            }
                          }
                          /////////////////////////////////
                          ///
                          print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ - début");
                          print(listProdId);
                          print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ - fin");

                          ///
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
            /////////// - Ici se trouve le bouton pour l'image
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

                      Uint8List fileBytes =
                          result!.files.single.bytes as Uint8List;

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
              height: 30,
            ),

            /// - fin du choix de l'image
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
                        //print(i);
                        if (_controllerInput[i].text.isNotEmpty) {
                          print(_controllerInput[i].text);
                        }
                      }
                      creationMenu(context, nomcontroller.text, _selectedFile!,
                          result, listProdId);

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

  /////////Création de Menu
  ///
  Future<void> creationMenu(
    BuildContext context,
    String nomMenu,
    List<int> selectedFile,
    FilePickerResult? result,
    List<String> idProduits,
  ) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var restaurantId = prefs.getString('idRestaurant').toString();
    var token = prefs.getString('token');

    //String adressUrl = prefs.getString('ipport').toString();

    var url = Uri.parse(
        "http://192.168.11.110:4009/api/menus/create"); // 192.168.11.110:4009
    final request = MultipartRequest(
      'POST',
      url,
      // ignore: avoid_returning_null_for_void
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );

    var dd = jsonEncode(idProduits);

    var json = {
      'menu_title': nomMenu,
      'restaurant': restaurantId,
      '_creator': id,
      'products': dd,
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
            message: "Le menu a été crée",
          ),
        );
        //ref.refresh(getDataMenuFuture);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "Le menu n'a pas été crée",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      throw e;
    }
  }
}
