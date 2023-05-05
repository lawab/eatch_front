import 'package:eatch/servicesAPI/get_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/default_button/default_button.dart';
import '../../../utils/palettes/palette.dart';
import '../../../utils/size/size.dart';

class CreationProduit extends ConsumerStatefulWidget {
  const CreationProduit({
    super.key,
    required this.categorieTitle,
    required this.categorieId,
  });

  final String categorieId;
  final String categorieTitle;
  @override
  CreationProduitState createState() => CreationProduitState();
}

class CreationProduitState extends ConsumerState<CreationProduit> {
  //**********************************/
  final _formKey = GlobalKey<FormState>();

  String _produitTitle = "";
  String _produitPrice = "";
  String? _produitCategorie;

  final FocusNode _produitPriceFocusNode = FocusNode();

  @override
  void dispose() {
    _produitPriceFocusNode.dispose();
    super.dispose();
  }

  //**********************************/

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final viewModel = ref.watch(getDataCategoriesFuture);
    return Scaffold(
      backgroundColor: Palette.secondaryBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 35, left: 15),
              child: RawMaterialButton(
                fillColor: Palette.primaryColor,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                padding: const EdgeInsets.all(0),
                shape: const CircleBorder(),
                child: const Icon(IconData(0xe16a, fontFamily: 'MaterialIcons'),
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(100),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      color: Palette.secondaryBackgroundColor,
                      child: produitcategorieForm(),
                    ),
                    const SizedBox(height: 20),
                    produittitleForm(),
                    const SizedBox(height: 20),
                    produitpriceForm(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 150,
                          child: DefaultButton(
                            color: Palette.primaryColor,
                            foreground: Colors.red,
                            text: 'ENREGISTRER',
                            textcolor: Palette.primaryBackgroundColor,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                print("nom is $_produitTitle");
                                print("prix is $_produitPrice");
                                print("prix is $_produitCategorie");
                              } else {
                                print("Bad");
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 150,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField produittitleForm() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      autocorrect: true,
      textCapitalization: TextCapitalization.characters,
      enableSuggestions: false,
      onEditingComplete: (() =>
          FocusScope.of(context).requestFocus(_produitPriceFocusNode)),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "S'il vous plaît entrez le nom du produit .";
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
        hintText: "Nom du produit*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            const CustomSurffixIcon(svgIcon: "assets/icons/cauldron.svg"),
      ),
      onSaved: (value) {
        _produitTitle = value!;
      },
    );
  }

  TextFormField produitpriceForm() {
    return TextFormField(
      focusNode: _produitPriceFocusNode,
      textInputAction: TextInputAction.next,
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
      enableSuggestions: false,
      onEditingComplete: (() => FocusScope.of(context).requestFocus()),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return "S'il vous plaît entrez le prix du produit.";
        }
        return null;
      },
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
        //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
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
        hintText: "Prix du produit*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/coins.svg"),
      ),
      onSaved: (value) {
        _produitPrice = value!;
      },
    );
  }

  DropdownButtonFormField<String> produitcategorieForm() {
    final viewModel = ref.watch(getDataCategoriesFuture);
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
      value: widget.categorieTitle,
      hint: Text(
        widget.categorieTitle,
        style: const TextStyle(color: Colors.black),
      ),
      isExpanded: true,
      onChanged: (value) {
        setState(() {
          _produitCategorie = value;
        });
      },
      onSaved: (value) {
        setState(() {
          _produitCategorie = value;
        });
      },
      validator: (String? value) {
        if (value == null) {
          return "La catégorie est obligatoire.";
        } else {
          return null;
        }
      },
      items: viewModel.listCategories.map((val) {
        return DropdownMenuItem(
          value: val.title,
          child: Text(
            val.title!,
          ),
        );
      }).toList(),
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