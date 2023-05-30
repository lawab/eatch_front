import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/applayout.dart';
import '../../../utils/default_button/default_button.dart';
import '../../../utils/palettes/palette.dart';
import '../../../utils/size/size.dart';

class ModificationCategorie extends StatefulWidget {
  const ModificationCategorie({
    super.key,
    required this.nomCategorie,
  });

  final String nomCategorie;

  @override
  State<ModificationCategorie> createState() => _ModificationCategorieState();
}

class _ModificationCategorieState extends State<ModificationCategorie> {
  //**********************************/
  final _formKey = GlobalKey<FormState>();

  String _nomCategorie = "";

  ////////////////
  List<int>? _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  Uint8List? selectedImageInBytes;
  bool filee = false;

  bool isLoading = false;
  bool _selectFile = false;
  String? matiereImage;

  bool checkImagee = false;
  bool checkImage = false;
  bool _working = false;
  String message = "";

  void startWorking() async {
    setState(() {
      _working = true;
      checkImagee = false;
    });
  }

  void stopMessage() async {
    setState(() {
      checkImagee = true;
      checkImage = false;
    });
  }

  void finishWorking() async {
    setState(() {
      _working = false;
    });
  }

  ///

  @override
  void dispose() {
    super.dispose();
  }

  //**********************************/

  @override
  Widget build(BuildContext context) {
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
                      nomCategorie(),
                      const SizedBox(height: 20),

                      ////////////// - Image(début)
                      Container(
                        padding: EdgeInsets.only(right: 70),
                        color: Palette.secondaryBackgroundColor,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
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

                      const SizedBox(
                        height: 30,
                      ),

                      /// - Image (fin)

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
                                  print("nom is $_nomCategorie");
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

  TextFormField nomCategorie() {
    return TextFormField(
      initialValue: widget.nomCategorie,
      textInputAction: TextInputAction.next,
      autocorrect: true,
      textCapitalization: TextCapitalization.characters,
      enableSuggestions: false,
      onEditingComplete: (() => FocusScope.of(context).requestFocus()),
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
        hintText: "Titre Catégorie*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/user.svg"),
      ),
      onSaved: (value) {
        _nomCategorie = value!;
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
