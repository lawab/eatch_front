// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eatch/servicesAPI/get_categories.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/default_button/default_button.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:eatch/utils/size/size.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  var tempsPreparation = "0";
  var tempsCuisson = "0";

  FilePickerResult? result;
  PlatformFile? file;

  List<String> listOfUnities = [
    "g",
    "Kg",
    "l",
    "Cl",
    "Pincée",
    "Gousse",
    "Cuillerée à café",
    "Sachets",
    "x",
  ];

  final _titreRecette = TextEditingController();
  final _tempsPreparation = TextEditingController();
  final _tempsCuisson = TextEditingController();
  final _tempsTotal = TextEditingController(text: "0");

  final FocusNode _tempsPreparationFocusNode = FocusNode();
  final FocusNode _tempsCuissonFocusNode = FocusNode();
  final FocusNode _tempsTotalFocusNode = FocusNode();

  @override
  void dispose() {
    _titreRecette.dispose();
    _tempsPreparation.dispose();
    _tempsCuisson.dispose();
    _tempsTotal.dispose();

    _tempsPreparationFocusNode.dispose();
    _tempsCuissonFocusNode.dispose();
    _tempsTotalFocusNode.dispose();
    super.dispose();
  }

  final List<TextEditingController> _matierePremieres = [];
  final List<TextEditingController> _quantite = [];
  final List<TextEditingController> _uniteDeMesure = [];

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: Je dois revenir comprendre.
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
    });
  }

  void _submit() {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formkey.currentState!.save();

    FormData formData = FormData.fromMap({});

    for (int i = 0; i < _matierePremieres.length; i++) {
      formData.fields
          .add(MapEntry("matierePremieres[]", _matierePremieres[i].text));
      formData.fields.add(MapEntry("quantite[]", _quantite[i].text));
      formData.fields.add(MapEntry("uniteDeMesure[]", _uniteDeMesure[i].text));
    }
    // networkRequest(
    //     context: context,
    //     requestType: "post",
    //     url: "${Urls.billAdd}${widget.taskID}?jhhihu",
    //     data: formData,
    //     action: (r) {
    //       Navigator.pop(context, true);
    //     });
    _clear();
    setState(() {
      _showContent = !_showContent;
    });
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
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Container(
                                      color: Palette.secondaryBackgroundColor,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: SizeConfig.screenWidth * 0.22,
                                          height:
                                              SizeConfig.screenWidth * 0.145,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: const Color(0xFFDCE0E0),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: file == null
                                                ? const Icon(
                                                    Icons.camera_alt_outlined,
                                                    color: Color(0xFFDCE0E0),
                                                    size: 40,
                                                  )
                                                : Image.file(
                                                    result!.files.single
                                                        as File,
                                                    fit: BoxFit.fill,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      enabled: false,
                                      controller: _tempsTotal,
                                      textInputAction: TextInputAction.next,
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.characters,
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 00.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          gapPadding: 10,
                                        ),
                                        hintText: "Le temps total",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 50),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _titreRecette,
                                      textInputAction: TextInputAction.next,
                                      autocorrect: true,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      enableSuggestions: false,
                                      onEditingComplete: (() =>
                                          FocusScope.of(context).requestFocus(
                                              _tempsPreparationFocusNode)),
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 00.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          gapPadding: 10,
                                        ),
                                        // label: const Text("Titre Recette"),
                                        hintText: "Le titre de la recette",
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _tempsPreparation,
                                      textInputAction: TextInputAction.next,
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      enableSuggestions: false,
                                      focusNode: _tempsPreparationFocusNode,
                                      onEditingComplete: (() =>
                                          FocusScope.of(context).requestFocus(
                                              _tempsCuissonFocusNode)),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        tempsPreparation = value;
                                        _tempsTotal.text = (value.isEmpty &&
                                                tempsCuisson.isEmpty)
                                            ? (0 + 0).toString()
                                            : value.isEmpty
                                                ? (int.parse(tempsCuisson) + 0)
                                                    .toString()
                                                : (int.parse(tempsCuisson) +
                                                        int.parse(
                                                            tempsPreparation))
                                                    .toString();
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 00.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          gapPadding: 10,
                                        ),
                                        hintText: "Le temps de Préparation",
                                        // label:
                                        //     const Text("Temps de Préparation"),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _tempsCuisson,
                                      textInputAction: TextInputAction.next,
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      enableSuggestions: false,
                                      focusNode: _tempsCuissonFocusNode,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        tempsCuisson = value;
                                        _tempsTotal.text = (value.isEmpty &&
                                                tempsPreparation.isEmpty)
                                            ? (0 + 0).toString()
                                            : value.isEmpty
                                                ? (0 +
                                                        int.parse(
                                                            tempsPreparation))
                                                    .toString()
                                                : (int.parse(tempsCuisson) +
                                                        int.parse(
                                                            tempsPreparation))
                                                    .toString();
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Le temps de cuisson est obligatoire !";
                                        } else if (value == "0") {
                                          return "Le temps de cuisson doit être supérieur a zéro minute !";
                                        }
                                        return null;
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 00.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                      textCapitalization:
                                          TextCapitalization.characters,
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 00.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          gapPadding: 10,
                                        ),
                                        // label: const Text("Temps Total"),
                                        hintText: "Le temps total",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  _addFiel();
                                },
                                child: const Icon(Icons.add_circle),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
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
                                )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                                  foreground: Colors.red,
                                  text: 'ANNULER',
                                  textcolor: Palette.textsecondaryColor,
                                  onPressed: () {
                                    _clear();
                                    setState(() {
                                      _showContent = !_showContent;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text("RIEN"),
                  ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    final viewModel = ref.watch(getDataCategoriesFuture);
    return AppLayout(
      content: Container(),
    );
  }
}
