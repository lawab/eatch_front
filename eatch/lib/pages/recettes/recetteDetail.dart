import 'dart:convert';
import 'dart:js_interop';

import 'package:eatch/pages/recettes/eddit_recette.dart';
import 'package:eatch/pages/recettes/recettes.dart';
import 'package:eatch/servicesAPI/get_recettes.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/default_button/default_button.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:eatch/utils/size/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecettePage extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final String image;
  final String sId;
  final List<Engredients> ingredients;
  const RecettePage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.sId,
    required this.ingredients,
  });

  @override
  ConsumerState<RecettePage> createState() => _RecettePageState();
}

class _RecettePageState extends ConsumerState<RecettePage> {
  @override
  void initState() {
    server();
    super.initState();
  }

  void server() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      url_recette = prefs.getString("url_recette")!;
    });
  }

  var url_recette = "";
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
                  const Text("INFORMATIONS SUR LA RECETTE"),
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
                              builder: (context) => const RecettesPage()),
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
                              'http://13.39.81.126:4010${widget.image}',
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
                                    // Text(
                                    //   NumberFormat.simpleCurrency(name: "MAD ")
                                    //       .format(widget.price),
                                    //   style: const TextStyle(
                                    //     fontSize: 15.0,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Palette.primaryColor,
                                    //   ),
                                    // ),
                                    // const SizedBox(height: 10),
                                    const Divider(
                                      thickness: 2,
                                      height: 5,
                                    ),
                                    const SizedBox(height: 10),
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
                  Column(
                    children: [
                      for (int i = 0; i < widget.ingredients.length; i++)
                        Card(
                          child: SizedBox(
                            height: 50,
                            child: Row(children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.ingredients[i].material.isNull
                                        ? widget.ingredients[i].rowMaterial!
                                            .grammage
                                            .toString()
                                        : widget
                                            .ingredients[i].material!.grammage
                                            .toString(),
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.ingredients[i].material.isNull
                                        ? widget
                                            .ingredients[i].rowMaterial!.unity
                                            .toString()
                                        : widget.ingredients[i].material!.unity
                                            .toString(),
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.ingredients[i].material.isNull
                                        ? widget
                                            .ingredients[i].rowMaterial!.title
                                            .toString()
                                        : widget.ingredients[i].material!.mpName
                                            .toString(),
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              )),
                            ]),
                          ),
                        ),
                    ],
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
                          text: 'SUPPRIMER',
                          textcolor: Palette.primaryBackgroundColor,
                          onPressed: () {
                            dialogDelete(
                              recetteTitle: widget.title,
                              recetteId: widget.sId,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 200,
                        child: DefaultButton(
                          color: Palette.secondaryBackgroundColor,
                          foreground: Colors.red,
                          text: 'MODIFIER',
                          textcolor: Palette.textsecondaryColor,
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EdditRecette(
                                          title: widget.title,
                                          image: widget.image,
                                          sId: widget.sId,
                                          ingredients: widget.ingredients,
                                          description: widget.description,
                                        )));
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
                  const Text("INFORMATIONS SUR LA RECETTE"),
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
                              builder: (context) => const RecettesPage()),
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
                              '$url_recette${widget.image}',
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
                  Column(
                    children: [
                      for (int i = 0; i < widget.ingredients.length; i++)
                        Card(
                          child: SizedBox(
                            height: 50,
                            child: Row(children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    i.toString(),
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    i.toString(),
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    i.toString(),
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              )),
                            ]),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200,
                        child: DefaultButton(
                          color: Palette.primaryColor,
                          foreground: Colors.red,
                          text: 'SUPPRIMER',
                          textcolor: Palette.primaryBackgroundColor,
                          onPressed: () {
                            dialogDelete(
                              recetteTitle: widget.title,
                              recetteId: widget.sId,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 200,
                        child: DefaultButton(
                          color: Palette.secondaryBackgroundColor,
                          foreground: Colors.red,
                          text: 'MODIFIER',
                          textcolor: Palette.textsecondaryColor,
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EdditRecette(
                                          title: widget.title,
                                          image: widget.image,
                                          sId: widget.sId,
                                          ingredients: widget.ingredients,
                                          description: widget.description,
                                        )));
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

  Future dialogDelete({
    required String recetteTitle,
    required String recetteId,
  }) {
    return showDialog(
        context: context,
        builder: (con) {
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
                    deleteRecette(context, recetteId);
                    Navigator.pop(con);
                  },
                  label: const Text("Supprimer."),
                )
              ],
              content: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  height: 150,
                  child: Text(
                    "Voulez vous supprimer le recette $recetteTitle ?",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  )));
        });
  }

  Future<http.Response> deleteRecette(BuildContext context, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userdelete = prefs.getString('IdUser').toString();
      var token = prefs.getString('token');
      String urlDelete = "$url_recette/api/recettes/delete/$id";
      var json = {
        '_creator': userdelete,
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
        ref.refresh(getDataRecettesFuture);

        return response;
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
