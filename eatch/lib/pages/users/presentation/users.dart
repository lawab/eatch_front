// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:eatch/servicesAPI/get_role.dart';
import 'package:eatch/servicesAPI/get_user.dart';
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
import '../../../utils/applayout.dart';
import '../../../utils/default_button/default_button.dart';
import '../../../utils/palettes/palette.dart';
import '../../../utils/size/size.dart';

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
  List<String> listOfRole = [
    "COMPTABLE",
    "RH",
    "EMPLOYEE",
  ];

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

  //**********************************/

  List<int> _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  bool filee = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
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

  Widget horizontalView(
    double height,
    double width,
    context,
  ) {
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
                            emailForm(),
                            const SizedBox(height: 20),
                            passwordForm(),
                            const SizedBox(height: 20),
                            confirmPasswordForm(),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(flex: 3, child: roleForm()),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 200,
                              child: DefaultButton(
                                color: Palette.primaryColor,
                                foreground: Colors.red,
                                text: 'USER IMAGE',
                                textcolor: Palette.primaryBackgroundColor,
                                onPressed: () async {
                                  result = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        "png",
                                        "jpg",
                                        "jpeg",
                                      ]);
                                  if (result != null) {
                                    file = result!.files.single;

                                    Uint8List fileBytes =
                                        result!.files.single.bytes as Uint8List;
                                    //print(base64Encode(fileBytes));
                                    //List<int>
                                    _selectedFile = fileBytes;
                                    setState(() {
                                      filee = true;
                                    });
                                  }
                                },
                              ),
                            ),
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
                                        creationUser(
                                          context,
                                          _selectedFile,
                                          result,
                                          _prenom,
                                          _nom,
                                          _email,
                                          _role,
                                          _password,
                                        );

                                        setState(() {
                                          _showContent = !_showContent;
                                        });
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
        child: Column(
          children: const [],
        ),
      ),
    );
  }

  DropdownButtonFormField<String> roleForm() {
    final viewModel = ref.watch(getDataRoleFuture);
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
      items: viewModel.listRole.map((val) {
        return DropdownMenuItem(
          value: val.value,
          child: Text(
            val.value!,
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
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var restaurantid = prefs.getString('idRestaurant');
    print(id);
    print(token);
    print("Restaurant id $restaurantid");

    var url = Uri.parse("http://192.168.11.110:4001/api/users/create");
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "restaurant": restaurantid!.trim(),
      "role": role,
      "password": password,
      "_creator": id,
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
          ref.refresh(getDataUserFuture);
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Utilisateur crée"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erreur de serveur"),
        ));
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
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
