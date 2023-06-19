// ignore_for_file: prefer_is_empty

import 'dart:convert';

import 'package:eatch/pages/recettes/eddit_recette.dart';
import 'package:eatch/pages/recettes/grid.dart';
import 'package:eatch/servicesAPI/getLabo.dart';
import 'package:eatch/servicesAPI/getMatiere.dart';
import 'package:eatch/servicesAPI/get_categories.dart';
import 'package:eatch/servicesAPI/get_recettes.dart' as recette;
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

enum SingingCharacter { restaurant, laboratoire }

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

/* SI UNE IMAGE EST SÉLECTIONNÉE SEL DEVIENT TRUE */
  bool _selectFile = false;

/* LE FICHIER IMAGE TELECHARGER DEPUIS LE PC */
  Uint8List? selectedImageInBytes;
  List<int> _selectedFile = [];

/* LE FICHIER IMAGE TELECHARGER DEPUIS LE PC A ENVOYER SUR INTERNET */
  FilePickerResult? result;

/* LA LISTE DE TOUS LES INGRÉDIENTS QUI SERONT CRÉÉS */
  List<Ingredient> ingredientsList = [];

/* LA LISTE DES UNITÉS DE MESURE */
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

/* LE TITRE DE LA RECETTE */
  final _titreRecette = TextEditingController();

/* LA DESCRIPTION DE LA RECETTE */
  final _descriptionRecette = TextEditingController();

/* LE CONTROLLER DE RECHERCHE */
  final _controller = TextEditingController();

/* CETTE VARIABLE DEVIENT TRUE QUAND UNE RECHERCHE EST EN COURS  */
  bool search = false;

/* LA LISTE DES MATIERES PREMIERES, DES QUANTITES, DES UNITES DE MESURE*/
  final List<TextEditingController> _matierePremieres = [];
  final List<TextEditingController> _quantite = [];
  final List<TextEditingController> _uniteDeMesure = [];
  final List<SingingCharacter> choix = [];

/*LA CLE DU FORMULAIRE*/
  final _formkey = GlobalKey<FormState>();

/*LA LISTE QUI CONTIENT LE CONTENU DE LA RECHERCHE*/
  List<recette.Recette> recetteSearch = [];

/*LA METHODE QUI PERMET D'AJOUTER UN INGREDIENT */
  _addFiel() {
    setState(() {
      _matierePremieres.add(TextEditingController());
      _quantite.add(TextEditingController());
      _uniteDeMesure.add(TextEditingController());
      choix.add(_character!);
    });
  }

  SingingCharacter? _character = SingingCharacter.restaurant;
/*LA METHODE QUI PERMET DE SUPPRIMER UN INGREDIENT */
  _removeItem(i) {
    setState(() {
      _matierePremieres.removeAt(i);
      _quantite.removeAt(i);
      _uniteDeMesure.removeAt(i);
    });
  }

/*LA METHODE QUI PERMET D' EFFACER LES TEXTFORMFIELDS ET LES INGREDIENTS*/
  _clear() {
    setState(() {
      _matierePremieres.clear();
      _quantite.clear();
      _uniteDeMesure.clear();

      _titreRecette.clear();
      _descriptionRecette.clear();
    });
  }

/*LA METHODE QUI PERMET DE SOUMETTRE LE CONTENU DU FORMULAIRE */
  void _submit() {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    } else if (_matierePremieres.length == 0) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.info(
          backgroundColor: Colors.red,
          message: "Les ingrédients sont obligatoires .",
        ),
      );
    } else {
      _formkey.currentState!.save();
      print(
          '----------------------------------------------------rrrrrrrrrrrrrrr');
      for (int i = 0; i < _matierePremieres.length; i++) {
        if (choix[i] == SingingCharacter.laboratoire) {
          ingredientsList.add(Ingredient(
            type: 'raw_material',
            rawmaterial: _matierePremieres[i].text,
            grammage: _quantite[i].text,
            unity: _uniteDeMesure[i].text,
          ));
        } else {
          ingredientsList.add(Ingredient(
            type: 'material',
            material: _matierePremieres[i].text,
            grammage: _quantite[i].text,
            unity: _uniteDeMesure[i].text,
          ));
        }
      }
      print('----------------------------------------------------');
      print(jsonEncode(ingredientsList));
      for (int i = 0; i < ingredientsList.length; i++) {
        if (ingredientsList[i].material != null) {
          print(ingredientsList[i].material);
        } else {
          print(ingredientsList[i].rawmaterial);
        }
      }
      print('----------------------------------------------------ZZZZZZZZZZ');
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
      //print(ingredientsList);

      setState(() {
        _selectFile = false;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _addFiel();
        });
      });
    }
  }

/*LA METHODE QUI PERMET DE FAIRE LA RECHERCHE*/
  void filterRecetteResults(String query) {
    final viewRecetteModel = ref.watch(recette.getDataRecettesFuture);
    List<recette.Recette> dummySearchList = [];
    dummySearchList.addAll(viewRecetteModel.listRecette);
    if (query.isNotEmpty) {
      List<recette.Recette> dummyListData = [];
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

/*EFFACER CES VARIABLES DE LA MEMOIRE SI ELLES NE SONT PAS UTILISEES */
  @override
  void dispose() {
    _titreRecette.dispose();
    _descriptionRecette.dispose();
    _controller.dispose();
    super.dispose();
  }

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
    final viewRecetteModel = ref.watch(recette.getDataRecettesFuture);
    final viewModelL = ref.watch(getDataLaboratoriesFuture);
    return AppLayout(
      content: SingleChildScrollView(
        child: Column(
          children: [
            if (!_showContent)
              /*LA BARRE JAUNE HAUTE*/
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                height: 80,
                color: Palette.yellowColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'GESTION DES RECETTES',
                    ),
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
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              _addFiel();
                            });
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
              ),
            _showContent
                /*LE FORMULAIRE DE CREATION DE RECETTE*/
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        color: Palette.yellowColor,
                        child: const Text(
                          'CREATION DE RECETTE',
                        ),
                      ),
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
                                textCapitalization:
                                    TextCapitalization.characters,
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
                                textCapitalization:
                                    TextCapitalization.characters,
                                enableSuggestions: false,
                                onEditingComplete: (() =>
                                    FocusScope.of(context).requestFocus()),
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Le titre de la recette est obligatoire !";
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
                              Container(
                                height: 300,
                                child: ListView.builder(
                                    itemCount: _matierePremieres.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                child: const Icon(
                                                    Icons.remove_circle),
                                                onTap: () {
                                                  _removeItem(index);
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: ListTile(
                                                    title: const Text(
                                                        'Restaurant'),
                                                    leading:
                                                        Radio<SingingCharacter>(
                                                      value: SingingCharacter
                                                          .restaurant,
                                                      groupValue: choix[index],
                                                      onChanged:
                                                          (SingingCharacter?
                                                              value) {
                                                        setState(() {
                                                          choix[index] = value!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ListTile(
                                                    title: const Text(
                                                        'Laboratoire'),
                                                    leading:
                                                        Radio<SingingCharacter>(
                                                      value: SingingCharacter
                                                          .laboratoire,
                                                      groupValue: choix[index],
                                                      onChanged:
                                                          (SingingCharacter?
                                                              value) {
                                                        setState(() {
                                                          choix[index] = value!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              /* MATIÈRE PREMIÈRE */
                                              choix[index] ==
                                                      SingingCharacter
                                                          .restaurant
                                                  ? Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
                                                        child: Container(
                                                          color: Palette
                                                              .secondaryBackgroundColor,
                                                          child:
                                                              DropdownButtonFormField(
                                                            hint: const Text(
                                                              'Matière Première via Restaurant*',
                                                            ),
                                                            validator: (value) {
                                                              if (value ==
                                                                  null) {
                                                                return "Le nom de la matière première est obligatoire.";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                            ),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _matierePremieres[
                                                                            index]
                                                                        .text =
                                                                    value
                                                                        .toString();
                                                              });
                                                            },
                                                            onSaved: (value) {
                                                              setState(() {
                                                                _matierePremieres[
                                                                            index]
                                                                        .text =
                                                                    value
                                                                        .toString();
                                                              });
                                                            },
                                                            items: viewModel
                                                                .listMatiere
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
                                                    )
                                                  : Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
                                                        child: Container(
                                                          color: Palette
                                                              .secondaryBackgroundColor,
                                                          child:
                                                              DropdownButtonFormField(
                                                            hint: const Text(
                                                              'Matière Première via Laboratoire*',
                                                            ),
                                                            validator: (value) {
                                                              if (value ==
                                                                  null) {
                                                                return "Le nom de la matière première est obligatoire.";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                            ),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _matierePremieres[
                                                                            index]
                                                                        .text =
                                                                    value
                                                                        .toString();
                                                              });
                                                            },
                                                            onSaved: (value) {
                                                              setState(() {
                                                                _matierePremieres[
                                                                            index]
                                                                        .text =
                                                                    value
                                                                        .toString();
                                                              });
                                                            },
                                                            items: viewModelL
                                                                .listFINI
                                                                .map((val) {
                                                              return DropdownMenuItem(
                                                                value: val.sId,
                                                                child: Text(
                                                                  val.title!,
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
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller:
                                                        _quantite[index],
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "La quantité est obligatoire !";
                                                      } else if (value == "0") {
                                                        return "La quantité doit être supérieur a zéro minute !";
                                                      }
                                                      return null;
                                                    },
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp(r'[0-9]')),
                                                    ],
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
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
                                                  child:
                                                      DropdownButtonFormField(
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
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _uniteDeMesure[index]
                                                                .text =
                                                            value.toString();
                                                      });
                                                    },
                                                    onSaved: (value) {
                                                      setState(() {
                                                        _uniteDeMesure[index]
                                                                .text =
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
                                      );
                                    }),
                              ),
                              /*Column(
                                children: [
                                  for (int i = 0;
                                      i < _matierePremieres.length;
                                      i++)
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              child: const Icon(
                                                  Icons.remove_circle),
                                              onTap: () {
                                                _removeItem(i);
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: ListTile(
                                                  title:
                                                      const Text('Restaurant'),
                                                  leading:
                                                      Radio<SingingCharacter>(
                                                    value: SingingCharacter
                                                        .restaurant,
                                                    groupValue: _character,
                                                    onChanged:
                                                        (SingingCharacter?
                                                            value) {
                                                      setState(() {
                                                        _character = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListTile(
                                                  title:
                                                      const Text('Laboratoire'),
                                                  leading:
                                                      Radio<SingingCharacter>(
                                                    value: SingingCharacter
                                                        .laboratoire,
                                                    groupValue: _character,
                                                    onChanged:
                                                        (SingingCharacter?
                                                            value) {
                                                      setState(() {
                                                        _character = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            /* MATIÈRE PREMIÈRE */
                                            _character ==
                                                    SingingCharacter.restaurant
                                                ? Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      child: Container(
                                                        color: Palette
                                                            .secondaryBackgroundColor,
                                                        child:
                                                            DropdownButtonFormField(
                                                          hint: const Text(
                                                            'Matière Première via Restaurant*',
                                                          ),
                                                          validator: (value) {
                                                            if (value == null) {
                                                              return "Le nom de la matière première est obligatoire.";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _matierePremieres[
                                                                          i]
                                                                      .text =
                                                                  value
                                                                      .toString();
                                                            });
                                                          },
                                                          onSaved: (value) {
                                                            setState(() {
                                                              _matierePremieres[
                                                                          i]
                                                                      .text =
                                                                  value
                                                                      .toString();
                                                            });
                                                          },
                                                          items: viewModel
                                                              .listMatiere
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
                                                  )
                                                : Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      child: Container(
                                                        color: Palette
                                                            .secondaryBackgroundColor,
                                                        child:
                                                            DropdownButtonFormField(
                                                          hint: const Text(
                                                            'Matière Première via Laboratoire*',
                                                          ),
                                                          validator: (value) {
                                                            if (value == null) {
                                                              return "Le nom de la matière première est obligatoire.";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _matierePremieres[
                                                                          i]
                                                                      .text =
                                                                  value
                                                                      .toString();
                                                            });
                                                          },
                                                          onSaved: (value) {
                                                            setState(() {
                                                              _matierePremieres[
                                                                          i]
                                                                      .text =
                                                                  value
                                                                      .toString();
                                                            });
                                                          },
                                                          items: viewModelL
                                                              .listFINI
                                                              .map((val) {
                                                            return DropdownMenuItem(
                                                              value: val.sId,
                                                              child: Text(
                                                                val.title!,
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
                                                padding:
                                                    const EdgeInsets.all(2),
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
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9]')),
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
                              ),*/
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    color: Palette.secondaryBackgroundColor,
                                    child: GestureDetector(
                                      onTap: () async {
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
                                            // file = result!.files.single;

                                            Uint8List fileBytes = result!.files
                                                .single.bytes as Uint8List;

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
                                            width: 1,
                                            color: const Color(0xFFDCE0E0),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: _selectFile == false
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
                                        setState(() {
                                          _selectFile = false;
                                          _showContent = !_showContent;
                                          _clear();
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
                      ),
                    ],
                  )

                /*LA BARRE DE RECHERCHE ET LES RECETTES*/
                : Column(
                    children: [
                      const SizedBox(height: 20),
                      /*LA BARRE DE RECHERCHE*/
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

                      /*SI LA LISTE DES RECETTES EST VIDE AFFICHER AUCUNE RECETTE TROUVEE*/
                      viewRecetteModel.listRecette.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(50.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Aucune recette ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                            )
                          /*SI NOUS AVONS DES RECETTES*/
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(50.0),
                              ),
                              /*SI NOUS FAISONS UNE RECHERCHE DE RECETTE*/
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
                                                      'http://13.39.81.126:4010${recette.image}',
                                                      height: 180,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          color: Colors.black,
                                                          child: const Center(
                                                            child: Text(
                                                              "Pas d'image",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        );
                                                      },
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
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Container(
                                                                color: Colors
                                                                    .black,
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    "Pas d'image",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              );
                                                            },
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
    final viewRecetteModel = ref.watch(recette.getDataRecettesFuture);
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
        "http://13.39.81.126:4010/api/recettes/create"); //13.39.81.126
    print(url);
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    //var ingredient = jsonEncode(ingredientsList).toString();
    var json = {
      'title': title,
      'description': description,
      'engredients': ingredientsList,
      '_creator': id,
      'restaurant': restaurantid!.trim(),
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    if (result != null) {
      request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result.files.first.name));
    }

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
        setState(() {
          _clear();
          _showContent = false;
        });
        //stopMessage();
        //finishWorking();

        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Recette Crée",
          ),
        );
        ref.refresh(recette.getDataRecettesFuture);
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
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

  Future<http.Response> deleteRecette(BuildContext context, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userdelete = prefs.getString('IdUser').toString();
      var token = prefs.getString('token');
      String urlDelete = "http://13.39.81.126:4010/api/recettes/delete/$id";
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
        ref.refresh(recette.getDataRecettesFuture);

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
  String? rawmaterial;
  String? grammage;
  String? unity;
  String? type;

  Ingredient({
    this.material,
    this.rawmaterial,
    this.grammage,
    this.unity,
    this.type,
  });

  Ingredient.fromJson(Map<String, dynamic> json) {
    material = json['material'];
    rawmaterial = json['raw_material'];
    grammage = json['grammage'];
    unity = json['unity'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['material'] = material;
    data['raw_material'] = rawmaterial;
    data['grammage'] = grammage;
    data['unity'] = unity;
    data['type'] = type;
    return data;
  }
}
