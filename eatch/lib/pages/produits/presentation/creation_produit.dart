import 'package:eatch/pages/categories/presentation/categories.dart';
import 'package:eatch/servicesAPI/get_categories.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:eatch/utils/size/size.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:convert';
import 'package:eatch/servicesAPI/get_recettes.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../servicesAPI/getProduit.dart';
import '../../../servicesAPI/multipart.dart';
import '../../../utils/default_button/default_button.dart';

class CreationProduit extends ConsumerStatefulWidget {
  const CreationProduit({
    super.key,
    required this.categorieTitle,
    required this.categorieId,
  });

  final String categorieId;
  final String categorieTitle;
  @override
  CreationProduitState createState() => CreationProduitState();
}

class CreationProduitState extends ConsumerState<CreationProduit> {
  @override
  void initState() {
    server();
    super.initState();
  }

  void server() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      url_produit = prefs.getString("url_produit")!;
    });
  }

  var url_produit = "";
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

  //**********************************/
  /* LE LOADING PENDANT LE TÉLÉCHARGEMENT DE L’IMAGE DE LA RECETTE */
  bool isLoading = false;

/* SI UNE IMAGE EST SÉLECTIONNÉE SEL DEVIENT TRUE */
  bool _selectFile = false;

/* LE FICHIER IMAGE TELECHARGER DEPUIS LE PC */
  Uint8List? selectedImageInBytes;
  List<int> _selectedFile = [];

/* LE FICHIER IMAGE TELECHARGER DEPUIS LE PC A ENVOYER SUR INTERNET */
  FilePickerResult? result;
  final _formKey = GlobalKey<FormState>();

  String _produitTitle = "";
  String _produitPrice = "";
  String _produitQuantity = "";
  String? _produitCategorie;
  String? _produitRecette;

  final FocusNode _produitPriceFocusNode = FocusNode();

  @override
  void dispose() {
    _produitPriceFocusNode.dispose();
    super.dispose();
  }

  //**********************************/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            SizeConfig().init(context);
            return horizontalView(
              height(context),
              width(context),
              context,
            );
          } else {
            return verticalView(
              height(context),
              width(context),
              context,
            );
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, context) {
    SizeConfig().init(context);
    final viewModel = ref.watch(getDataCategoriesFuture);
    return AppLayout(
      content: Scaffold(
        backgroundColor: Palette.secondaryBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerRight,
                height: 50,
                color: Palette.yellowColor,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    const Text("CREATION DE PRODUIT"),
                    Expanded(child: Container()),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(100, 50)),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const CategoriesPage()),
                            (Route<dynamic> route) => false);
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(50),
                    vertical: getProportionateScreenHeight(50)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        color: Palette.secondaryBackgroundColor,
                        child: produitcategorieForm(),
                      ),
                      const SizedBox(height: 20),
                      produittitleForm(),
                      const SizedBox(height: 20),
                      produitpriceForm(),
                      const SizedBox(height: 20),
                      produitquantityForm(),
                      const SizedBox(height: 20),
                      Container(
                        color: Palette.secondaryBackgroundColor,
                        child: produitRecetteForm(),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            color: Palette.secondaryBackgroundColor,
                            child: GestureDetector(
                              onTap: () async {
                                result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      "png",
                                      "jpg",
                                      "jpeg",
                                    ]);
                                if (result != null) {
                                  setState(() {
                                    // file = result!.files.single;

                                    Uint8List fileBytes =
                                        result!.files.single.bytes as Uint8List;

                                    _selectedFile = fileBytes;

                                    // filee = true;

                                    selectedImageInBytes =
                                        result!.files.first.bytes;
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
                                      : isLoading
                                          ? const CircularProgressIndicator()
                                          : Image.memory(
                                              selectedImageInBytes!,
                                              fit: BoxFit.fill,
                                            ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 200,
                            child: DefaultButton(
                              color: Palette.primaryColor,
                              foreground: Colors.red,
                              text: 'ENREGISTRER',
                              textcolor: Palette.primaryBackgroundColor,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  creationProduct(
                                      context,
                                      _selectedFile,
                                      result,
                                      _produitQuantity,
                                      _produitPrice,
                                      _produitTitle,
                                      _produitCategorie,
                                      _produitRecette);
                                } else {
                                  print("Bad");
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 200,
                            child: DefaultButton(
                              color: Palette.secondaryBackgroundColor,
                              foreground: Colors.red,
                              text: 'ANNULER',
                              textcolor: Palette.textsecondaryColor,
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoriesPage()),
                                    (Route<dynamic> route) => false);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    SizeConfig().init(context);
    final viewModel = ref.watch(getDataCategoriesFuture);
    return AppLayout(
      content: Scaffold(
        backgroundColor: Palette.secondaryBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerRight,
                height: 50,
                color: Palette.yellowColor,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    const Text("CREATION DE PRODUIT"),
                    Expanded(child: Container()),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(100, 50)),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const CategoriesPage()),
                            (Route<dynamic> route) => false);
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(50),
                    vertical: getProportionateScreenHeight(50)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        color: Palette.secondaryBackgroundColor,
                        child: produitcategorieForm(),
                      ),
                      const SizedBox(height: 20),
                      produittitleForm(),
                      const SizedBox(height: 20),
                      produitpriceForm(),
                      const SizedBox(height: 20),
                      produitquantityForm(),
                      const SizedBox(height: 20),
                      Container(
                        color: Palette.secondaryBackgroundColor,
                        child: produitRecetteForm(),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Palette.secondaryBackgroundColor,
                            child: GestureDetector(
                              onTap: () async {
                                result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      "png",
                                      "jpg",
                                      "jpeg",
                                    ]);
                                if (result != null) {
                                  setState(() {
                                    // file = result!.files.single;

                                    Uint8List fileBytes =
                                        result!.files.single.bytes as Uint8List;

                                    _selectedFile = fileBytes;

                                    // filee = true;

                                    selectedImageInBytes =
                                        result!.files.first.bytes;
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
                                      : isLoading
                                          ? const CircularProgressIndicator()
                                          : Image.memory(
                                              selectedImageInBytes!,
                                              fit: BoxFit.fill,
                                            ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 200,
                                child: DefaultButton(
                                  color: Palette.primaryColor,
                                  foreground: Colors.red,
                                  text: 'ENREGISTRER',
                                  textcolor: Palette.primaryBackgroundColor,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      creationProduct(
                                          context,
                                          _selectedFile,
                                          result,
                                          _produitQuantity,
                                          _produitPrice,
                                          _produitTitle,
                                          _produitCategorie,
                                          _produitRecette);
                                    } else {
                                      print("Bad");
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 200,
                                child: DefaultButton(
                                  color: Palette.secondaryBackgroundColor,
                                  foreground: Colors.red,
                                  text: 'ANNULER',
                                  textcolor: Palette.textsecondaryColor,
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CategoriesPage()),
                                        (Route<dynamic> route) => false);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField produittitleForm() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      autocorrect: true,
      textCapitalization: TextCapitalization.characters,
      enableSuggestions: false,
      onEditingComplete: (() =>
          FocusScope.of(context).requestFocus(_produitPriceFocusNode)),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "S'il vous plaît entrez le nom du produit .";
        } else if (value.length < 2) {
          return "Ce champ doit contenir au moins 2 lettres.";
        }
        return null;
      },
      decoration: InputDecoration(
        hoverColor: Palette.primaryBackgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        filled: true,
        fillColor: Palette.primaryBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        prefix: const Padding(padding: EdgeInsets.only(left: 0.0)),
        hintText: "Nom du produit*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            const CustomSurffixIcon(svgIcon: "assets/icons/cauldron.svg"),
      ),
      onSaved: (value) {
        _produitTitle = value!;
      },
    );
  }

  TextFormField produitpriceForm() {
    return TextFormField(
      focusNode: _produitPriceFocusNode,
      textInputAction: TextInputAction.next,
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
      enableSuggestions: false,
      onEditingComplete: (() => FocusScope.of(context).requestFocus()),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return "S'il vous plaît entrez le prix du produit.";
        }
        return null;
      },
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
        //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      decoration: InputDecoration(
        hoverColor: Palette.primaryBackgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        filled: true,
        fillColor: Palette.primaryBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        prefix: const Padding(padding: EdgeInsets.only(left: 0.0)),
        hintText: "Prix du produit*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/coins.svg"),
      ),
      onSaved: (value) {
        _produitPrice = value!;
      },
    );
  }

  TextFormField produitquantityForm() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
      enableSuggestions: false,
      onEditingComplete: (() => FocusScope.of(context).requestFocus()),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return "S'il vous plaît entrez la quantité du produit.";
        }
        return null;
      },
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        hoverColor: Palette.primaryBackgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        filled: true,
        fillColor: Palette.primaryBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        prefix: const Padding(padding: EdgeInsets.only(left: 0.0)),
        hintText: "Quantité du produit*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/coins.svg"),
      ),
      onSaved: (value) {
        _produitQuantity = value!;
      },
    );
  }

  DropdownButtonFormField<String> produitRecetteForm() {
    final viewModel = ref.watch(getDataRecettesFuture);
    return DropdownButtonFormField(
      decoration: InputDecoration(
        hoverColor: Palette.primaryBackgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        filled: true,
        fillColor: Palette.primaryBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      hint: const Text(
        "Recette*",
        style: TextStyle(color: Colors.black),
      ),
      isExpanded: true,
      onChanged: (value) {
        setState(() {
          _produitRecette = value;
        });
      },
      onSaved: (value) {
        setState(() {
          _produitRecette = value;
        });
      },
      validator: (String? value) {
        if (value == null) {
          return "La catégorie est obligatoire.";
        } else {
          return null;
        }
      },
      items: viewModel.listRecette.map((val) {
        return DropdownMenuItem(
          value: val.sId,
          child: Text(
            val.title!,
          ),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> produitcategorieForm() {
    final viewModel = ref.watch(getDataCategoriesFuture);
    return DropdownButtonFormField(
      decoration: InputDecoration(
        hoverColor: Palette.primaryBackgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        filled: true,
        fillColor: Palette.primaryBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      value: widget.categorieId,
      hint: Text(
        widget.categorieTitle,
        style: const TextStyle(color: Colors.black),
      ),
      isExpanded: true,
      onChanged: (value) {
        setState(() {
          _produitCategorie = value;
        });
      },
      onSaved: (value) {
        setState(() {
          _produitCategorie = value;
        });
      },
      validator: (String? value) {
        if (value == null) {
          return "La recette est obligatoire.";
        } else {
          return null;
        }
      },
      items: viewModel.listCategories.map((val) {
        return DropdownMenuItem(
          value: val.sId,
          child: Text(
            val.title!,
          ),
        );
      }).toList(),
    );
  }

  ////////////////////
  ///////////////////////
  Future<void> creationProduct(
    context,
    selectedFile,
    result,
    quantity,
    price,
    productName,
    category,
    recette,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var restaurantid = prefs.getString('idRestaurant');
    print(id);
    print(token);
    print("Restaurant id $restaurantid");

    var url = Uri.parse("http://13.39.81.126:4003/api/products/create");
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      "quantity": quantity,
      "price": price,
      "productName": productName,
      "category": category,
      "recette": recette,
      "restaurant": restaurantid!.trim(),
      "_creator": id,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
        contentType: MediaType('application', 'octet-stream'),
        filename: result.files.first.name));

    print("RESPENSE SEND STEAM FILE REQ");
    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const CategoriesPage()),
            (Route<dynamic> route) => false);

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Produit Crée avec succès.",
          ),
        );

        setState(() {
          ref.refresh(getDataCategoriesFuture);
          ref.refresh(GetDataProduitFuture as Refreshable);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erreur de serveur"),
        ));
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  ///
}

class CustomSurffixIcon extends StatelessWidget {
  const CustomSurffixIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(5),
        getProportionateScreenWidth(5),
        getProportionateScreenWidth(5),
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: getProportionateScreenWidth(4),
        color: Palette.textsecondaryColor,
      ),
    );
  }
}
