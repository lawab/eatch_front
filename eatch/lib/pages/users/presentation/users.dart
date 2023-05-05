import 'package:eatch/pages/users/domain/user.dart';
import 'package:eatch/pages/users/presentation/allUser.dart';
import 'package:eatch/pages/users/presentation/userManger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/applayout.dart';
import '../../../utils/default_button/default_button.dart';
import '../../../utils/palettes/palette.dart';
import '../../../utils/size/size.dart';
import '../application/search_users_text_field.dart';
import '../infrastructure/users_data.dart';
import '../infrastructure/users_repository.dart';
import 'userComptable.dart';
import 'userEmploye.dart';

class Users extends StatefulWidget {
  const Users({
    super.key,
  });

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
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

  final filterRHList = eatchUsersList.where((rh) {
    return rh.userRole == "RÔLE_RH";
  }).toList();
  final filterManagementList = eatchUsersList.where((rh) {
    return rh.userRole == "RÔLE_MANAGER";
  }).toList();
  final filterComptableList = eatchUsersList.where((rh) {
    return rh.userRole == "RÔLE_COMPTABLE";
  }).toList();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return AppLayout(
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            top: 10,
          ),
          color: Palette.secondaryBackgroundColor,
          child: Column(
            children: [
              /**
                !PREMIERE LIGNE 
                                **/

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("GESTION DES UTILISATEURS"),
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
                            width: 180,
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
                                      "Ajouter un utilisateur",
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
              DefaultTabController(
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
                    Container(
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

  DataRow usersLists(EatchUser eatchUsersData) {
    return DataRow(
      cells: [
        DataCell(Text(eatchUsersData.userNom)),
        DataCell(Text(eatchUsersData.userPrenom)),
        DataCell(Text(eatchUsersData.userUserNom)),
        DataCell(Text(eatchUsersData.userEmail)),
        DataCell(Text(eatchUsersData.userRole)),
      ],
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
