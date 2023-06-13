import 'dart:convert';

import 'package:eatch/servicesAPI/getLabo.dart';
import 'package:eatch/servicesAPI/multipart.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SortieMatiere extends ConsumerStatefulWidget {
  const SortieMatiere({Key? key}) : super(key: key);

  @override
  SortieMatiereState createState() => SortieMatiereState();
}

class SortieMatiereState extends ConsumerState<SortieMatiere> {
  var demandeController = TextEditingController();
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

  var nombrecontrol = TextEditingController(text: '10');

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataLaboratoriesFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listRequest);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  int count = 0;
  Widget horizontalView(double height, double width, contextt,
      List<RequestMaterials> listRequest) {
    return AppLayout(
        content: Container(
      height: height,
      width: width,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            height: 80,
            color: Palette.yellowColor, //Color(0xFFFCEBD1),
            child: Row(
              children: [
                const SizedBox(
                  width: 50,
                ),
                const Text('Sortie de Matière finie'),
                Expanded(child: Container()),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(180, 50)),
                  onPressed: () {
                    Navigator.pop(context);
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
          const SizedBox(
            height: 40,
          ),
          Container(
            height: height - 180,
            child: ListView.builder(
                itemCount: listRequest.length,
                itemBuilder: (context, index) {
                  var dateA = '';
                  if (listRequest[index].dateValidated.toString() == 'null') {
                    dateA = 'null';
                  } else {
                    DateTime a = DateTime.parse(
                        listRequest[index].dateValidated.toString());
                    final DateFormat formattera =
                        DateFormat('dd.MM.yyyy  hh:mm');
                    dateA = formattera.format(a);
                  }

                  DateTime b = DateTime.parse(
                      listRequest[index].dateProviding.toString() == ''
                          ? '2023-01-01'
                          : listRequest[index].dateProviding.toString()); //
                  final DateFormat formatterb = DateFormat('dd.MM.yyyy  hh:mm');
                  var datep = formatterb.format(b);
                  return Card(
                    elevation: 10,
                    child: InkWell(
                      child: Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  listRequest[index].material!.title!,
                                  style: const TextStyle(
                                      fontFamily: 'Allerta',
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.black,
                              width: 10,
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(
                                          text: "Date de demande: ",
                                          style: TextStyle(
                                              fontFamily: 'Allerta',
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: '$datep PM',
                                          style: const TextStyle(
                                              fontFamily: 'Allerta',
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ]),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(
                                          text: "Date d'acceptation: ",
                                          style: TextStyle(
                                              fontFamily: 'Allerta',
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: dateA == 'null'
                                              ? 'En attente'
                                              : '$dateA PM',
                                          style: const TextStyle(
                                              fontFamily: 'Allerta',
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ]),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        const TextSpan(
                                          text: "Quantité demandée: ",
                                          style: TextStyle(
                                              fontFamily: 'Allerta',
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              '${listRequest[index].qte.toString()} ${listRequest[index].material!.unit.toString()}',
                                          style: const TextStyle(
                                              fontFamily: 'Allerta',
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.black,
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  const Text('STATUS : '),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  listRequest[index].dateValidated == null &&
                                          listRequest[index].validated == false
                                      ? const CircleAvatar(
                                          maxRadius: 20,
                                          backgroundColor: Colors.amber,
                                          child: Icon(
                                            Icons.watch,
                                            color: Colors.white,
                                          ),
                                        )
                                      : listRequest[index].validated == false
                                          ? const CircleAvatar(
                                              maxRadius: 20,
                                              backgroundColor: Colors.red,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const CircleAvatar(
                                              maxRadius: 20,
                                              backgroundColor: Colors.green,
                                              child: Icon(
                                                Icons.done,
                                                color: Colors.white,
                                              ),
                                            ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 100,
                            ),
                            CircleAvatar(
                              maxRadius: 20,
                              backgroundColor: Colors.black,
                              child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  reponseMatiere(
                                      context,
                                      listRequest[index].requestId!,
                                      'refused',
                                      listRequest[index].restaurant!.sId!,
                                      listRequest[index].material!.sId!,
                                      listRequest[index].material!.quantity);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              maxRadius: 20,
                              backgroundColor: Colors.black,
                              child: IconButton(
                                icon: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  reponseMatiere(
                                      context,
                                      listRequest[index].requestId!,
                                      'accepted',
                                      listRequest[index].restaurant!.sId!,
                                      listRequest[index].material!.sId!,
                                      listRequest[index].material!.quantity);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        //dialogSortie(context);
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
    ));
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(content: Container());
  }

  Future dialogSortie(BuildContext contextt) {
    //print('dedans');
    demandeController.text = 100.toString();
    return showDialog(
      context: contextt,
      builder: (co) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "DEMANDE",
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
                label: const Text("Refuser   ")),
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
                onPressed: () {},
                label: const Text("Accepter."))
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
                    'Type : Matière finie',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text('Stock Initial : 500'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Stock possible : 200'),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 250,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Stock demandé : '),
                        ),
                        Expanded(
                          child: SizedBox(
                            //width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
                              controller: demandeController,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                  hoverColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 42, vertical: 20),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Palette.yellowColor),
                                    gapPadding: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Palette.yellowColor),
                                    gapPadding: 10,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Palette.yellowColor),
                                    gapPadding: 10,
                                  ),
                                  labelText: "Quantite",
                                  hintText: "Inscrire le titre",
                                  // If  you are using latest version of flutter then lable text and hint text shown like this
                                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  suffixIcon: const Icon(Icons.title)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> reponseMatiere(BuildContext context, String requestId,
      String choice, String restaurantId, String materialId, qte) async {
    ////////////
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    //var restaurantId = prefs.getString('idRestaurant').toString();
    var laboId = prefs.getString('idLabo').toString();
    var token = prefs.getString('token');

    //String adressUrl = prefs.getString('ipport').toString();

    var url = Uri.parse(
        "http://192.168.1.105:4015/api/laboratories/validateRequesting"); //$adressUrl
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
      'choice': choice,
      'requestId': requestId,
      'materialId': materialId,
      'qte': qte,
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
          CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: choice == 'accepted'
                ? "Demande acceptée avec succès"
                : "Demande réfusée avec succès",
          ),
        );
        ref.refresh(getDataLaboratoriesFuture);
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
