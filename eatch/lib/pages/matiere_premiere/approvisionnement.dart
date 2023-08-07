import 'dart:async';
import 'package:eatch/servicesAPI/getRestaurant.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Approvisonnement extends ConsumerStatefulWidget {
  const Approvisonnement({Key? key}) : super(key: key);

  @override
  ApprovisonnementState createState() => ApprovisonnementState();
}

class ApprovisonnementState extends ConsumerState<Approvisonnement> {
  @override
  void initState() {
    startTimer();
    /*WidgetsBinding.instance.addPostFrameCallback((_) async {
      rRRR();
    });*/

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
            ref.refresh(getDataRestaurantOneFuture);
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

  var nombrecontrol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var view = ref.watch(getDataRestaurantOneFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                view.listApprovisionnement);
          } else {
            return verticalView(height(context), width(context), context,
                view.listApprovisionnement);
          }
        },
      ),
    );
  }

  int count = 0;
  Widget horizontalView(
      double height, double width, contextt, List<Providings> demande) {
    return Scaffold(
      body: Container(
        height: height - 190,
        width: width,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              height: height - 190,
              child: demande.isEmpty
                  ? const Center(
                      child: Text(
                        "Aucune demande d'approvisionnement",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  : ListView.builder(
                      itemCount: demande.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10,
                          child: InkWell(
                            child: Container(
                              height: 100,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        demande[index].material!.title!,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              const TextSpan(
                                                text: "Laboratoire: ",
                                                style: TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: demande[index]
                                                    .laboratory!
                                                    .laboName!,
                                                style: const TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              )
                                            ]),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                            text: TextSpan(children: [
                                              const TextSpan(
                                                text: "Date de demande: ",
                                                style: TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: demande[index]
                                                    .dateProviding
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: demande[index]
                                                            .dateValidated
                                                            .toString() ==
                                                        'null'
                                                    ? 'En attente'
                                                    : demande[index]
                                                        .dateValidated
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${demande[index].qte.toString()} ${demande[index].material!.unit.toString()}',
                                                style: const TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
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
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text('STATUS : '),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        demande[index].dateValidated == null &&
                                                demande[index].validated ==
                                                    false
                                            ? const CircleAvatar(
                                                maxRadius: 20,
                                                backgroundColor: Colors.amber,
                                                child: Icon(
                                                  Icons.watch,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : demande[index].validated == false
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

  Widget verticalView(
      double height, double width, contextt, List<Providings> demande) {
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              height: height,
              child: demande.isEmpty
                  ? const Center(
                      child: Text(
                        "Aucune demande d'approvisionnement",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  : ListView.builder(
                      itemCount: demande.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10,
                          child: InkWell(
                            child: Container(
                              height: 100,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        demande[index].material!.title!,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              const TextSpan(
                                                text: "Laboratoire: ",
                                                style: TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: demande[index]
                                                    .laboratory!
                                                    .laboName!,
                                                style: const TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              )
                                            ]),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                            text: TextSpan(children: [
                                              const TextSpan(
                                                text: "Date de demande: ",
                                                style: TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: demande[index]
                                                    .dateProviding
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: demande[index]
                                                            .dateValidated
                                                            .toString() ==
                                                        'null'
                                                    ? 'En attente'
                                                    : demande[index]
                                                        .dateValidated
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${demande[index].qte.toString()} ${demande[index].material!.unit.toString()}',
                                                style: const TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
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
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text('STATUS : '),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        demande[index].dateValidated == null &&
                                                demande[index].validated ==
                                                    false
                                            ? const CircleAvatar(
                                                maxRadius: 20,
                                                backgroundColor: Colors.amber,
                                                child: Icon(
                                                  Icons.watch,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : demande[index].validated == false
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
}
