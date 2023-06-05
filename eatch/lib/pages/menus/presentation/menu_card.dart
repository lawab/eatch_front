// import 'package:eatch/pages/menus/infrastructure/menus_repository.dart';
import 'package:eatch/pages/menus/presentation/modification_menu.dart';
import 'package:eatch/servicesAPI/getMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../utils/palettes/palette.dart';
import 'package:http/http.dart' as http;

class MenuCard extends ConsumerStatefulWidget {
  const MenuCard(
      {Key? key,
      required this.imageUrl,
      required this.sId,
      required this.title,
      required this.description,
      required this.price,
      required this.index})
      : super(key: key);
  final String imageUrl;
  final String sId;
  final String title;
  final String description;
  final double price;

  final int index;

  @override
  ConsumerState<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends ConsumerState<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Palette.primaryBackgroundColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            alignment: Alignment.center,
            height: 153,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Palette.textPrimaryColor,
                        ),
                      ),
                      Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 08.0,
                          color: Palette.textsecondaryColor,
                        ),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(name: "MAD ")
                            .format(widget.price),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 08,
                          fontWeight: FontWeight.bold,
                          color: Palette.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 05.0),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    child: Image.network(
                      "http://192.168.11.110:4009${widget.imageUrl}",
                    ),
                  ),
                ),
              ],
            ),
          ),
          /////////
          const SizedBox(height: 1),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModificationMenu(
                          description: widget.description,
                          imageUrl: widget.imageUrl,
                          price: widget.price,
                          sId: widget.sId,
                          title: widget.title,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Palette.secondaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text("Modifier"),
                  ),
                ),
              ),
              const SizedBox(height: 0.5),
              Expanded(
                child: InkWell(
                  onTap: () {
                    dialogDelete(widget.title, widget.sId);
                  },
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Palette.deleteColors,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text("Supprimer"),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  ////////////////////////////////////
  Future dialogDelete(String nom, String idMenus) {
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
                fontFamily: 'HelveticaNeue',
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
                  Navigator.of(con, rootNavigator: true).pop();
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
                  deleteMenu(context, idMenus);
                  Navigator.of(con, rootNavigator: true).pop();
                },
                label: const Text("Supprimer."))
          ],
          content: Container(
            alignment: Alignment.center,
            color: Colors.white,
            height: 150,
            child: Text(
              "Voulez vous supprimer $nom ?",
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'HelveticaNeue',
              ),
            ),
          ),
        );
      },
    );
  }

  ////////// - Suppression de Menu
  ///
  Future<http.Response> deleteMenu(BuildContext context, String idMenu) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getString('IdUser').toString();

      //String adressUrl = prefs.getString('ipport').toString();

      var token = prefs.getString('token');
      String urlDelete =
          "http://192.168.11.110:4009/api/menus/delete/$idMenu"; // 192.168.11.110:4008 //$adressUrl
      //var json = {'_creator': id};

      //var body = jsonEncode(json);

      final http.Response response =
          await http.delete(Uri.parse(urlDelete), headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Accept': 'application/json',
        'authorization': 'Bearer $token',
      }, body: {
        '_creator': id
      });

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        showTopSnackBar(
          Overlay.of(context)!,
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Le menu a été supprimée avec succès",
          ),
        );
        ref.refresh(getDataMenuFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(context)!,
          const CustomSnackBar.info(
            backgroundColor: Palette.deleteColors,
            message: "Le menu n'a pas été supprimée succès",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}





/*

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      color: const Color.fromARGB(255, 22, 21, 21),
      child: InkWell(
        onTap: () {
          print('object ${widget.index}');
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Palette.primaryBackgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          alignment: Alignment.center,
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Palette.textPrimaryColor,
                      ),
                    ),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 08.0,
                        color: Palette.textsecondaryColor,
                      ),
                    ),
                    Text(
                      NumberFormat.simpleCurrency(name: "MAD ")
                          .format(widget.price),
                      style: const TextStyle(
                        fontSize: 08,
                        fontWeight: FontWeight.bold,
                        color: Palette.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 05.0),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  child: Image.network(
                    "http://192.168.11.110:4009${widget.imageUrl}",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/