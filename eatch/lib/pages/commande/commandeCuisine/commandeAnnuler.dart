import 'dart:convert';

import 'package:eatch/servicesAPI/multipart.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
//import 'package:http/http.dart' as http;
import '../../../servicesAPI/getCommandeCuisine.dart';

class CommandeAnnuler extends ConsumerStatefulWidget {
  const CommandeAnnuler({Key? key}) : super(key: key);

  @override
  CommandeAnnulerState createState() => CommandeAnnulerState();
}

class CommandeAnnulerState extends ConsumerState<CommandeAnnuler> {
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

  bool traitement = false;
  bool waited = false;
  bool filtre = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataCommandeCuisineFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listCommandeAnnuler);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listCommandeAnnuler);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, context,
      List<CommandeCuisine> listCommande) {
    return Scaffold(
      body: Container(
        color: Palette.yellowColor,
        height: height,
        width: width,
        child: listCommande.isEmpty
            ? const Center(
                child: Text(
                  'Pas de commande annulée',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: listCommande.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    child: Container(
                      height: 200,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 200,
                            width: 40,
                            color: Colors.white,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 200,
                            width: 50,
                            color: Colors.black,
                            child: Text(
                              'N° ${listCommande[index].numOrder}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                Text(
                                  '${listCommande[index].products!.length} produits à ${listCommande[index].totaleCost} Dh',
                                  style: const TextStyle(
                                      fontFamily: 'Righteous',
                                      fontSize: 15,
                                      color: Palette.yellowColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                Container(
                                  height: 150,
                                  child: ListView.builder(
                                      itemExtent: 70,
                                      itemCount:
                                          listCommande[index].products!.length,
                                      itemBuilder: (context, indexx) {
                                        return Container(
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${indexx + 1} - ${listCommande[index].products![indexx].productName!} x ${listCommande[index].products![indexx].orderQte == 0 ? 1 : listCommande[index].products![indexx].orderQte}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              listCommande[index]
                                                          .products![indexx]
                                                          .recette!
                                                          .description !=
                                                      null
                                                  ? Text(listCommande[index]
                                                      .products![indexx]
                                                      .recette!
                                                      .description!)
                                                  : Text('Rien')
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 100,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber),
                                      onPressed: () {
                                        modificationCommande(
                                            context,
                                            'TREATMENT',
                                            listCommande[index].sId!);
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.watch),
                                          Text(
                                            'Traitement',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber),
                                      onPressed: () {
                                        modificationCommande(context, 'WAITED',
                                            listCommande[index].sId!);
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.watch_later),
                                          Text(
                                            'En attente',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      onPressed: () {
                                        modificationCommande(context, 'DONE',
                                            listCommande[index].sId!);
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.done),
                                          Text(
                                            'Terminer',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          /*minimumSize: Size(90, 100),
                                        maximumSize: Size(90, 100),*/
                                          backgroundColor: Colors.green),
                                      onPressed: () {
                                        modificationCommande(context, 'PAID',
                                            listCommande[index].sId!);
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.money),
                                          Text(
                                            'Payer',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }

  Widget verticalView(double height, double width, context,
      List<CommandeCuisine> listCommande) {
    return Scaffold(
      body: Container(
        color: Palette.yellowColor,
        height: height,
        width: width,
        child: listCommande.isEmpty
            ? const Center(
                child: Text(
                  'Pas de commande annulée',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: listCommande.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    child: Container(
                      height: 200,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 200,
                            width: 40,
                            color: Colors.white,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 200,
                            width: 50,
                            color: Colors.black,
                            child: Text(
                              'N° ${listCommande[index].numOrder}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                Text(
                                  '${listCommande[index].products!.length} produits à ${listCommande[index].totaleCost} Dh',
                                  style: const TextStyle(
                                      fontFamily: 'Righteous',
                                      fontSize: 15,
                                      color: Palette.yellowColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                Container(
                                  height: 150,
                                  child: ListView.builder(
                                      itemExtent: 70,
                                      itemCount:
                                          listCommande[index].products!.length,
                                      itemBuilder: (context, indexx) {
                                        return Container(
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${indexx + 1} - ${listCommande[index].products![indexx].productName!} x ${listCommande[index].products![indexx].orderQte == 0 ? 1 : listCommande[index].products![indexx].orderQte}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              listCommande[index]
                                                          .products![indexx]
                                                          .recette!
                                                          .description !=
                                                      null
                                                  ? Text(listCommande[index]
                                                      .products![indexx]
                                                      .recette!
                                                      .description!)
                                                  : Text('Rien')
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 100,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber),
                                      onPressed: () {
                                        modificationCommande(
                                            context,
                                            'TREATMENT',
                                            listCommande[index].sId!);
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.watch),
                                          Text(
                                            'Traitement',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber),
                                      onPressed: () {
                                        modificationCommande(context, 'WAITED',
                                            listCommande[index].sId!);
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.watch_later),
                                          Text(
                                            'En attente',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      onPressed: () {
                                        modificationCommande(context, 'DONE',
                                            listCommande[index].sId!);
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.done),
                                          Text(
                                            'Terminer',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          /*minimumSize: Size(90, 100),
                                        maximumSize: Size(90, 100),*/
                                          backgroundColor: Colors.green),
                                      onPressed: () {
                                        modificationCommande(context, 'PAID',
                                            listCommande[index].sId!);
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.money),
                                          Text(
                                            'Payer',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }

  Future<void> modificationCommande(
    BuildContext context,
    String status,
    String idCommande,
  ) async {
    ////////////

    var url =
        Uri.parse("http://13.39.81.126:4004/api/orders/update/$idCommande");
    final request = MultipartRequest(
      'PUT',
      url,
      // ignore: avoid_returning_null_for_void
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      'status': status,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    print("RESPENSE SEND STEAM FILE REQ");
    //var responseString = await streamedResponse.stream.bytesToString();
    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);

    print("Je me situe maintenant ici");
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });

        ref.refresh(getDataCommandeCuisineFuture);

        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.info(
            backgroundColor: Palette.greenColors,
            message: "La Commande est à un status : $status",
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.deleteColors,
            message: "Erreur status de commande ",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
