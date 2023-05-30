import 'dart:convert';

import 'package:eatch/pages/recettes/recettes.dart';
import 'package:eatch/servicesAPI/getMatiere.dart';
import 'package:eatch/servicesAPI/get_categories.dart';
import 'package:eatch/servicesAPI/get_recettes.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/default_button/default_button.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:eatch/utils/size/size.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EdditRecette extends ConsumerStatefulWidget {
  const EdditRecette({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.sId,
    required this.ingredients,
  });

  final String title;
  final String description;
  final String image;
  final String sId;
  final List<Engredients> ingredients;

  @override
  ConsumerState<EdditRecette> createState() => _EdditRecetteState();
}

class _EdditRecetteState extends ConsumerState<EdditRecette> {
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
  List<Engredients>? ingredientsOldList;
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
  late final _descriptionRecette =
      TextEditingController(text: widget.description);
  late final _titreRecette = TextEditingController(text: widget.title);

  // late final _matierePremieresold = TextEditingController();

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

  final List _matierePremieresold = [];
  // final List<TextEditingController> _quantiteold = [];
  List<String> _quantiteold = [];
  final List<TextEditingController> _uniteDeMesureold = [];

  final _formkey = GlobalKey<FormState>();

  int ingredientindex = 0;
  bool ingredientbool = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _addFiel();
    });
    setState(() {
      ingredientsOldList = widget.ingredients;
    });

    print(ingredientsOldList!.length);
    print(ingredientsOldList);
    super.initState();
  }

  /*
  faire une fonction
  
   */

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

  _removeItemold(i) {
    setState(() {
      _matierePremieresold.removeAt(i);
      _quantiteold.removeAt(i);
      // _uniteDeMesureold.removeAt(i);
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
        ingredientsList.add(
          Ingredient(
            material: _matierePremieres[i].text,
            grammage: _quantite[i].text,
          ),
        );
      }
      print(_titreRecette.text);
      print(_descriptionRecette.text);
      print(ingredientsList);

      _clear();
      setState(() {
        _selectFile = false;
        recetteImage = null;
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
            const SizedBox(height: 20),
            Padding(
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

                    /* ENSEMBLE DES INGRÉDIENTS OLD*/
                    /*
                    Column(
                      children: List.generate(
                        widget.ingredients.length,
                        (index) {
                          late final _matierePremieresold =
                              TextEditingController(
                                  text: widget
                                      .ingredients[index].material!.mpName);
                          late final _quantiteold = TextEditingController(
                              text: widget.ingredients[index].grammage
                                  .toString());
                          // late final _uniteDeMesureold = TextEditingController(
                          //     text: widget.ingredients[index].unit);
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: const Icon(Icons.remove_circle),
                                    onTap: () {},
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
                                        color: Palette.secondaryBackgroundColor,
                                        child: TextFormField(
                                          enabled: false,
                                          keyboardType: TextInputType.number,
                                          controller: _matierePremieresold,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            hintText: "MAtière*",
                                          ),
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
                                        keyboardType: TextInputType.number,
                                        controller: _quantiteold,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "La quantité est obligatoire !";
                                          } else if (value == "0") {
                                            return "La quantité doit être supérieur a zéro minute !";
                                          }
                                          return null;
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          hintText: "Quantité*",
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),

                                  /* UNITE DE MESURE */
                                  /*Expanded(
                                    flex: 2,
                                    child: Container(
                                      color: Palette.secondaryBackgroundColor,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: _uniteDeMesureold,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "La quantité est obligatoire !";
                                          } else if (value == "0") {
                                            return "La quantité doit être supérieur a zéro minute !";
                                          }
                                          return null;
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          hintText: "Quantité*",
                                        ),
                                      ),
                                    ),
                                  ),*/
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    ),
                    */
                    /*###########################################################*/
                    /* ENSEMBLE DES INGRÉDIENTS */
                    Column(
                      children: List.generate(
                        ingredientsOldList!.length,
                        (index) {
                          String xxxxxxxxxxx =
                              ingredientsOldList![index].material!.mpName!;
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: const Icon(Icons.remove_circle),
                                    onTap: () {
                                      // _removeItemold(index);
                                      print(_matierePremieresold[index]);
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
                                        color: Palette.secondaryBackgroundColor,
                                        child: DropdownButtonFormField(
                                          hint: Text(
                                            widget.ingredients[index].material!
                                                .mpName!,
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
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          value: xxxxxxxxxxx,
                                          onChanged: (value) {
                                            setState(() {
                                              xxxxxxxxxxx = value.toString();
                                            });
                                          },
                                          onSaved: (value) {
                                            setState(() {
                                              _matierePremieresold[index].text =
                                                  xxxxxxxxxxx;
                                            });
                                          },
                                          items:
                                              viewModel.listMatiere.map((val) {
                                            return DropdownMenuItem(
                                              value: val.sId,
                                              child: Text(
                                                val.mpName!,
                                              ),
                                            );
                                          }).toList(),
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
                                        keyboardType: TextInputType.number,
                                        initialValue: widget
                                            .ingredients[index].grammage!
                                            .toString(),
                                        // controller: _quantiteold[index],
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "La quantité est obligatoire !";
                                          } else if (value == "0") {
                                            return "La quantité doit être supérieur a zéro minute !";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _quantiteold[index] = value!;
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          hintText: "Quantité*",
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),

                                  /* UNITE DE MESURE */
                                  /*
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      color: Palette.secondaryBackgroundColor,
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
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _uniteDeMesureold[index].text =
                                                value.toString();
                                          });
                                        },
                                        onSaved: (value) {
                                          setState(() {
                                            _uniteDeMesureold[index].text =
                                                value.toString();
                                          });
                                        },
                                        items: listOfUnities.map((String val) {
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
                                  */
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    ),

                    /*###########################################################*/

                    /* ENSEMBLE DES INGRÉDIENTS */
                    Column(
                      children: [
                        for (int i = 0; i < _matierePremieres.length; i++)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: const Icon(Icons.remove_circle),
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
                                        color: Palette.secondaryBackgroundColor,
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
                                                  BorderRadius.circular(10.0),
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
                                          items:
                                              viewModel.listMatiere.map((val) {
                                            return DropdownMenuItem(
                                              value: val.sId,
                                              child: Text(
                                                val.mpName!,
                                              ),
                                            );
                                          }).toList(),
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
                                        keyboardType: TextInputType.number,
                                        controller: _quantite[i],
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "La quantité est obligatoire !";
                                          } else if (value == "0") {
                                            return "La quantité doit être supérieur a zéro minute !";
                                          }
                                          return null;
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                      color: Palette.secondaryBackgroundColor,
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
                                                BorderRadius.circular(10.0),
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
                                        items: listOfUnities.map((String val) {
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

                    /* L’IMAGE ET LES BOUTONS */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /* LE CADRE DE L'IMAGE */
                        Container(
                          color: Palette.secondaryBackgroundColor,
                          child: GestureDetector(
                            onTap: () async {
                              recetteImage = null;
                              result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: [
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
                                child: _selectFile == false
                                    ? Image.network(
                                        widget.image,
                                        fit: BoxFit.fill,
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

                        /* BOUTON AJOUTER */
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

                        /* BOUTON ENREGISTRER */
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

                        /* BOUTON ANNULER*/
                        SizedBox(
                          width: 200,
                          child: DefaultButton(
                            color: Palette.secondaryBackgroundColor,
                            foreground: Colors.transparent,
                            text: 'ANNULER',
                            textcolor: Palette.textsecondaryColor,
                            onPressed: () {
                              // _clear();
                              // setState(() {
                              //   _selectFile = false;
                              //   recetteImage = null;
                              // });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const RecettesPage()));
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
                    // deleteUser(context, viewId);
                    Navigator.pop(con);
                  },
                  label: const Text("Supprimer."),
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

  Future<http.Response> deleteUser(BuildContext context, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userdelete = prefs.getString('IdUser').toString();
      var token = prefs.getString('token');
      String urlDelete = "http://13.39.81.126:4001/api/users/delete/$id";
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
        // ref.refresh(getDataUserFuture);

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
