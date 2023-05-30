import 'dart:convert';

import 'package:eatch/pages/recettes/eddit_recette.dart';
import 'package:eatch/pages/recettes/grid.dart';
import 'package:eatch/servicesAPI/getMatiere.dart';
import 'package:eatch/servicesAPI/get_categories.dart';
import 'package:eatch/servicesAPI/get_recettes.dart';
import 'package:eatch/servicesAPI/multipart.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/default_button/default_button.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:eatch/utils/size/size.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RecettesPage extends ConsumerStatefulWidget {
  const RecettesPage({super.key});

  @override
  ConsumerState<RecettesPage> createState() => _RecettesPageState();
}

class _RecettesPageState extends ConsumerState<RecettesPage> {
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

  /* LA VARIABLE QUI AFFICHE LE FORMULAIRE DE CRÉATION DE RECETTE */
  bool _showContent = false;

  /* LE LOADING PENDANT LE TÉLÉCHARGEMENT DE L’IMAGE DE LA RECETTE */
  bool isLoading = false;

  /* LE LOADING PENDANT LE TÉLÉCHARGEMENT DE L’IMAGE DE LA RECETTE */
  bool _selectFile = false;

  Uint8List? selectedImageInBytes;
  FilePickerResult? result;

  List<int> _selectedFile = [];
  bool filee = false;
  PlatformFile? file;

  List<Ingredient> ingredientsList = [];
  List<String> listOfUnities = [
    "g",
    "Kg",
    "l",
    "Cl",
    "Pincée",
    "Gousse",
    "Cuillerée à café",
    "Sachet",
    "x",
  ];
  List<String> listOfMatiere = [
    "Orange",
    "Mangue",
    "Tomate",
  ];

  String? recetteImage;
  final _descriptionRecette = TextEditingController();
  final _titreRecette = TextEditingController();

  @override
  void dispose() {
    _titreRecette.dispose();
    _descriptionRecette.dispose();

    _controller.dispose();
    super.dispose();
  }

  final List<TextEditingController> _matierePremieres = [];
  final List<TextEditingController> _quantite = [];
  final List<TextEditingController> _uniteDeMesure = [];

  final _formkey = GlobalKey<FormState>();

  int ingredientindex = 0;
  bool ingredientbool = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _addFiel();
    });
    super.initState();
  }

  _addFiel() {
    setState(() {
      _matierePremieres.add(TextEditingController());
      _quantite.add(TextEditingController());
      _uniteDeMesure.add(TextEditingController());
    });
  }

  _removeItem(i) {
    setState(() {
      _matierePremieres.removeAt(i);
      _quantite.removeAt(i);
      _uniteDeMesure.removeAt(i);
    });
  }

  _clear() {
    setState(() {
      _matierePremieres.clear();
      _quantite.clear();
      _uniteDeMesure.clear();

      _titreRecette.clear();
      _descriptionRecette.clear();
    });
  }

  void _submit() {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    } else if (_matierePremieres.length == 0) {
      showTopSnackBar(
        Overlay.of(context)!,
        const CustomSnackBar.info(
          backgroundColor: Colors.red,
          message: "Les ingrédients sont obligatoires .",
        ),
      );
    } else {
      _formkey.currentState!.save();

      for (int i = 0; i < _matierePremieres.length; i++) {
        ingredientsList.add(Ingredient(
          material: _matierePremieres[i].text,
          grammage: _quantite[i].text,
        ));
      }
      creationRecette(
        context,
        _titreRecette.text,
        _descriptionRecette.text,
        ingredientsList,
        _selectedFile,
        result,
      );
      print(_titreRecette.text);
      print(_descriptionRecette.text);
      print(ingredientsList);

      _clear();
      setState(() {
        _selectFile = false;
        recetteImage = null;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _addFiel();
        });
      });
    }
  }

  bool search = false;
  final _controller = TextEditingController();
  List<Recette> recetteSearch = [];
  void filterRecetteResults(String query) {
    final viewRecetteModel = ref.watch(getDataRecettesFuture);
    List<Recette> dummySearchList = [];
    dummySearchList.addAll(viewRecetteModel.listRecette);
    if (query.isNotEmpty) {
      List<Recette> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.title!.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        search = true;
        recetteSearch.clear();
        recetteSearch.addAll(dummyListData);
        _controller.clear();
      });

      return;
    } else {
      setState(() {
        search = false;
        _controller.clear();
      });
    }
  }

  // ************************** //

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
    final viewModel = ref.watch(getDataMatiereFuture);
    final viewRecetteModel = ref.watch(getDataRecettesFuture);
    return AppLayout(
      content: SingleChildScrollView(
        child: Column(
          children: [
            if (!_showContent)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showContent = !_showContent;
                          ingredientbool = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Palette.primaryBackgroundColor,
                      ),
                      label: const Text(
                        " AJOUTER UNE RECETTE",
                        style: TextStyle(
                          fontSize: 12,
                          color: Palette.primaryBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            _showContent
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(50.0),
                    ),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /* TEXTFORMFIELD DU TITRE DE LA RECETTE*/
                          TextFormField(
                            controller: _titreRecette,
                            textInputAction: TextInputAction.next,
                            autocorrect: true,
                            textCapitalization: TextCapitalization.characters,
                            enableSuggestions: false,
                            onEditingComplete: (() =>
                                FocusScope.of(context).requestFocus()),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Le titre de la recette est obligatoire !";
                              } else if (value.length < 2) {
                                return "Entrez au moins 2 caractères !";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 00.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                gapPadding: 10,
                              ),
                              hintText: "Le titre de la recette",
                            ),
                          ),
                          const SizedBox(height: 20),

                          /* TEXTFORMFIELD DE LA DESCRIPTION DE LA RECETTE*/
                          TextFormField(
                            controller: _descriptionRecette,
                            textInputAction: TextInputAction.next,
                            autocorrect: true,
                            textCapitalization: TextCapitalization.characters,
                            enableSuggestions: false,
                            onEditingComplete: (() =>
                                FocusScope.of(context).requestFocus()),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Le titre de la recette est obligatoire !";
                              } else if (value.length < 50) {
                                return "Entrez au moins 50 caractères !";
                              }
                              return null;
                            },
                            minLines: 3,
                            maxLines: 6,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                gapPadding: 10,
                              ),
                              hintText: "La description de la recette",
                            ),
                          ),
                          const SizedBox(height: 20),

                          /* ENSEMBLE DES INGRÉDIENTS */
                          Column(
                            children: [
                              for (int i = 0; i < _matierePremieres.length; i++)
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          child:
                                              const Icon(Icons.remove_circle),
                                          onTap: () {
                                            _removeItem(i);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        /* MATIÈRE PREMIÈRE */
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Container(
                                              color: Palette
                                                  .secondaryBackgroundColor,
                                              child: DropdownButtonFormField(
                                                hint: const Text(
                                                  'Matière Première*',
                                                ),
                                                validator: (value) {
                                                  if (value == null) {
                                                    return "Le nom de la matière première est obligatoire.";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _matierePremieres[i].text =
                                                        value.toString();
                                                  });
                                                },
                                                onSaved: (value) {
                                                  setState(() {
                                                    _matierePremieres[i].text =
                                                        value.toString();
                                                  });
                                                },
                                                items: viewModel.listMatiere
                                                    .map((val) {
                                                  return DropdownMenuItem(
                                                    value: val.sId,
                                                    child: Text(
                                                      val.mpName!,
                                                    ),
                                                  );
                                                }).toList(),
                                                // items: listOfMatiere
                                                //     .map((String val) {
                                                //   return DropdownMenuItem(
                                                //     value: val,
                                                //     child: Text(
                                                //       val,
                                                //     ),
                                                //   );
                                                // }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),

                                        /* QUANTITÉ */
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _quantite[i],
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "La quantité est obligatoire !";
                                                } else if (value == "0") {
                                                  return "La quantité doit être supérieur a zéro minute !";
                                                }
                                                return null;
                                              },
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
                                              ],
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                hintText: "Quantité*",
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),

                                        /* UNITE DE MESURE */
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            color: Palette
                                                .secondaryBackgroundColor,
                                            child: DropdownButtonFormField(
                                              hint: const Text(
                                                'Unité*',
                                              ),
                                              validator: (value) {
                                                if (value == null) {
                                                  return "L ' Unité de mésure est obligatoire.";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  _uniteDeMesure[i].text =
                                                      value.toString();
                                                });
                                              },
                                              onSaved: (value) {
                                                setState(() {
                                                  _uniteDeMesure[i].text =
                                                      value.toString();
                                                });
                                              },
                                              items: listOfUnities
                                                  .map((String val) {
                                                return DropdownMenuItem(
                                                  value: val,
                                                  child: Text(
                                                    val,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                color: Palette.secondaryBackgroundColor,
                                child: GestureDetector(
                                  onTap: () async {
                                    recetteImage = null;
                                    result = await FilePicker.platform
                                        .pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                          "png",
                                          "jpg",
                                          "jpeg",
                                        ]);
                                    if (result != null) {
                                      setState(() {
                                        file = result!.files.single;

                                        Uint8List fileBytes = result!
                                            .files.single.bytes as Uint8List;

                                        _selectedFile = fileBytes;

                                        filee = true;

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
                                        width: 1,
                                        color: const Color(0xFFDCE0E0),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: recetteImage != null
                                          ? Image.asset(
                                              recetteImage!,
                                              fit: BoxFit.fill,
                                            )
                                          : _selectFile == false
                                              ? const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: Color(0xFFDCE0E0),
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
                                  color: Palette.yellowColor,
                                  foreground: Colors.transparent,
                                  text: 'AJOUTER INGRÉDIENT',
                                  textcolor: Palette.primaryBackgroundColor,
                                  onPressed: () {
                                    _addFiel();
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 200,
                                child: DefaultButton(
                                  color: Palette.primaryColor,
                                  foreground: Colors.transparent,
                                  text: 'ENREGISTRER',
                                  textcolor: Palette.primaryBackgroundColor,
                                  onPressed: () {
                                    _submit();
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 200,
                                child: DefaultButton(
                                  color: Palette.secondaryBackgroundColor,
                                  foreground: Colors.transparent,
                                  text: 'ANNULER',
                                  textcolor: Palette.textsecondaryColor,
                                  onPressed: () {
                                    _clear();
                                    setState(() {
                                      _selectFile = false;
                                      recetteImage = null;
                                      _showContent = !_showContent;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: SizedBox(
                          width: 300,
                          child: TextField(
                            style: const TextStyle(
                              color: Palette.textPrimaryColor,
                              fontSize: 14,
                            ),
                            onChanged: (value) {
                              filterRecetteResults(value);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Palette.fourthColor,
                              contentPadding: const EdgeInsets.all(0),
                              prefixIcon: const Icon(Icons.search,
                                  color: Palette.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                              hintText: "Rechercher une recette ...",
                            ),
                          ),
                        ),
                      ),
                      viewRecetteModel.listRecette.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(50.0),
                              ),
                              child: Center(
                                child: Text(
                                  'No products found',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(50.0),
                              ),
                              child: search == false
                                  ? ProductsLayoutGrid(
                                      itemCount:
                                          viewRecetteModel.listRecette.length,
                                      itemBuilder: (_, index) {
                                        final recette =
                                            viewRecetteModel.listRecette[index];
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          elevation: 7,
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15),
                                                    ),
                                                    child: Image.network(
                                                      "http://192.168.10.110:4010${recette.image}",
                                                      height: 180,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 180,
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 10,
                                                      horizontal: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                          Colors.black
                                                              .withOpacity(0),
                                                          Colors.black
                                                              .withOpacity(0.8),
                                                        ],
                                                            stops: const [
                                                          0.6,
                                                          1
                                                        ])),
                                                    child: Text(
                                                      recette.title!,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Palette
                                                            .primaryBackgroundColor,
                                                      ),
                                                      overflow:
                                                          TextOverflow.fade,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Palette
                                                            .primaryColor,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: const Icon(
                                                          Icons
                                                              .remove_red_eye_outlined,
                                                          size: 15.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Colors.yellow[600],
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator
                                                              .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          EdditRecette(
                                                                            title:
                                                                                viewRecetteModel.listRecette[index].title!,
                                                                            image:
                                                                                viewRecetteModel.listRecette[index].image!,
                                                                            sId:
                                                                                viewRecetteModel.listRecette[index].sId!,
                                                                            ingredients:
                                                                                viewRecetteModel.listRecette[index].engredients!,
                                                                            description:
                                                                                viewRecetteModel.listRecette[index].description!,
                                                                          )));
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //       builder:
                                                          //           (context) {
                                                          //     return EdditRecette(
                                                          //       title: viewRecetteModel
                                                          //           .listRecette[
                                                          //               index]
                                                          //           .title!,
                                                          //       image: viewRecetteModel
                                                          //           .listRecette[
                                                          //               index]
                                                          //           .image!,
                                                          //       sId: viewRecetteModel
                                                          //           .listRecette[
                                                          //               index]
                                                          //           .sId!,
                                                          //       ingredients: viewRecetteModel
                                                          //           .listRecette[
                                                          //               index]
                                                          //           .ingredients!,
                                                          //     );
                                                          //   }),
                                                          // );
                                                        },
                                                        child: const Icon(
                                                          Icons.mode_rounded,
                                                          size: 15.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.red,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          dialogDelete(
                                                              recetteId:
                                                                  recette.sId!,
                                                              recetteTitle:
                                                                  recette
                                                                      .title!);
                                                        },
                                                        child: const Icon(
                                                          Icons.delete,
                                                          size: 15.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : recetteSearch.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'Aucune recette trouvée',
                                          ),
                                        )
                                      : ProductsLayoutGrid(
                                          itemCount: recetteSearch.length,
                                          itemBuilder: (_, index) {
                                            final recette =
                                                recetteSearch[index];
                                            return InkWell(
                                              hoverColor: Colors.transparent,
                                              onTap: () {},
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                elevation: 7,
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15),
                                                            topRight:
                                                                Radius.circular(
                                                                    15),
                                                          ),
                                                          child: Image.network(
                                                            recette.image!,
                                                            height: 180,
                                                            width:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 180,
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 10,
                                                            horizontal: 10,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                      begin: Alignment
                                                                          .topCenter,
                                                                      end: Alignment
                                                                          .bottomCenter,
                                                                      colors: [
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0),
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.8),
                                                              ],
                                                                      stops: const [
                                                                0.6,
                                                                1
                                                              ])),
                                                          child: Text(
                                                            recette.title!,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              color: Palette
                                                                  .primaryBackgroundColor,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .access_time_filled_sharp,
                                                              color: Palette
                                                                  .primaryColor),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            child: const Icon(
                                                              Icons.add,
                                                              size: 15.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                            ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    final viewModel = ref.watch(getDataCategoriesFuture);
    final viewRecetteModel = ref.watch(getDataRecettesFuture);
    return AppLayout(
      content: Container(),
    );
  }

  Future<void> creationRecette(
    contextt,
    String title,
    String description,
    List<Ingredient> ingredients,
    selectedFile,
    result,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var restaurantid = prefs.getString('idRestaurant');
    String adressUrl = prefs.getString('ipport').toString();
    var url = Uri.parse(
        "http://192.168.11.110:4010/api/recettes/create"); //13.39.81.126
    print(url);
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var ingredient = jsonEncode(ingredientsList).toString();
    var json = {
      'title': title,
      'description': description,
      'engredients': ingredient,
      '_creator': id,
      'restaurant': restaurantid!.trim(),
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
    //var responseString = await streamedResponse.stream.bytesToString();
    var response = await request.send();
    print("Upload Response$response");
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
          Overlay.of(contextt)!,
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Recette Crée",
          ),
        );
        ref.refresh(getDataRecettesFuture);
      } else {
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "Erreur de création",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future dialogDelete({
    required String recetteTitle,
    required String recetteId,
  }) {
    return showDialog(
        context: context,
        builder: (con) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(
                child: Text(
                  "Confirmez la suppression",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: [
                ElevatedButton.icon(
                    icon: const Icon(
                      Icons.close,
                      size: 14,
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
                    deleteRecette(context, recetteId);
                    Navigator.pop(con);
                  },
                  label: const Text("SupprimeDDr."),
                )
              ],
              content: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  height: 150,
                  child: Text(
                    "Voulez vous supprimer le recette $recetteTitle ?",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  )));
        });
  }

  Future<http.Response> deleteRecette(BuildContext context, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userdelete = prefs.getString('IdUser').toString();
      var token = prefs.getString('token');
      String urlDelete = "http://192.168.11.110:4010/api/recettes/delete/$id";
      var json = {
        '_creator': userdelete,
      };
      var body = jsonEncode(json);

      final http.Response response = await http.delete(
        Uri.parse(urlDelete),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
          'body': body,
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        ref.refresh(getDataRecettesFuture);

        return response;
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}

class Ingredient {
  String? material;
  String? grammage;

  Ingredient({this.material, this.grammage});

  Ingredient.fromJson(Map<String, dynamic> json) {
    material = json['material'];
    grammage = json['grammage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['material'] = this.material;
    data['grammage'] = this.grammage;
    return data;
  }
}