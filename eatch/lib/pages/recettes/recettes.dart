import 'dart:convert';

import 'package:eatch/pages/recettes/grid.dart';
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

  // ***** LES VARIABLES ****** //
  bool _showContent = false;
  bool isLoading = false;
  bool _selectFile = false;

  Uint8List? selectedImageInBytes;
  FilePickerResult? result;

  List<int> _selectedFile = [];
  bool filee = false;
  PlatformFile? file;

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

  String? recetteImage;
  final _nomRecetteImage = TextEditingController();
  final _titreRecette = TextEditingController();
  final _tempsPreparation = TextEditingController();
  final _tempsCuisson = TextEditingController();
  final _tempsTotal = TextEditingController();

  final FocusNode _tempsPreparationFocusNode = FocusNode();
  final FocusNode _tempsCuissonFocusNode = FocusNode();
  final FocusNode _tempsTotalFocusNode = FocusNode();

  @override
  void dispose() {
    _titreRecette.dispose();
    _tempsPreparation.dispose();
    _tempsCuisson.dispose();
    _tempsTotal.dispose();
    _nomRecetteImage.dispose();

    _tempsPreparationFocusNode.dispose();
    _tempsCuissonFocusNode.dispose();
    _tempsTotalFocusNode.dispose();

    _controller.dispose();
    super.dispose();
  }

  final List<TextEditingController> _matierePremieres = [];
  final List<TextEditingController> _quantite = [];
  final List<TextEditingController> _uniteDeMesure = [];

  final _formkey = GlobalKey<FormState>();

  // List<dynamic> listingredients = [];
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
      _tempsPreparation.clear();
      _tempsCuisson.clear();
      _tempsTotal.clear();
      _nomRecetteImage.clear();
    });
  }

  void _submit() {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formkey.currentState!.save();

    List<dynamic> ingredientsList = [];

    for (int i = 0; i < _matierePremieres.length; i++) {
      ingredientsList.add({
        "matiere": _matierePremieres[i].text,
        "quantite": _quantite[i].text,
        "unite": _uniteDeMesure[i].text,
      });
    }
    print(_titreRecette.text);
    print(_tempsPreparation.text);
    print(_tempsCuisson.text);
    print(_tempsTotal.text);
    print(_nomRecetteImage.text);
    print(ingredientsList);

    _clear();
    setState(() {
      _selectFile = false;
      recetteImage = null;
    });
  }

  bool search = false;
  final _controller = TextEditingController();
  List<Recette> recetteSearch = [];
  void filterRecetteResults(String query) {
    final viewRecetteModel = ref.watch(getDataRecettesFuture);
    List<Recette> dummySearchList = [];
    dummySearchList.addAll(viewRecetteModel.listRecettes);
    if (query.isNotEmpty) {
      List<Recette> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.titreRecette!.contains(query)) {
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
    final viewModel = ref.watch(getDataCategoriesFuture);
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
                                    _nomRecetteImage.text =
                                        result!.files.first.name;
                                  });
                                }
                              },
                              child: Container(
                                width: SizeConfig.screenWidth * 0.15,
                                height: SizeConfig.screenWidth * 0.15,
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
                          const SizedBox(height: 20),
                          TextFormField(
                            enabled: false,
                            controller: _nomRecetteImage,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.characters,
                            enableSuggestions: false,
                            focusNode: _tempsTotalFocusNode,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "L'image de la recette est obligatoire !";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 00.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                gapPadding: 10,
                              ),
                              hintText: "Le nom de l'image",
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _titreRecette,
                            textInputAction: TextInputAction.next,
                            autocorrect: true,
                            textCapitalization: TextCapitalization.characters,
                            enableSuggestions: false,
                            onEditingComplete: (() => FocusScope.of(context)
                                .requestFocus(_tempsPreparationFocusNode)),
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
                          TextFormField(
                            controller: _tempsPreparation,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.characters,
                            enableSuggestions: false,
                            focusNode: _tempsPreparationFocusNode,
                            onEditingComplete: (() => FocusScope.of(context)
                                .requestFocus(_tempsCuissonFocusNode)),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _tempsPreparation.text = value;
                              _tempsPreparation.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: _tempsPreparation.text.length));
                              if (_tempsPreparation.text.isEmpty &&
                                  _tempsCuisson.text.isEmpty) {
                                setState(() {
                                  _tempsTotal.text = "0";
                                });
                              } else if (_tempsCuisson.text.isEmpty &&
                                  _tempsPreparation.text.isNotEmpty) {
                                setState(() {
                                  _tempsTotal.text =
                                      int.parse(_tempsPreparation.text)
                                          .toString();
                                });
                              } else if (_tempsCuisson.text.isNotEmpty &&
                                  _tempsPreparation.text.isEmpty) {
                                setState(() {
                                  _tempsTotal.text =
                                      int.parse(_tempsCuisson.text).toString();
                                });
                              } else {
                                setState(() {
                                  _tempsTotal.text =
                                      (int.parse(_tempsCuisson.text) +
                                              int.parse(_tempsPreparation.text))
                                          .toString();
                                });
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Le temps de préparation est obligatoire !";
                              } else if (value == "0") {
                                return "Le temps de préparation doit être supérieur a zéro minute !";
                              }
                              return null;
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 00.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                gapPadding: 10,
                              ),
                              hintText: "Le temps de Préparation",
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _tempsCuisson,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.characters,
                            enableSuggestions: false,
                            focusNode: _tempsCuissonFocusNode,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _tempsCuisson.text = value;
                              _tempsCuisson.selection =
                                  TextSelection.fromPosition(
                                TextPosition(offset: _tempsCuisson.text.length),
                              );
                              if (_tempsPreparation.text.isEmpty &&
                                  _tempsCuisson.text.isEmpty) {
                                setState(() {
                                  _tempsTotal.text = "0";
                                });
                              } else if (_tempsCuisson.text.isEmpty &&
                                  _tempsPreparation.text.isNotEmpty) {
                                setState(() {
                                  _tempsTotal.text =
                                      int.parse(_tempsPreparation.text)
                                          .toString();
                                });
                              } else if (_tempsCuisson.text.isNotEmpty &&
                                  _tempsPreparation.text.isEmpty) {
                                setState(() {
                                  _tempsTotal.text =
                                      int.parse(_tempsCuisson.text).toString();
                                });
                              } else {
                                setState(() {
                                  _tempsTotal.text =
                                      (int.parse(_tempsCuisson.text) +
                                              int.parse(_tempsPreparation.text))
                                          .toString();
                                });
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Le temps de cuisson est obligatoire !";
                              }
                              return null;
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 00.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                gapPadding: 10,
                              ),
                              hintText: "Le temps de Cuisson",
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            enabled: false,
                            controller: _tempsTotal,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.characters,
                            enableSuggestions: false,
                            focusNode: _tempsTotalFocusNode,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Le temps total est obligatoire !";
                              } else if (value == "0") {
                                return "Le temps total doit être supérieur a zéro minute !";
                              }
                              return null;
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 00.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                gapPadding: 10,
                              ),
                              hintText: "Le temps total",
                            ),
                          ),
                          const SizedBox(height: 20),
                          //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          if (ingredientbool)
                            Column(
                              children: [
                                for (int j = 0;
                                    j <
                                        viewRecetteModel
                                            .listRecettes[ingredientindex]
                                            .ingredients!
                                            .length;
                                    j++)
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
                                              _removeItem(j);
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Container(
                                                color: Palette
                                                    .secondaryBackgroundColor,
                                                child: DropdownButtonFormField(
                                                  hint: Text(
                                                    viewRecetteModel
                                                        .listRecettes[
                                                            ingredientindex]
                                                        .ingredients![j]
                                                        .matiere!,
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
                                                      _matierePremieres[j]
                                                              .text =
                                                          value.toString();
                                                    });
                                                  },
                                                  onSaved: (value) {
                                                    setState(() {
                                                      _matierePremieres[j]
                                                              .text =
                                                          value.toString();
                                                    });
                                                  },
                                                  items: viewModel
                                                      .listCategories
                                                      .map((val) {
                                                    return DropdownMenuItem(
                                                      value: val.title,
                                                      child: Text(
                                                        val.title!,
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: TextFormField(
                                                // initialValue: viewRecetteModel
                                                //     .listRecettes[
                                                //         ingredientindex]
                                                //     .ingredients![j]
                                                //     .quantite!,
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: _quantite[j],
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
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              color: Palette
                                                  .secondaryBackgroundColor,
                                              child: DropdownButtonFormField(
                                                hint: Text(viewRecetteModel
                                                    .listRecettes[
                                                        ingredientindex]
                                                    .ingredients![j]
                                                    .unite!),
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
                                                    _uniteDeMesure[j].text =
                                                        value.toString();
                                                  });
                                                },
                                                onSaved: (value) {
                                                  setState(() {
                                                    _uniteDeMesure[j].text =
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
                                                items: viewModel.listCategories
                                                    .map((val) {
                                                  return DropdownMenuItem(
                                                    value: val.title,
                                                    child: Text(
                                                      val.title!,
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
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
                            children: [
                              SizedBox(
                                width: 200,
                                child: DefaultButton(
                                  color: Palette.secondaryBackgroundColor,
                                  foreground: Colors.transparent,
                                  text: 'AJOUTER INGRÉDIENT',
                                  textcolor: Palette.textsecondaryColor,
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
                                  color: Palette.deleteColors,
                                  foreground: Colors.transparent,
                                  text: 'ANNULER',
                                  textcolor: Palette.primaryBackgroundColor,
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
                      viewRecetteModel.listRecettes.isEmpty
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
                                          viewRecetteModel.listRecettes.length,
                                      itemBuilder: (_, index) {
                                        final recette = viewRecetteModel
                                            .listRecettes[index];
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
                                                    child: Image.asset(
                                                      recette.imageUrl!,
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
                                                      recette.titreRecette!,
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
                                                      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                                      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                                      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                                      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                                      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                                      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                                      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                                      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                                      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _showContent =
                                                                !_showContent;

                                                            recetteImage =
                                                                recette
                                                                    .imageUrl;

                                                            _nomRecetteImage
                                                                    .text =
                                                                recette
                                                                    .imageName!;

                                                            _titreRecette.text =
                                                                recette
                                                                    .titreRecette!;

                                                            _tempsPreparation
                                                                    .text =
                                                                recette
                                                                    .tempsPreparation!;

                                                            _tempsCuisson.text =
                                                                recette
                                                                    .tempsCuisson!;
                                                            _tempsTotal.text =
                                                                recette
                                                                    .tempsTotal!;
                                                            ingredientindex =
                                                                index;

                                                            ingredientbool =
                                                                true;
                                                          });
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
                                                                  recette.id!,
                                                              recetteTitle: recette
                                                                  .titreRecette!);
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
                                                          child: Image.asset(
                                                            recette.imageUrl!,
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
                                                            recette
                                                                .titreRecette!,
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
                                                          Text(
                                                            "${recette.tempsTotal!} Min.",
                                                            style:
                                                                const TextStyle(
                                                              color: Palette
                                                                  .textPrimaryColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
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
