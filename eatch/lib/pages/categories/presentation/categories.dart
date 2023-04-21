import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/applayout.dart';
import '../../../utils/default_button/default_button.dart';
import '../../../utils/palettes/palette.dart';
import '../../../utils/size/size.dart';
import '../../produits/infrastructure/produits_repository.dart';
import '../../produits/presentation/product_grid.dart';
import '../application/search_categories_text_field.dart';
import '../infrastructure/categories_repository.dart';
import 'categorie_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
  });

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _showContent = false;
  bool _obscureText = true;
  bool _cnfirmObscureText = true;

  //**********************************/
  final _formKey = GlobalKey<FormState>();

  String _nom = "";
  String _prenom = "";
  String _nomUtilisateur = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  String _currentSelectedValue = "";
  String? _role;
  List<String> listOfRole = [
    "RÔLE_COMPTABLE",
    "RÔLE_RH",
    "RÔLE_MANAGER",
  ];

  final FocusNode _prenomFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nomUtilisateurFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _prenomFocusNode.dispose();
    _nomUtilisateurFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  //**********************************/
  int selectedIndexCategorie = 0;
  final PageController _pageController = PageController();

  //************************* */
  // final nameController = TextEditingController();
  // bool onError = false;
  //************************ */

  @override
  Widget build(BuildContext context) {
    final filterproductsList = productsList.where((prod) {
      return prod.categories
          .contains(categoriesList[selectedIndexCategorie].id);
    }).toList();
    SizeConfig().init(context);

    return AppLayout(
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            top: 10,
          ),
          color: Palette.secondaryBackgroundColor,
          child: Column(children: [
            /**
                !PREMIERE LIGNE 
                                **/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("TOUTES LES CATÉGORIES"),
                if (!_showContent)
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showContent = !_showContent;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 200,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: const BoxDecoration(
                            color: Palette.primaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.add,
                                color: Palette.primaryBackgroundColor,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 05.0,
                                  ),
                                  child: Text(
                                    "Ajouter une catégorie",
                                    style: TextStyle(
                                      color: Palette.primaryBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 20),
            _showContent
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          nomForm(),
                          const SizedBox(height: 20),
                          prenomForm(),
                          const SizedBox(height: 20),
                          nomUtilisateurForm(),
                          const SizedBox(height: 20),
                          emailForm(),
                          const SizedBox(height: 20),
                          passwordForm(),
                          const SizedBox(height: 20),
                          confirmPasswordForm(),
                          const SizedBox(height: 20),
                          roleForm(),
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
                                      print("nom is $_nom");
                                      print("prenom is $_prenom");
                                      print("nomuser is $_nomUtilisateur");
                                      print("Email is $_email");
                                      print("pass is $_password");
                                      print("conf is $_confirmPassword");
                                      print("conf is $_role");
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
                                    setState(() {
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
                : Container(),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: SizedBox(width: 300, child: SearchCategories()),
            ),
            /**
                !DEUXIEME LIGNE 
                               **/
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    shadowColor: Palette.fourthColor,
                    child: SizedBox(
                      height: getProportionateScreenHeight(760.0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                          left: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.white,
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  bottom: 10.0,
                                  right: 10.0,
                                ),
                                child: Text(
                                  "Catégories",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.textPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: categoriesList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 01,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 4.1,
                                  ),
                                  itemBuilder: (context, index) =>
                                      CategorieCard(
                                    categorie: categoriesList[index],
                                    index: index,
                                    onPress: () {
                                      setState(() {
                                        selectedIndexCategorie = index;
                                        _pageController.jumpToPage(index);
                                      });
                                    },
                                    selectedIndex: selectedIndexCategorie,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 7,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    shadowColor: Palette.fourthColor,
                    child: SizedBox(
                      height: getProportionateScreenHeight(760.0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                          left: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 10.0,
                                  right: 10.0,
                                ),
                                child: Text(
                                  categoriesList[selectedIndexCategorie].title,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.textPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            //LES PRODUITS
                            // Expanded(
                            //   child: PageView(
                            //     scrollDirection: Axis.vertical,
                            //     physics: const NeverScrollableScrollPhysics(),
                            //     controller: _pageController,
                            //     children: [
                            //       for (var i = 0;
                            //           i < categoriesList.length;
                            //           i++)
                            //         filterproductsList.isEmpty
                            //             ? const Center(
                            //                 child: Text(
                            //                   'Aucune infrmation trouvée',
                            //                 ),
                            //               )
                            //             : Row(
                            //                 children: [
                            //                   Expanded(
                            //                     child: Column(
                            //                       children: [
                            //                         const Align(
                            //                           alignment:
                            //                               Alignment.centerLeft,
                            //                           child: Padding(
                            //                             padding:
                            //                                 EdgeInsets.only(
                            //                                     left: 32.0),
                            //                             child: Text(
                            //                               'Name',
                            //                               style: TextStyle(
                            //                                   fontFamily:
                            //                                       'Poppins',
                            //                                   fontStyle:
                            //                                       FontStyle
                            //                                           .normal,
                            //                                   fontSize: 16,
                            //                                   color: Palette
                            //                                       .textPrimaryColor),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                         Container(
                            //                             color: Colors.green,
                            //                             padding:
                            //                                 const EdgeInsets
                            //                                     .symmetric(
                            //                               horizontal: 30,
                            //                               vertical: 5,
                            //                             ),
                            //                             child: TextFormField(
                            //                               style: const TextStyle(
                            //                                   color: Palette
                            //                                       .textPrimaryColor,
                            //                                   fontSize: 14),
                            //                               controller:
                            //                                   nameController,
                            //                               decoration:
                            //                                   InputDecoration(
                            //                                 hoverColor: Palette
                            //                                     .primaryBackgroundColor,
                            //                                 contentPadding:
                            //                                     const EdgeInsets
                            //                                             .fromLTRB(
                            //                                         8,
                            //                                         5,
                            //                                         10,
                            //                                         5),
                            //                                 filled: true,
                            //                                 fillColor: Palette
                            //                                     .primaryBackgroundColor,
                            //                                 enabledBorder:
                            //                                     OutlineInputBorder(
                            //                                   borderRadius:
                            //                                       BorderRadius
                            //                                           .circular(
                            //                                               10),
                            //                                   borderSide: const BorderSide(
                            //                                       color: Palette
                            //                                           .secondaryBackgroundColor),
                            //                                   gapPadding: 10,
                            //                                 ),
                            //                                 border:
                            //                                     OutlineInputBorder(
                            //                                   borderRadius:
                            //                                       BorderRadius
                            //                                           .circular(
                            //                                               10),
                            //                                   borderSide: const BorderSide(
                            //                                       color: Palette
                            //                                           .secondaryBackgroundColor),
                            //                                   gapPadding: 10,
                            //                                 ),
                            //                                 focusedBorder:
                            //                                     OutlineInputBorder(
                            //                                   borderRadius:
                            //                                       BorderRadius
                            //                                           .circular(
                            //                                               10),
                            //                                   borderSide: const BorderSide(
                            //                                       color: Palette
                            //                                           .secondaryBackgroundColor),
                            //                                   gapPadding: 10,
                            //                                 ),
                            //                                 labelText:
                            //                                     "Catégorie",
                            //                                 labelStyle:
                            //                                     const TextStyle(
                            //                                   color: Palette
                            //                                       .textPrimaryColor,
                            //                                   fontSize: 16,
                            //                                   fontFamily:
                            //                                       'Poppins',
                            //                                   fontStyle:
                            //                                       FontStyle
                            //                                           .normal,
                            //                                 ),
                            //                               ),
                            //                               validator:
                            //                                   (String? val) {
                            //                                 if (val!.isEmpty) {
                            //                                   return "Your name is required";
                            //                                 }

                            //                                 return null;
                            //                               },
                            //                             )),
                            //                         onError
                            //                             ? Positioned(
                            //                                 bottom: 0,
                            //                                 child: Padding(
                            //                                   padding:
                            //                                       const EdgeInsets
                            //                                               .only(
                            //                                           left: 30),
                            //                                   child: Text('',
                            //                                       style: TextStyle(
                            //                                           color: Colors
                            //                                               .red)),
                            //                                 ))
                            //                             : Container(),
                            //                         SizedBox(
                            //                           height: 10,
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                   const SizedBox(width: 20),
                            //                   Expanded(
                            //                     child: Container(
                            //                       color: Colors.yellow,
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //     ],
                            //   ),
                            // ),

                            Expanded(
                              child: PageView(
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                controller: _pageController,
                                children: [
                                  for (var i = 0;
                                      i < categoriesList.length;
                                      i++)
                                    filterproductsList.isEmpty
                                        ? const Center(
                                            child: Text(
                                              'Aucun Produit trouvé',
                                            ),
                                          )
                                        : ProductsGrid(
                                            filterproductsList:
                                                filterproductsList,
                                          ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> roleForm() {
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
      value: _role,
      hint: const Text(
        'Rôle*',
      ),
      isExpanded: true,
      onChanged: (value) {
        setState(() {
          _role = value;
        });
      },
      onSaved: (value) {
        setState(() {
          _role = value;
        });
      },
      validator: (String? value) {
        if (value == null) {
          return "Le rôle de l’utilisateur est obligatoire.";
        } else {
          return null;
        }
      },
      items: listOfRole.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(
            val,
          ),
        );
      }).toList(),
    );
  }

  TextFormField passwordForm() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      focusNode: _passwordFocusNode,
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: (() =>
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode)),
      obscureText: !_obscureText,
      onChanged: (value) {
        _password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Le mot de passe est obligatoire.";
        } else if (value.length < 8) {
          return "Ce champ doit contenir au moins 8 lettres.";
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
        hintText: "Password*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: (_obscureText
              ? const CustomSurffixIcon(svgIcon: "assets/icons/eye.svg")
              : const CustomSurffixIcon(svgIcon: "assets/icons/eye_slash.svg")),
        ),
      ),
      onSaved: (value) {
        _password = value!;
      },
    );
  }

  TextFormField confirmPasswordForm() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      focusNode: _confirmPasswordFocusNode,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !_cnfirmObscureText,
      onChanged: (value) {
        _confirmPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Le mot de passe est obligatoire.";
        } else if (value != _password) {
          return "Les mots de passes ne sont pas conformes.";
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
        hintText: "Confirm Password*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _cnfirmObscureText = !_cnfirmObscureText;
            });
          },
          child: (_cnfirmObscureText
              ? const CustomSurffixIcon(svgIcon: "assets/icons/eye.svg")
              : const CustomSurffixIcon(svgIcon: "assets/icons/eye_slash.svg")),
        ),
      ),
      onSaved: (value) {
        _confirmPassword = value!;
      },
    );
  }

  TextFormField nomForm() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      autocorrect: true,
      textCapitalization: TextCapitalization.characters,
      enableSuggestions: false,
      onEditingComplete: (() =>
          FocusScope.of(context).requestFocus(_prenomFocusNode)),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "S'il vous plaît entrez le nom de l'utilisateur .";
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
        hintText: "Nom*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/user.svg"),
      ),
      onSaved: (value) {
        _nom = value!;
      },
    );
  }

  TextFormField prenomForm() {
    return TextFormField(
      focusNode: _prenomFocusNode,
      textInputAction: TextInputAction.next,
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
      enableSuggestions: false,
      onEditingComplete: (() =>
          FocusScope.of(context).requestFocus(_nomUtilisateurFocusNode)),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "S'il vous plaît entrez le prénom de l'utilisateur .";
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
        hintText: "Prénom*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/user.svg"),
      ),
      onSaved: (value) {
        _prenom = value!;
      },
    );
  }

  TextFormField nomUtilisateurForm() {
    return TextFormField(
      focusNode: _nomUtilisateurFocusNode,
      textInputAction: TextInputAction.next,
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
      enableSuggestions: false,
      onEditingComplete: (() =>
          FocusScope.of(context).requestFocus(_emailFocusNode)),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "S'il vous plaît entrez le nom d'utilisateur .";
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
        hintText: "Nom d'utilisateur*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/user.svg"),
      ),
      onSaved: (value) {
        _nomUtilisateur = value!;
      },
    );
  }

  TextFormField emailForm() {
    return TextFormField(
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      enableSuggestions: false,
      onEditingComplete: (() => FocusScope.of(context).requestFocus()),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "L' adresse e-mail est obligatoire.";
        } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return "L' adresse e-mail invalide.";
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
        hintText: "Adresse Email*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(
            svgIcon: "assets/icons/envelope_open_text.svg"),
      ),
      onSaved: (value) {
        _email = value!;
      },
    );
  }
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
