import 'dart:convert';
import 'package:eatch/servicesAPI/getLabo.dart';
import 'package:eatch/servicesAPI/getRestaurant.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../servicesAPI/multipart.dart';
//import 'package:http/http.dart' as http;
//import 'package:http_parser/http_parser.dart' show MediaType;

class MatiereLaboAffiche extends ConsumerStatefulWidget {
  const MatiereLaboAffiche({Key? key}) : super(key: key);

  @override
  MatiereLaboAfficheState createState() => MatiereLaboAfficheState();
}

class MatiereLaboAfficheState extends ConsumerState<MatiereLaboAffiche> {
  int count = 1;
  var nombrecontrol = TextEditingController();
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
    final viewModel = ref.watch(getDataLaboratoriesFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(
                height(context), width(context), context, viewModel.listFINI);
          } else {
            return verticalView(
                height(context), width(context), context, viewModel.listFINI);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, context, List<Materials> matiere) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            /*Container(
              alignment: Alignment.centerRight,
              height: 80,
              color: Palette.yellowColor,
              child: Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  const Text('Matières premières du laboratoire'),
                  Expanded(child: Container()),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(180, 50),
                    ),
                    onPressed: () {
                      /*setState(() {
                        ajout = true;
                      });*/
                      /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantCreation()));*/
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un type de matière'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),*/
            Container(
              height: height - 280,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 50,
                      mainAxisExtent: 400),
                  itemCount: matiere.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 198,
                              width: 300,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('emballage.jpeg'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Text('Nom : ${matiere[index].title}'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                'Quantité : ${matiere[index].quantity} ${matiere[index].unit}'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Dernière date : ${matiere[index].updatedAt}'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                'Date de création : ${matiere[index].createdAt}'),
                            Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                          splashColor: Palette.greenColors,
                                          onPressed: () {
                                            dialogAjout(
                                                context,
                                                matiere[index].quantity!,
                                                matiere[index].title!,
                                                matiere[index].unit!,
                                                matiere[index].sId!,
                                                'idLabo');
                                          },
                                          iconSize: 30,
                                          icon: const Icon(
                                            Icons.add_box,
                                            color: Palette.greenColors,
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(
      double height, double width, context, List<Materials> matiere) {
    return AppLayout(
      content: Container(),
    );
  }

  Future dialogAjout(BuildContext contextt, int quantite, String titre,
      String unit, String idMaterials, String idLabo) {
    nombrecontrol.text = 1.toString();
    return showDialog(
      context: contextt,
      builder: (co) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Demande d'Aprovisionnement",
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
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Quitter   ")),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.check,
                size: 14,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.greenColors),
              onPressed: () {
                demandeMatiere(contextt, nombrecontrol.text, unit, idMaterials);
                Navigator.pop(co);
              },
              label: const Text("Valider."),
            ),
          ],
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 170,
              child: Column(
                children: [
                  Text(
                    'Type : $titre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text('Stock Initial : $quantite $unit'),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Palette.greenColors),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                if (count > 1) {
                                  count = int.parse(nombrecontrol.text);
                                  count--;
                                  nombrecontrol.text = count.toString();
                                }
                              });
                            },
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 16,
                            )),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              width: 30,
                              child: TextFormField(
                                controller: nombrecontrol,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                count = int.parse(nombrecontrol.text);
                                count++;
                                nombrecontrol.text = count.toString();
                              });
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> demandeMatiere(
    BuildContext context,
    String quantite,
    String unit,
    String idMaterials,
  ) async {
    ////////////
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var restaurantId = prefs.getString('idRestaurant').toString();
    var laboId = prefs.getString('idLabo').toString();
    var token = prefs.getString('token');

    //String adressUrl = prefs.getString('ipport').toString();

    var url = Uri.parse(
        "http://192.168.1.105:4002/api/restaurants/requestMaterial"); //$adressUrl
    final request = MultipartRequest(
      'PATCH',
      url,
      // ignore: avoid_returning_null_for_void
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
//'unit': unit,
    var json = {
      'restaurantId': restaurantId,
      'laboratoryId': laboId,
      'qte': quantite,
      'materialId': idMaterials,
      '_creator': id,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    // request.files.add(await http.MultipartFile.fromBytes('file', selectedFile,
    //     contentType: MediaType('application', 'octet-stream'),
    //     filename: result?.files.first.name));

    print("RESPENSE SEND STEAM FILE REQ");
    //var responseString = await streamedResponse.stream.bytesToString();
    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Demande effectuée en attente de validation",
          ),
        );

        ref.refresh(getDataRsetaurantFuture);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "Echec de la demande",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
