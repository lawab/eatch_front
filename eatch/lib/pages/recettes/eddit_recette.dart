import 'package:eatch/servicesAPI/getMatiere.dart';
import 'package:eatch/servicesAPI/get_recettes.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/default_button/default_button.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:eatch/utils/size/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
/*===========================================*
* GESTION DE LA PARTIE RESPONSIVE DE LA PAGE *
*============================================*/
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

/*====================================*
* STRUCTURE GENERALE DE TOUTE LA PAGE *
*=====================================*/
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

/*================================*
* TOUTES LES VARIABLES DE LA PAGE *
*=================================*/

  /*
  ! La clé du formulaire
  */
  final _formkey = GlobalKey<FormState>();

  /*
  ! Le Controller du titre de la recette
  */
  late final _titreRecette = TextEditingController(text: widget.title);

  /*
  ! Le Controller de  la description de la recette
  */
  late final _descriptionRecette =
      TextEditingController(text: widget.description);

  /*
  ! =============================================================
  */
  // var stringListReturnedFromApiCall = [
  //   "first",
  //   "second",
  //   "third",
  //   "fourth",
  // ];
  List<String?> allAudio = [];

  List<TextEditingController> textEditingControllers = [];
  List maListe = [];
  @override
  void initState() {
    maListe.addAll(widget.ingredients);
    for (var element in maListe) {
      allAudio = (element["material"] as List<Map<String, String>>)
          .map((e) => e["_id"])
          .toList();
    }
    allAudio.forEach((String? str) {
      var textEditingController = TextEditingController(text: str);
      textEditingControllers.add(textEditingController);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // dispose textEditingControllers to prevent memory leaks
    for (TextEditingController textEditingController
        in textEditingControllers) {
      textEditingController.dispose();
    }
  }

  /*
  ! =============================================================
  */

/*================================*
* LE WIDGET HORIZONTAL DE LA PAGE *
*=================================*/
  Widget horizontalView(
    double height,
    double width,
    context,
  ) {
    final matiereData = ref.watch(getDataMatiereFuture);
    final recetteData = ref.watch(getDataRecettesFuture);

    return AppLayout(
      content: SingleChildScrollView(
        child: Column(
          children: [
/*====================================*
* LA BARRE JAUNE AU DESSUS DE LA PAGE *
*=====================================*/
            Container(
              alignment: Alignment.centerLeft,
              height: 80,
              color: Palette.yellowColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Palette.primaryBackgroundColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
/*=============================================*
* TOUTE LA PARTIE AU DESSOUS DE LA BARRE JAUNE *
*==============================================*/
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    /* 
                    ! TextFormField du titre de la recette
                    */
                    TextFormField(
                      controller: _titreRecette,
                      textInputAction: TextInputAction.next,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.characters,
                      enableSuggestions: false,
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
                          vertical: 10.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 10,
                        ),
                        hintText: "Le titre de la recette",
                      ),
                    ),
                    const SizedBox(height: 20),
                    /* 
                    ! TextFormField de la description de la recette
                    */
                    TextFormField(
                      controller: _descriptionRecette,
                      textInputAction: TextInputAction.next,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.characters,
                      enableSuggestions: false,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Le titre de la recette est obligatoire !";
                        } else if (value.length < 10) {
                          return "Entrez au moins 10 caractères !";
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
/*=================================*
* LA LISTE DES ANCIENS INGREDIENTS *
*==================================*/
                    Column(
                        children: List.generate(
                      widget.ingredients.length,
                      (index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                color: Palette.secondaryBackgroundColor,
                                child: DropdownButtonFormField(
                                  hint: Text(
                                    widget.ingredients[index].material!.mpName!,
                                  ),
                                  // validator: (value) {
                                  //   if (value == null) {
                                  //     return "Le nom de la matière première est obligatoire.";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      textEditingControllers[index].text =
                                          value.toString();
                                    });
                                  },
                                  items: matiereData.listMatiere.map((val) {
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
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    )),

/*========================================*
* LES TROIS DIFFERENTS BOUTONS DE LA PAGE *
*=========================================*/
                    Row(
                      children: [
                        /* 
                      ! Bouton Enregistrer les modifications
                      */
                        SizedBox(
                          width: 200,
                          child: DefaultButton(
                            color: Palette.primaryColor,
                            foreground: Colors.transparent,
                            text: 'ENREGISTRER',
                            textcolor: Palette.primaryBackgroundColor,
                            onPressed: () {
                              final isValid = _formkey.currentState!.validate();
                              if (!isValid) {
                                return;
                              } else {
                                _formkey.currentState!.save();
                                print(_titreRecette.text);
                                print(_descriptionRecette.text);
                                print(textEditingControllers);
                                print(allAudio);

                                setState(() {
                                  _titreRecette.clear();
                                  _descriptionRecette.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

/*==============================*
* LE WIDGET VERTICAL DE LA PAGE *
*===============================*/
  Widget verticalView(
    double height,
    double width,
    context,
  ) {
    final matiereData = ref.watch(getDataMatiereFuture);
    final recetteData = ref.watch(getDataRecettesFuture);
    return AppLayout(
      content: Container(),
    );
  }
}
