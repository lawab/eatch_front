import 'dart:convert';

import 'package:eatch/servicesAPI/multipart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../servicesAPI/get_user.dart';
import '../../../utils/applayout.dart';
import '../../../utils/default_button/default_button.dart';
import '../../../utils/palettes/palette.dart';
import '../../../utils/size/size.dart';

import 'package:http/http.dart' as http;

class ModificationUser extends ConsumerStatefulWidget {
  const ModificationUser({
    required this.sId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.avatar,
    super.key,
  });

  final String sId;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String avatar;

  @override
  ConsumerState<ModificationUser> createState() => _ModificationUserState();
}

class _ModificationUserState extends ConsumerState<ModificationUser> {
  // ***** LES VARIABLES ****** //
  bool _showContent = false;
  bool isLoading = false;
  bool _selectFile = false;

  Uint8List? selectedImageInBytes;
  FilePickerResult? result;

  List<int> _selectedFile = [];
  bool filee = false;
  PlatformFile? file;

  String? recetteImage;
  //**********************************/
  final _formKey = GlobalKey<FormState>();

  String _nom = "";
  String _prenom = "";
  final String _nomUtilisateur = "";
  String _email = "";
  String? _role;
  List<String> listOfRole = [
    "COMPTABLE",
    "RH",
    "MANAGER",
  ];

  final FocusNode _prenomFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _nomUtilisateurFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _prenomFocusNode.dispose();
    _nomUtilisateurFocusNode.dispose();
    super.dispose();
  }

  //**********************************/

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

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("MODIFIER LES INFORMTIONS"),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      nomForm(),
                      const SizedBox(height: 20),
                      prenomForm(),
                      const SizedBox(height: 20),
                      // nomUtilisateurForm(),
                      const SizedBox(height: 20),
                      emailForm(),
                      const SizedBox(height: 20),
                      roleForm(),
                      const SizedBox(height: 20),
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
                                          'http://192.168.11.110:4001${widget.avatar}',
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
                              color: Palette.primaryColor,
                              foreground: Colors.red,
                              text: 'ENREGISTRER',
                              textcolor: Palette.primaryBackgroundColor,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (_selectedFile.isEmpty) {}
                                  edditUser(
                                    context,
                                    _selectedFile,
                                    result,
                                    _prenom,
                                    _nom,
                                    _email,
                                    _role,
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
                                Navigator.pop(context);
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
      value: widget.role,
      hint: Text(
        widget.role,
        style: const TextStyle(color: Colors.black),
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

  TextFormField nomForm() {
    return TextFormField(
      initialValue: widget.firstName,
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
      initialValue: widget.lastName,
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

/*
  TextFormField nomUtilisateurForm() {
    return TextFormField(
      initialValue: widget.username,
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
*/
  TextFormField emailForm() {
    return TextFormField(
      initialValue: widget.email,
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

  Future<void> edditUser(
    BuildContext context,
    selectedFile,
    result,
    firstName,
    lastName,
    email,
    role,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var restaurantid = prefs.getString('idRestaurant');
    print(id);
    print(token);
    print("Restaurant id $restaurantid");

    var url =
        Uri.parse("http://192.168.11.110:4001/api/users/update/${widget.sId}");
    final request = MultipartRequest(
      'PUT',
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
      "_creator": id,
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
