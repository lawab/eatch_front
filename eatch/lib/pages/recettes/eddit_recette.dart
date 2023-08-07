import 'dart:convert';
import 'dart:js_interop';

import 'package:eatch/pages/recettes/recettes.dart';
import 'package:eatch/servicesAPI/getLabo.dart';
import 'package:eatch/servicesAPI/getMatiere.dart';
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
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;

enum SingingCharacter { restaurant, laboratoire }

class EdditRecette extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final String image;
  final String sId;
  final List<Engredients> ingredients;
  const EdditRecette({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.sId,
    required this.ingredients,
  });

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

/* LA LISTE QUI VA CONTENIR LES INGREDIENTS */
  List<Matiere> listmatiere = [];

  // ***** LES VARIABLES ****** //
  bool isLoading = false;
  bool _selectFile = false;

  Uint8List? selectedImageInBytes;
  FilePickerResult? result;

  List<int> _selectedFile = [];
  bool filee = false;
  PlatformFile? file;

  String? recetteImage;
/* LA LISTE DE TOUS LES INGRÉDIENTS QUI SERONT CRÉÉS */
  List/*<Ingredient>*/ ingredientsList = [];
  List ingredientsListold = [];
  final List<SingingCharacter> choix = [];
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
  late final _titreRecette = TextEditingController(text: widget.title);

/* LA DESCRIPTION DE LA RECETTE */
  late final _descriptionRecette =
      TextEditingController(text: widget.description);

/* LA LISTE DES MATIERES PREMIERES, DES QUANTITES, DES UNITES DE MESURE*/
  final List<TextEditingController> _matierePremieres = [];
  final List<TextEditingController> _quantite = [];
  final List<TextEditingController> _uniteDeMesure = [];

/* LA LISTE DES MATIERES PREMIERES, DES QUANTITES, DES UNITES DE MESURE OLD*/
  final List<TextEditingController> _matierePremieresold = [];
  // final List<TextEditingController> _quantite = [];
  // final List<TextEditingController> _uniteDeMesure = [];

/*LA CLE DU FORMULAIRE*/
  final _formkey = GlobalKey<FormState>();

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
    setState(() {
      // ingredientsListold.addAll(widget.ingredients);
      // ingredientsList.addAll(ingredientsListold);
      //ingredientsList.addAll(widget.ingredients);
      for (int i = 0; i < widget.ingredients.length; i++) {
        print('recette');
        if (widget.ingredients[i].material != null) {
          ingredientsList.add(Ingredient(
            type: 'material',
            material: widget.ingredients[i].material!.sId!,
            grammage: widget.ingredients[i].material!.grammage.toString(),
            unity: widget.ingredients[i].material!.unity.toString(),
          ));
        } else {
          ingredientsList.add(Ingredient(
            type: 'raw_material',
            rawmaterial: widget.ingredients[i].rowMaterial!.sId!,
            grammage: widget.ingredients[i].rowMaterial!.grammage.toString(),
            unity: widget.ingredients[i].rowMaterial!.unity.toString(),
          ));
        }
      }
    });
    final isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    } else if (ingredientsList.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.info(
          backgroundColor: Colors.red,
          message: "Les ingrédients sont obligatoires .",
        ),
      );
    }
    _formkey.currentState!.save();

    // for (int i = 0; i < widget.ingredients.length; i++) {
    //   ingredientsList.add(Ingredient(
    //     material: widget.ingredients[i].material!.sId!,
    //     grammage: widget.ingredients[i].grammage.toString(),
    //     unity: widget.ingredients[i].unity.toString(),
    //   ));
    // }

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

    /*for (int i = 0; i < _matierePremieres.length; i++) {
      ingredientsList.add(Ingredient(
        material: _matierePremieres[i].text,
        grammage: _quantite[i].text,
        unity: _uniteDeMesure[i].text,
      ));
    }*/

    print("IMMMMMAGGAGAGAGAGAGAGAGAGAGA");
    print(_selectedFile);
    //print(result);
    print(_titreRecette.text);
    print(_descriptionRecette.text);
    print('iiiiiiiiiiiiiiiiiii');
    print(jsonEncode(ingredientsList));
    print('iiiiiiiiiiiiiiiiiii');
    /*updateRecette(
      context,
      _selectedFile,
      result,
      _titreRecette.text,
      _descriptionRecette.text,
      ingredientsList,
    );*/

    // _clear();
    setState(() {
      // _selectFile = false;
      // result = null;
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   _addFiel();
      // });
    });
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => const RecettesPage()),
    //     (Route<dynamic> route) => false);
  }

/*EFFACER CES VARIABLES DE LA MEMOIRE SI ELLES NE SONT PAS UTILISEES */
  @override
  void dispose() {
    _titreRecette.dispose();
    _descriptionRecette.dispose();
    super.dispose();
  }

  /*LA LISTE QUI VA CONTENIR LES ID DES INGREDIENTS*/
  // List<String> engredientsId = [];
  // List<String?> idValues = [];
  bool ingre = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataMatiereFuture);
    print(viewModel.listMatiere);
    print(jsonEncode(widget.ingredients));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            SizeConfig().init(context);
            return horizontalView(height(context), width(context), context,
                viewModel.listMatiere);
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

  Widget horizontalView(
      double height, double width, context, List<Matiere> listMatieres) {
    listmatiere.addAll(listMatieres);
    final viewModelL = ref.watch(getDataLaboratoriesFuture);
    // final viewRecetteModel = ref.watch(getDataRecettesFuture);

    final viewModel = ref.watch(getDataMatiereFuture);
    return AppLayout(
      content: SingleChildScrollView(
        /*LE FORMULAIRE DE CREATION DE RECETTE*/
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              height: 80,
              color: Palette.yellowColor,
              child: const Text(
                'Modifier la Recette',
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

                    /* ENSEMBLE DES ANCIENS INGRÉDIENTS */
                    Column(
                      children: [
                        for (int j = 0; j < widget.ingredients.length; j++)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: const Icon(Icons.remove_circle),
                                    onTap: () {
                                      setState(() {
                                        widget.ingredients.remove(
                                          widget.ingredients[j],
                                        );
                                      });
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
                                            widget.ingredients[j].material
                                                    .isNull
                                                ? widget.ingredients[j]
                                                    .rowMaterial!.title
                                                    .toString()
                                                : widget.ingredients[j]
                                                    .material!.mpName
                                                    .toString(),
                                          ),
                                          decoration: InputDecoration(
                                            enabled: false,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          onChanged: null,
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
                                        initialValue: widget
                                                .ingredients[j].material.isNull
                                            ? widget.ingredients[j].rowMaterial!
                                                .grammage
                                                .toString()
                                            : widget.ingredients[j].material!
                                                .grammage
                                                .toString(),
                                        enabled: false,
                                        keyboardType: TextInputType.number,
                                        // validator: (value) {
                                        //   if (value!.isEmpty) {
                                        //     return "La quantité est obligatoire !";
                                        //   } else if (value == "0") {
                                        //     return "La quantité doit être supérieur a zéro minute !";
                                        //   }
                                        //   return null;
                                        // },
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
                                        hint: Text(
                                          widget.ingredients[j].material.isNull
                                              ? widget.ingredients[j]
                                                  .rowMaterial!.unity
                                                  .toString()
                                              : widget.ingredients[j].material!
                                                  .unity
                                                  .toString(),
                                        ),
                                        // validator: (value) {
                                        //   if (value == null) {
                                        //     return "L ' Unité de mésure est obligatoire.";
                                        //   } else {
                                        //     return null;
                                        //   }
                                        // },
                                        decoration: InputDecoration(
                                          enabled: false,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        onChanged: null,
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
                    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                    /* ENSEMBLE DES ANCIENS INGRÉDIENTS */
                    /*
                    Container(
                      height: 50.0 * widget.ingredients.length.toInt(),
                      child: ListView.builder(
                          itemCount: widget.ingredients.length,
                          itemBuilder: ((context, index) {
                            print('widget.ingredients.length');
                            print(widget.ingredients.length);
                            var vall = '';

                            for (var i = 0; i < listmatiere.length; i++) {
                              if (widget.ingredients[index].material!.mpName ==
                                  listmatiere[i].mpName) {
                                print(
                                    "ioiooooooooooooooooooooooooooooooooooooooo");
                                vall = listmatiere[i].mpName!;
                                // listmatiere.add(viewModel.listMatiere[i]);
                                ingre = true;
                              }
                            }

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      child: const Icon(Icons.remove_circle),
                                      onTap: () {
                                        setState(() {
                                          widget.ingredients.remove(
                                              widget.ingredients[index]);
                                          // listmatiere.remove();
                                        });
                                        print(widget.ingredients.length);
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
                                          color:
                                              Palette.secondaryBackgroundColor,
                                          child: DropdownButtonFormField(
                                            value: vall,
                                            items: listmatiere.map((val) {
                                              return DropdownMenuItem(
                                                value: val.mpName,
                                                child: Text(
                                                  val.mpName!,
                                                ),
                                              );
                                            }).toList(),
                                            // hint: Text(
                                            //   widget.ingredients[j].material!
                                            //       .mpName!,
                                            // ),
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
                                                listmatiere[index].mpName =
                                                    value;
                                                // _matierePremieresold[index]
                                                //     .text = value!;
                                              });
                                            },
                                            onSaved: (value) {
                                              setState(() {
                                                _matierePremieresold[index]
                                                    .text = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    /*
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
                                */
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          })),
                    ),
                    */
                    const SizedBox(height: 20),

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
                              Container(
                                width: MediaQuery.of(context).size.width / 4,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ListTile(
                                        title: const Text('Restaurant'),
                                        leading: Radio<SingingCharacter>(
                                          value: SingingCharacter.restaurant,
                                          groupValue: choix[i],
                                          onChanged: (SingingCharacter? value) {
                                            setState(() {
                                              choix[i] = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: const Text('Laboratoire'),
                                        leading: Radio<SingingCharacter>(
                                          value: SingingCharacter.laboratoire,
                                          groupValue: choix[i],
                                          onChanged: (SingingCharacter? value) {
                                            setState(() {
                                              choix[i] = value!;
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

                    /* LE CADRE POUR L'IMAGE ET LES BOUTONS*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                });
                              }
                            },
                            child: Container(
                              width: SizeConfig.screenWidth * 0.05,
                              height: SizeConfig.screenWidth * 0.05,
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
                                        'http://13.39.81.126:4010${widget.image}',
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
                              // setState(() {
                              //   _selectFile = false;
                              //   _clear();
                              // });
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RecettesPage()),
                                  (Route<dynamic> route) => false);
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
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    final viewModel = ref.watch(getDataMatiereFuture);
    final viewRecetteModel = ref.watch(getDataRecettesFuture);
    return AppLayout(
      content: Container(),
    );
  }

  Future<void> updateRecette(
    BuildContext context,
    selectedFile,
    result,
    String title,
    String description,
    List/*<Ingredient>*/ ingredients,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var restaurantid = prefs.getString('idRestaurant');
    print(id);
    print(token);
    print("Restaurant id $restaurantid");

    var url =
        Uri.parse("http://13.39.81.126:4010/api/recettes/update/${widget.sId}");

    final request = MultipartRequest(
      'PUT',
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
      'restaurant': restaurantid!,
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
      print('imagggggggggggggggggggeeeeeeeeeeeeeee');
    }

    print(
        "RESPENSE SEND STEAM FILE REQ *****************************************************");
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
          ref.refresh(getDataRecettesFuture);
        });

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Recette modifiée avec succès",
          ),
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RecettesPage()));
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur du Serveur",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

/*
  Future<void> updateRecette(
    contextt,
    String title,
    String description,
    List/*<Ingredient>*/ ingredients,
    selectedFile,
    result,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var restaurantid = prefs.getString('idRestaurant');
    String adressUrl = prefs.getString('ipport').toString();
    var url = Uri.parse(
        "http://13.39.81.126:4010/api/recettes/update/${widget.sId}"); //13.39.81.126
    print(url);
    final request = MultipartRequest(
      'PUT',
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
        //stopMessage();
        //finishWorking();

        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Recette Crée",
          ),
        );
        ref.refresh(getDataRecettesFuture);
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
 */
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
