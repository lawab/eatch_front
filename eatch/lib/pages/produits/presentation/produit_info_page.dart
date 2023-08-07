import 'dart:convert';

import 'package:eatch/pages/categories/presentation/categories.dart';
import 'package:eatch/pages/produits/presentation/modification_produit.dart';
import 'package:eatch/servicesAPI/getProduit.dart';
import 'package:eatch/servicesAPI/get_categories.dart' as get_categories;
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/default_button/default_button.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:eatch/utils/size/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Produitpage extends ConsumerStatefulWidget {
  const Produitpage({
    super.key,
    required this.title,
    required this.price,
    required this.quantity,
    required this.sId,
    required this.imageUrl,
    required this.recette,
    required this.category,
  });
  final String title;
  final get_categories.Recette recette;
  final get_categories.Category category;
  final String imageUrl;
  final String sId;
  final int price;
  final int quantity;

  @override
  ConsumerState<Produitpage> createState() => _ProduitpageState();
}

class _ProduitpageState extends ConsumerState<Produitpage> {
  @override
  void initState() {
    server();
    super.initState();
  }

  void server() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      url_produit = prefs.getString("url_produit")!;
    });
  }

  var url_produit = "";
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
    return AppLayout(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 50,
              color: Palette.yellowColor,
              child: Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  const Text("INFORMATIONS SUR LE PRODUIT"),
                  Expanded(child: Container()),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(100, 50)),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const CategoriesPage()),
                          (Route<dynamic> route) => false);
                    },
                    icon: const Icon(Icons.backspace),
                    label: const Text('Retour'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(50),
                vertical: getProportionateScreenHeight(50),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 7,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(100),
                            child: Image.network(
                              'http://13.39.81.126:4003${widget.imageUrl}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Column(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.textPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      NumberFormat.simpleCurrency(name: "MAD ")
                                          .format(widget.price),
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(
                                      thickness: 2,
                                      height: 5,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.category.title!,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.textPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.recette.title!,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(
                                      thickness: 2,
                                      height: 5,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.quantity.toString(),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.textPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200,
                        child: DefaultButton(
                          color: Colors.red,
                          foreground: Colors.red,
                          text: 'SUPPRIMER',
                          textcolor: Palette.primaryBackgroundColor,
                          onPressed: () {
                            dialogDelete(
                              context,
                              widget.title,
                              widget.sId,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 200,
                        child: DefaultButton(
                          color: Palette.greenColors,
                          foreground: Colors.red,
                          text: 'MODIFIER',
                          textcolor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ModificationProduit(
                                  imageUrl: widget.imageUrl,
                                  price: widget.price,
                                  title: widget.title,
                                  category: widget.category.sId!,
                                  quantity: widget.quantity,
                                  recette: widget.recette.sId!,
                                  sId: widget.sId,
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 50,
              color: Palette.yellowColor,
              child: Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  const Text("INFORMATIONS SUR LE PRODUIT"),
                  Expanded(child: Container()),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(100, 50)),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const CategoriesPage()),
                          (Route<dynamic> route) => false);
                    },
                    icon: const Icon(Icons.backspace),
                    label: const Text('Retour'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(50),
                vertical: getProportionateScreenHeight(50),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 7,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(100),
                            child: Image.network(
                              '$url_produit${widget.imageUrl}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Column(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.textPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      NumberFormat.simpleCurrency(name: "MAD ")
                                          .format(widget.price),
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(
                                      thickness: 2,
                                      height: 5,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.category.title!,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.textPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.recette.title!,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(
                                      thickness: 2,
                                      height: 5,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.quantity.toString(),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Palette.textPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200,
                        child: DefaultButton(
                          color: Colors.red,
                          foreground: Colors.red,
                          text: 'SUPPRIMER',
                          textcolor: Palette.primaryBackgroundColor,
                          onPressed: () {
                            dialogDelete(
                              context,
                              widget.title,
                              widget.sId,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 200,
                        child: DefaultButton(
                          color: Palette.greenColors,
                          foreground: Colors.red,
                          text: 'MODIFIER',
                          textcolor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ModificationProduit(
                                  imageUrl: widget.imageUrl,
                                  price: widget.price,
                                  title: widget.title,
                                  category: widget.category.sId!,
                                  quantity: widget.quantity,
                                  recette: widget.recette.sId!,
                                  sId: widget.sId,
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future dialogDelete(BuildContext context, String productName, productId) {
    return showDialog(
      context: context,
      builder: (_) {
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
                  Navigator.of(context, rootNavigator: true).pop();
                  deleteProduct(context, productId);
                },
                label: const Text("Supprimer."),
              )
            ],
            content: Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: 150,
                child: Text(
                  "Voulez vous supprimer le produit $productName ?",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                )));
      },
    );
  }

  Future<http.Response> deleteProduct(BuildContext context, String id) async {
    try {
      print(
          '*********************************************************************sup');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userdelete = prefs.getString('IdUser').toString();
      var restaurantId = prefs.getString('idRestaurant').toString();
      var token = prefs.getString('token');
      String urlDelete = "http://13.39.81.126:4003/api/products/delete/$id";
      var json = {
        '_creator': userdelete,
        'restaurant': restaurantId,
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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const CategoriesPage()),
            (Route<dynamic> route) => false);

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Produit supprimé avec succès.",
          ),
        );
        setState(() {
          ref.refresh(get_categories.getDataCategoriesFuture);
          ref.refresh(GetDataProduitFuture as Refreshable);
        });
        return response;
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
