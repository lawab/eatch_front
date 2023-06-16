// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:js_interop';

import 'package:eatch/servicesAPI/getLabo.dart';
import 'package:eatch/servicesAPI/getRestaurant.dart' as g;
import 'package:eatch/servicesAPI/get_role.dart';
import 'package:eatch/servicesAPI/get_user.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'dart:typed_data';
import 'package:eatch/pages/users/presentation/allUser.dart';
import 'package:eatch/pages/users/presentation/userComptable.dart';
import 'package:eatch/pages/users/presentation/userEmploye.dart';
import 'package:eatch/pages/users/presentation/userManger.dart';
import 'package:eatch/servicesAPI/multipart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../utils/applayout.dart';
import '../../../utils/default_button/default_button.dart';
import '../../../utils/palettes/palette.dart';
import '../../../utils/size/size.dart';

enum SingingCharacter { restaurant, laboratoire }

class Users extends ConsumerStatefulWidget {
  const Users({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Users> createState() => _UsersState();
}

class _UsersState extends ConsumerState<Users> {
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

  final _formKey = GlobalKey<FormState>();

  bool _showContent = false;
  bool _obscureText = true;
  bool _cnfirmObscureText = true;

  String _nom = "";
  String _prenom = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  String? _role;
  String? _restaurant;

  String? _nouveauRole;
  List<String> listOfRole = ["COMPTABLE", "RH", "EMPLOYEE", "LABORANTIN"];

  final FocusNode _prenomFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _prenomFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  // text controller
  final _roleController = TextEditingController();

  //**********************************/

  /* LE LOADING PENDANT LE TÉLÉCHARGEMENT DE L’IMAGE DE LA RECETTE */
  bool isLoading = false;

/* SI UNE IMAGE EST SÉLECTIONNÉE SEL DEVIENT TRUE */
  bool _selectFile = false;

/* LE FICHIER IMAGE TELECHARGER DEPUIS LE PC */
  Uint8List? selectedImageInBytes;
  List<int> _selectedFile = [];

/* LE FICHIER IMAGE TELECHARGER DEPUIS LE PC A ENVOYER SUR INTERNET */
  String? restaurant;
  String? laboratoire;
  String? restaurantId;
  String? laboratoireId;
  FilePickerResult? result;
  bool rest = false;
  bool lab = false;
  List<String> laboo = [];
  List<String> restauu = [];
  SingingCharacter? _character = SingingCharacter.restaurant;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(g.getDataRsetaurantFuture);
    final viewModele = ref.watch(getDataLaboratoriesFuture);
    if (rest == false) {
      for (int i = 0; i < viewModel.listRsetaurant.length; i++) {
        restauu.add(viewModel.listRsetaurant[i].restaurantName!);
        setState(() {
          rest = true;
        });
      }
    }
    if (lab == false) {
      for (int i = 0; i < viewModele.listLabo.length; i++) {
        laboo.add(viewModele.listLabo[i].laboName!);
        setState(() {
          lab = true;
        });
      }
    }

    SizeConfig().init(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listRsetaurant, viewModele.listLabo, laboo, restauu);
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
    double height,
    double width,
    context,
    List<g.Restaurant> restau,
    List<Labo> labo,
    List<String> labooo,
    List<String> restauuu,
  ) {
    return AppLayout(
      content: SingleChildScrollView(
        child: Container(
          /*padding: const EdgeInsets.only(
            left: 10,
            top: 10,
          ),*/
          color: Palette.secondaryBackgroundColor,
          child: Column(
            children: [
              _showContent
                  ? Container(
                      alignment: Alignment.centerRight,
                      height: 50,
                      color: Palette.yellowColor, //Color(0xFFFCEBD1),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 50,
                          ),
                          const Text("CREATION D'UTILISATEURS"),
                          Expanded(child: Container()),
                        ],
                      ),
                    )
                  : Container(
                      alignment: Alignment.centerRight,
                      height: 80,
                      color: Palette.yellowColor, //Color(0xFFFCEBD1),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 50,
                          ),
                          const Text("GESTION DES UTILISATEURS"),
                          Expanded(child: Container()),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                minimumSize: const Size(180, 50)),
                            onPressed: () {
                              setState(() {
                                _showContent = !_showContent;
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text(
                              "Ajouter un utilisateur",
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 10),
              _showContent
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            nomForm(),
                            const SizedBox(height: 10),
                            prenomForm(),
                            const SizedBox(height: 10),
                            emailForm(),
                            const SizedBox(height: 10),
                            passwordForm(),
                            const SizedBox(height: 10),
                            confirmPasswordForm(),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(flex: 3, child: roleForm()),
                                /*const SizedBox(width: 20),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        addRole();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Palette.yellowColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.add,
                                        color: Palette.primaryBackgroundColor,
                                      ),
                                      label: const Text(
                                        " AJOUTER UN RÔLE",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Palette.primaryBackgroundColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),*/
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 100,
                              child: Column(children: [
                                Container(
                                  height: 50,
                                  width: 350,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ListTile(
                                          title: const Text('Restaurant'),
                                          leading: Radio<SingingCharacter>(
                                            value: SingingCharacter.restaurant,
                                            groupValue: _character,
                                            onChanged:
                                                (SingingCharacter? value) {
                                              setState(() {
                                                _character = value;
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
                                            groupValue: _character,
                                            onChanged:
                                                (SingingCharacter? value) {
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
                                _character == SingingCharacter.restaurant
                                    ? Expanded(
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            hoverColor:
                                                Palette.primaryBackgroundColor,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 42,
                                                    vertical: 20),
                                            filled: true,
                                            fillColor:
                                                Palette.primaryBackgroundColor,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Palette
                                                      .secondaryBackgroundColor),
                                              gapPadding: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Palette
                                                      .secondaryBackgroundColor),
                                              gapPadding: 10,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Palette
                                                      .secondaryBackgroundColor),
                                              gapPadding: 10,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                          value: restaurant,
                                          hint: const Text(
                                            'Restaurant*',
                                          ),
                                          isExpanded: true,
                                          onChanged: (value) {
                                            setState(() {
                                              restaurant = value;
                                            });
                                          },
                                          onSaved: (value) {
                                            setState(() {
                                              restaurant = value;
                                              for (int i = 0;
                                                  i < restau.length;
                                                  i++) {
                                                if (restaurant ==
                                                    restau[i].restaurantName) {
                                                  restaurantId = restau[i].sId;
                                                }
                                              }
                                            });
                                          },
                                          validator: (String? value) {
                                            if (value == null) {
                                              return "Le rôle de l'utilisateur est obligatoire.";
                                            } else {
                                              return null;
                                            }
                                          },
                                          items: restauuu.map((val) {
                                            return DropdownMenuItem(
                                              value: val,
                                              child: Text(
                                                val,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    : Expanded(
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            hoverColor:
                                                Palette.primaryBackgroundColor,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 42,
                                                    vertical: 20),
                                            filled: true,
                                            fillColor:
                                                Palette.primaryBackgroundColor,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Palette
                                                      .secondaryBackgroundColor),
                                              gapPadding: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Palette
                                                      .secondaryBackgroundColor),
                                              gapPadding: 10,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Palette
                                                      .secondaryBackgroundColor),
                                              gapPadding: 10,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                          value: laboratoire,
                                          hint: const Text(
                                            'Laboratoire*',
                                          ),
                                          isExpanded: true,
                                          onChanged: (value) {
                                            setState(() {
                                              laboratoire = value;
                                              for (int i = 0;
                                                  i < labo.length;
                                                  i++) {
                                                if (laboratoire ==
                                                    labo[i].laboName) {
                                                  laboratoireId = labo[i].sId;
                                                }
                                              }
                                            });
                                          },
                                          onSaved: (value) {
                                            setState(() {
                                              laboratoire = value;
                                            });
                                          },
                                          validator: (String? value) {
                                            if (value == null) {
                                              return "Le rôle de l'utilisateur est obligatoire.";
                                            } else {
                                              return null;
                                            }
                                          },
                                          items: labooo.map((val) {
                                            return DropdownMenuItem(
                                              value: val,
                                              child: Text(
                                                val,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                              ]),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 70),
                                  color: Palette.secondaryBackgroundColor,
                                  alignment: Alignment.centerRight,
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

                                          Uint8List fileBytes = result!
                                              .files.single.bytes as Uint8List;

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
                                        creationUser(
                                          context,
                                          _selectedFile,
                                          result,
                                          _prenom,
                                          _nom,
                                          _email,
                                          _role,
                                          _password,
                                          restaurantId,
                                          laboratoireId,
                                          _character!,
                                        );
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
                  : DefaultTabController(
                      length: 4,
                      child: Column(
                        children: [
                          const TabBar(
                            indicatorColor: Palette.primaryColor,
                            labelColor: Palette.primaryColor,
                            unselectedLabelColor: Palette.textsecondaryColor,
                            tabs: [
                              Tab(
                                text: "Tous les utilisateurs",
                                icon: Icon(Icons.people_rounded),
                              ),
                              Tab(
                                text: "Managers",
                                icon: Icon(Icons.handshake),
                              ),
                              Tab(
                                text: "Employés",
                                icon: Icon(Icons.manage_accounts),
                              ),
                              Tab(
                                text: "Comptables",
                                icon: Icon(Icons.monetization_on_sharp),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(850),
                            child: const TabBarView(
                              children: [
                                AllUsers(),
                                ManagerUsers(),
                                EmployerUsers(),
                                ComptableUsers(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

              /**
                !DEUXIEME LIGNE 
                               **/
            ],
          ),
        ),
      ),
    );
  }

  Widget verticalView(
    double height,
    double width,
    context,
  ) {
    return AppLayout(
      content: SizedBox(
        height: height,
        width: width,
        child: const Column(
          children: [],
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
          return "Le rôle de l'utilisateur est obligatoire.";
        } else {
          return null;
        }
      },
      items: listOfRole.map((val) {
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
        hintText: "Mot de passe*",
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
        hintText: "Confirmer le mot de passe*",
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
          FocusScope.of(context).requestFocus(_emailFocusNode)),
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

  Future<void> creationUser(
    BuildContext context,
    selectedFile,
    result,
    firstName,
    lastName,
    email,
    role,
    password,
    retaurantId,
    laboId,
    SingingCharacter verif,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var restaurantid = prefs.getString('idRestaurant');
    print(id);
    print(token);
    print("Restaurant id $restaurantid");

    var url = Uri.parse("http://192.168.1.105:4001/api/users/create");
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    Map<String, dynamic>? jsonn;
    if (verif == SingingCharacter.laboratoire) {
      print('LLLLLLLLLLLLLLLLLLLLLLAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBBBBBBB');
      jsonn = {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "laboratory": laboId,
        "role": role,
        "password": password,
        "_creator": id,
      };
    } else {
      print('RRRRRRRRRRRRRRRRRRRRRRRRREEEEEEEEEEEEEEEEEEESSSSSSSSSSSSSSSSS');
      jsonn = {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "restaurant": retaurantId,
        "role": role,
        "password": password,
        "_creator": id,
      };
    }

    var body = jsonEncode(jsonn);

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
        setState(() {
          _showContent = !_showContent;
        });
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Utilisateur créé",
          ),
        );
        ref.refresh(getDataUserFuture);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Echec de création d'utilisateur ",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  void saveNewRole() {
    setState(() {
      _roleController.clear();
    });
    Navigator.of(context).pop();
  }

  void addRole() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          roleController: _roleController,
          onSave: () {
            setState(() {
              creationRole(context, _roleController.text);
              _roleController.clear();
            });
            Navigator.of(context).pop();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  Future<void> creationRole(
    BuildContext context,
    value,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var restaurantid = prefs.getString('idRestaurant');
    print(id);
    print(token);
    print("Restaurant id $restaurantid");

    var url = Uri.parse("http://192.168.1.105:4001/api/users/create/role");
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      "restaurant": restaurantid,
      "value": value,
      "_creator": id,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    print("RESPENSE SEND STEAM FILE REQ");
    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);
    print('Roleeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });

        ref.refresh(getDataRoleFuture);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Le role a été crée",
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Role non créé",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}

class DialogBox extends StatelessWidget {
  final roleController;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.roleController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Palette.primaryBackgroundColor,
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              controller: roleController,
              textInputAction: TextInputAction.next,
              autocorrect: true,
              textCapitalization: TextCapitalization.characters,
              enableSuggestions: false,
              onEditingComplete: (() => FocusScope.of(context).requestFocus()),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Le role est obligatoire !";
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
                hintText: "Nouveau rôle*",
              ),
            ),
            const SizedBox(height: 20),

            // buttons -> save + cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // save button
                MyButton(
                  text: "Ajouter",
                  onPressed: onSave,
                  color: Palette.primaryColor,
                ),

                const SizedBox(width: 8),

                // cancel button
                MyButton(
                  text: "Annuler",
                  onPressed: onCancel,
                  color: Palette.deleteColors,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  Color color;
  MyButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      child: Text(
        text,
        style: const TextStyle(color: Palette.primaryBackgroundColor),
      ),
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
