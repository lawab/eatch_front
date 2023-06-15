import 'dart:async';
import 'dart:convert';

import 'package:eatch/servicesAPI/getLabo.dart';
import 'package:eatch/servicesAPI/getMatiereFini.dart';
import 'package:eatch/servicesAPI/getRestaurant.dart';
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
  @override
  void initState() {
    startTimer();
    // TODO: implement initState
    super.initState();
  }

  Timer? _timer;
  int _start = 120;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            ref.refresh(getDataLaboratoriesFuture);
            print('refresh********************************************');
            _start = 120;
            startTimer();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

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
            return verticalView(height(context), width(context), context,
                viewModel.listRequest);
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
                    final DateFormat formatterb =
                        DateFormat('dd.MM.yyyy  hh:mm');
                    var datep = formatterb.format(b);
                    return Card(
                      elevation: 10,
                      child: InkWell(
                        child: Container(
                          height: 110,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(children: [
                                          const TextSpan(
                                            text: "Restaurant: ",
                                            style: TextStyle(
                                                fontFamily: 'Allerta',
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: listRequest[index]
                                                .restaurant!
                                                .restaurantName!,
                                            style: const TextStyle(
                                                fontFamily: 'Allerta',
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          )
                                        ]),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
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
                                        height: 5,
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
                                        height: 5,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: 120,
                                        child: Row(
                                          children: [
                                            const Text(
                                              'STATUS : ',
                                              style: TextStyle(
                                                  fontFamily: 'Allerta',
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            listRequest[index].dateValidated ==
                                                        null &&
                                                    listRequest[index]
                                                            .validated ==
                                                        false
                                                ? const CircleAvatar(
                                                    maxRadius: 15,
                                                    backgroundColor:
                                                        Colors.amber,
                                                    child: Icon(
                                                      Icons.watch,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : listRequest[index]
                                                            .validated ==
                                                        false
                                                    ? const CircleAvatar(
                                                        maxRadius: 15,
                                                        backgroundColor:
                                                            Colors.red,
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : const CircleAvatar(
                                                        maxRadius: 15,
                                                        backgroundColor:
                                                            Colors.green,
                                                        child: Icon(
                                                          Icons.done,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                          ],
                                        ),
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
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      maxRadius: 20,
                                      backgroundColor: Colors.black,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          if (listRequest[index].validated ==
                                              false) {
                                            reponseMatiere(
                                                context,
                                                listRequest[index].requestId!,
                                                'refused',
                                                listRequest[index]
                                                    .restaurant!
                                                    .sId!,
                                                listRequest[index]
                                                    .material!
                                                    .sId!,
                                                listRequest[index]
                                                    .qte
                                                    .toString());
                                          } else {
                                            dialogRefus2(context);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
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
                                          if (listRequest[index]
                                                  .material!
                                                  .quantity! >
                                              listRequest[index].qte!) {
                                            reponseMatiere(
                                                context,
                                                listRequest[index].requestId!,
                                                'accepted',
                                                listRequest[index]
                                                    .restaurant!
                                                    .sId!,
                                                listRequest[index]
                                                    .material!
                                                    .sId!,
                                                listRequest[index]
                                                    .qte
                                                    .toString());
                                          } else {
                                            dialogRefus(
                                                context,
                                                listRequest[index]
                                                    .material!
                                                    .title!,
                                                listRequest[index]
                                                    .material!
                                                    .quantity!,
                                                listRequest[index].qte!,
                                                listRequest[index]
                                                    .material!
                                                    .unit!);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
      ),
    );
  }

  Widget verticalView(double height, double width, contextt,
      List<RequestMaterials> listRequest) {
    return AppLayout(
      content: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 50,
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
              height: 20,
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
                    final DateFormat formatterb =
                        DateFormat('dd.MM.yyyy  hh:mm');
                    var datep = formatterb.format(b);
                    return Card(
                      elevation: 10,
                      child: InkWell(
                        child: Container(
                          height: 110,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(children: [
                                          const TextSpan(
                                            text: "Restaurant: ",
                                            style: TextStyle(
                                                fontFamily: 'Allerta',
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: listRequest[index]
                                                .restaurant!
                                                .restaurantName!,
                                            style: const TextStyle(
                                                fontFamily: 'Allerta',
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          )
                                        ]),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
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
                                        height: 5,
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
                                        height: 5,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: 120,
                                        child: Row(
                                          children: [
                                            const Text(
                                              'STATUS : ',
                                              style: TextStyle(
                                                  fontFamily: 'Allerta',
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            listRequest[index].dateValidated ==
                                                        null &&
                                                    listRequest[index]
                                                            .validated ==
                                                        false
                                                ? const CircleAvatar(
                                                    maxRadius: 15,
                                                    backgroundColor:
                                                        Colors.amber,
                                                    child: Icon(
                                                      Icons.watch,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : listRequest[index]
                                                            .validated ==
                                                        false
                                                    ? const CircleAvatar(
                                                        maxRadius: 15,
                                                        backgroundColor:
                                                            Colors.red,
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : const CircleAvatar(
                                                        maxRadius: 15,
                                                        backgroundColor:
                                                            Colors.green,
                                                        child: Icon(
                                                          Icons.done,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                          ],
                                        ),
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
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      maxRadius: 20,
                                      backgroundColor: Colors.black,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          if (listRequest[index].validated ==
                                              false) {
                                            reponseMatiere(
                                                context,
                                                listRequest[index].requestId!,
                                                'refused',
                                                listRequest[index]
                                                    .restaurant!
                                                    .sId!,
                                                listRequest[index]
                                                    .material!
                                                    .sId!,
                                                listRequest[index]
                                                    .qte
                                                    .toString());
                                          } else {
                                            dialogRefus2(context);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
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
                                          if (listRequest[index]
                                                  .material!
                                                  .quantity! >
                                              listRequest[index].qte!) {
                                            reponseMatiere(
                                                context,
                                                listRequest[index].requestId!,
                                                'accepted',
                                                listRequest[index]
                                                    .restaurant!
                                                    .sId!,
                                                listRequest[index]
                                                    .material!
                                                    .sId!,
                                                listRequest[index]
                                                    .qte
                                                    .toString());
                                          } else {
                                            dialogRefus(
                                                context,
                                                listRequest[index]
                                                    .material!
                                                    .title!,
                                                listRequest[index]
                                                    .material!
                                                    .quantity!,
                                                listRequest[index].qte!,
                                                listRequest[index]
                                                    .material!
                                                    .unit!);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
      ),
    );
  }

  Future dialogRefus(
      BuildContext contextt, String nom, int quantite, int qte, String unit) {
    //print('dedans');
    demandeController.text = 100.toString();
    return showDialog(
      context: contextt,
      builder: (co) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Impossible",
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
                  Icons.check,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.greenColors),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Compris."))
          ],
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 70,
              child: RichText(
                text: TextSpan(children: [
                  const TextSpan(
                    text: "Votre stock de ",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                  TextSpan(
                    text: nom,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text:
                        ' est faible par rapport à la demande. Vous acceptez une demande de ',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                  TextSpan(
                    text: '$qte $unit',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: ', alors que le stock disponible est de',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                  TextSpan(
                    text: '$quantite $unit.',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            );
          }),
        );
      },
    );
  }

  Future dialogRefus2(BuildContext contextt) {
    //print('dedans');
    demandeController.text = 100.toString();
    return showDialog(
      context: contextt,
      builder: (co) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Impossible",
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
                  Icons.check,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.greenColors),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Compris."))
          ],
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: 70,
                child: Text(
                    'Cette requette est impossible, vous avez déja valider cette demande'));
          }),
        );
      },
    );
  }

  Future<void> reponseMatiere(BuildContext context, String requestId,
      String choice, String restaurantId, String materialId, String qte) async {
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
    print('////////////////////////////');
    print(qte);
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
        ref.refresh(getDataMatiereFiniFuture);
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
