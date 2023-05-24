import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:eatch/servicesAPI/getMatiere.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../servicesAPI/multipart.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;

class MatiereAffiche extends ConsumerStatefulWidget {
  const MatiereAffiche({Key? key}) : super(key: key);

  @override
  MatiereAfficheState createState() => MatiereAfficheState();
}

class MatiereAfficheState extends ConsumerState<MatiereAffiche> {
  bool ajout = false;
  var nomController = TextEditingController();
  var stockController = TextEditingController();
  var peremptionController = TextEditingController();

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

  List<int>? _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;

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

  DateTime date = DateTime.now();
  String dateJour = '';
  bool dd = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataMatiereFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listMatiere);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listMatiere);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, context, List<Matiere> matiere) {
    return AppLayout(
      content: Column(
        children: [
          ajout == false
              ? Container(
                  alignment: Alignment.centerRight,
                  height: 80,
                  color: const Color(0xFFFCEBD1),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      const Text('Matières premières'),
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(180, 50)),
                        onPressed: () {
                          setState(() {
                            ajout = true;
                          });
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
                )
              : Container(
                  height: 300,
                  color: Palette.secondaryBackgroundColor,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          height: 50,
                          color: const Color(0xFFFCEBD1),
                          child: Row(
                            children: const [
                              SizedBox(
                                width: 50,
                              ),
                              Text('Création de Type de matière première'),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: TextFormField(
                            controller: nomController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                                hoverColor: Palette.primaryBackgroundColor,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 42, vertical: 20),
                                filled: true,
                                fillColor: Palette.primaryBackgroundColor,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Palette.secondaryBackgroundColor),
                                  gapPadding: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Palette.secondaryBackgroundColor),
                                  gapPadding: 10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Palette.secondaryBackgroundColor),
                                  gapPadding: 10,
                                ),
                                labelText: "Nom du type",
                                hintText: "Entrer le nom du type",
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: const Icon(Icons.food_bank)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: TextFormField(
                            controller: stockController,
                            //keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                                hoverColor: Palette.primaryBackgroundColor,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 42, vertical: 20),
                                filled: true,
                                fillColor: Palette.primaryBackgroundColor,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Palette.secondaryBackgroundColor),
                                  gapPadding: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Palette.secondaryBackgroundColor),
                                  gapPadding: 10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Palette.secondaryBackgroundColor),
                                  gapPadding: 10,
                                ),
                                labelText: "Stock",
                                hintText: "Entrer le stock de base",
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: const Icon(Icons.food_bank)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // début --------------------------------------------
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              const Text(
                                "Date de péremption",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: date,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );

                                  if (newDate == null) return;

                                  setState(() {
                                    date = newDate;
                                    dd = true;
                                    //dateJour =
                                    //"${date.year}/${date.month}/${date.day}";
                                  });
                                  print(date);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.primaryColor,
                                  minimumSize: const Size(150, 40),
                                  maximumSize: const Size(200, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: dd == false
                                    ? Text(
                                        "${date.year}-${date.month}-${date.day}",
                                        style: const TextStyle(fontSize: 18),
                                      )
                                    : Text(
                                        "${date.year}-${date.month}-${date.day}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                              ),

                              /*const SizedBox(width: 10),
                              dd == false
                                  ? Text(
                                      date.toString(),
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  : Text(
                                      date.toString(),
                                      style: const TextStyle(fontSize: 18),
                                    )*/
                              /*dd == false
                                  ? Text(
                                      "${date.year}/${date.month}/${date.day}",
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  : Text(
                                      dateJour,
                                      style: const TextStyle(fontSize: 18),
                                    )*/
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // fin --------------------------------------------
                        // Creation du bouton qui reécupere l'image
                        Container(
                          //width: 350,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final result = await FilePicker.platform
                                        .pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                          "png",
                                          "jpg",
                                          "jpeg",
                                        ]);

                                    if (result != null) {
                                      file = result.files.single;
                                      Uint8List fileBytes = result
                                          .files.single.bytes as Uint8List;
                                      //print(base64Encode (fileBytes))
                                      //List<int>
                                      _selectedFile = fileBytes;
                                      /*setState(() {
                                  filee = true;
                                });*/
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Palette.primaryColor,
                                    minimumSize: const Size(150, 40),
                                    maximumSize: const Size(200, 60),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: const Text("Image"),
                                ),
                              ]),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        // fin de la creation du bouton image
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 350,
                            child: Row(children: [
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: (() {
                                  creationMatierePremiere(
                                    context,
                                    nomController.text,
                                    stockController.text,
                                    date.toString(),
                                    _selectedFile!,
                                    result,
                                  );
                                  setState(() {
                                    ajout = false;
                                  });
                                  //setState(() {});
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.primaryColor,
                                  minimumSize: const Size(150, 50),
                                  maximumSize: const Size(200, 70),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Enregistrer'),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                onPressed: (() {
                                  setState(() {
                                    ajout = false;
                                  });
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Palette.secondaryBackgroundColor,
                                  minimumSize: const Size(150, 50),
                                  maximumSize: const Size(200, 70),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  'Annuler',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: ajout == false ? height - 175 : height - 400,
            width: width - 20,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 50,
                    mainAxisExtent: 300),
                itemCount: matiere.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          opacity: 50,
                          image: NetworkImage(
                              "http://13.39.81.126:4008${matiere[index].image!}"),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          matiere[index].mpName!,
                          style: GoogleFonts.raleway().copyWith(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Initiale: ${matiere[index].quantity.toString()} ${matiere[index].unity!}',
                          style: GoogleFonts.raleway().copyWith(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          'Consommation: ${matiere[index].consumerQuantity.toString()} ${matiere[index].unity!}',
                          style: GoogleFonts.raleway().copyWith(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          'Reste: ${(matiere[index].quantity! - matiere[index].consumerQuantity!).toString()} ${matiere[index].unity!}',
                          style: GoogleFonts.raleway().copyWith(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        Expanded(child: Container()),
                        Container(
                          height: 100,
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(width, 50),
                                  backgroundColor: Palette.secondaryColor,
                                ),
                                onPressed: (() {
                                  dialogModif(
                                      context,
                                      matiere[index].mpName!,
                                      matiere[index].quantity!,
                                      matiere[index].unity!);
                                }),
                                icon: const Icon(Icons.edit),
                                label: const Text('Modifier'),
                              ),
                              ElevatedButton.icon(
                                onPressed: (() {
                                  dialogDelete(matiere[index].mpName!,
                                      matiere[index].sId!);
                                }),
                                icon: const Icon(Icons.delete),
                                label: const Text('Supprimer'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Palette.deleteColors,
                                    minimumSize: Size(width, 50)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget verticalView(
      double height, double width, context, List<Matiere> matiere) {
    return AppLayout(
        content: Column(
      children: [
        ajout == false
            ? Container(
                alignment: Alignment.centerRight,
                height: 80,
                color: const Color(0xFFFCEBD1),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    const Text('Matières premières'),
                    Expanded(child: Container()),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(180, 50)),
                      onPressed: () {
                        setState(() {
                          ajout = true;
                        });
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
              )
            : Container(
                height: 300,
                color: Palette.secondaryBackgroundColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        height: 50,
                        color: const Color(0xFFFCEBD1),
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 50,
                            ),
                            Text('Création de Type de matière première'),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: TextFormField(
                          controller: nomController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                              hoverColor: Palette.primaryBackgroundColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 42, vertical: 20),
                              filled: true,
                              fillColor: Palette.primaryBackgroundColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              labelText: "Nom du type",
                              hintText: "Entrer le nom du type",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const Icon(Icons.food_bank)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // début --------------------------------------------
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: Row(
                          children: [
                            const SizedBox(width: 15),
                            const Text(
                              "Date de péremption",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                );

                                if (newDate == null) return;

                                setState(() {
                                  date = newDate;
                                  dd = true;
                                  //dateJour =
                                  //"${date.year}/${date.month}/${date.day}";
                                });
                                print(date);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.primaryColor,
                                minimumSize: const Size(150, 40),
                                maximumSize: const Size(200, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: dd == false
                                  ? Text(
                                      "${date.year}-${date.month}-${date.day}",
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  : Text(
                                      "${date.year}-${date.month}-${date.day}",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                            ),

                            /*const SizedBox(width: 10),
                              dd == false
                                  ? Text(
                                      date.toString(),
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  : Text(
                                      date.toString(),
                                      style: const TextStyle(fontSize: 18),
                                    )*/
                            /*dd == false
                                  ? Text(
                                      "${date.year}/${date.month}/${date.day}",
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  : Text(
                                      dateJour,
                                      style: const TextStyle(fontSize: 18),
                                    )*/
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // fin --------------------------------------------
                      // Creation du bouton qui reécupere l'image
                      Container(
                        //width: 350,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await FilePicker.platform
                                      .pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: [
                                        "png",
                                        "jpg",
                                        "jpeg",
                                      ]);

                                  if (result != null) {
                                    file = result.files.single;
                                    Uint8List fileBytes =
                                        result.files.single.bytes as Uint8List;
                                    //print(base64Encode (fileBytes))
                                    //List<int>
                                    _selectedFile = fileBytes;
                                    /*setState(() {
                                  filee = true;
                                });*/
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.primaryColor,
                                  minimumSize: const Size(150, 40),
                                  maximumSize: const Size(200, 60),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text("Image"),
                              ),
                            ]),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      // fin de la creation du bouton image
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: TextFormField(
                          controller: stockController,
                          //keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                              hoverColor: Palette.primaryBackgroundColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 42, vertical: 20),
                              filled: true,
                              fillColor: Palette.primaryBackgroundColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              labelText: "Stock",
                              hintText: "Entrer le stock de base",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const Icon(Icons.food_bank)),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 350,
                          child: Row(children: [
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: (() {
                                setState(() {});
                              }),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.primaryColor,
                                minimumSize: const Size(150, 50),
                                maximumSize: const Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Enregistrer'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: (() {
                                setState(() {
                                  ajout = false;
                                });
                              }),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Palette.secondaryBackgroundColor,
                                minimumSize: const Size(150, 50),
                                maximumSize: const Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text(
                                'Annuler',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: ajout == true ? height - 465 : height - 245, //85,
          width: width - 20,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 50,
                  mainAxisExtent: 300),
              itemCount: matiere.length,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                        opacity: 50,
                        image: NetworkImage(
                            "http://13.39.81.126:4008${matiere[index].image!}"),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        matiere[index].mpName!,
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Initiale: ${matiere[index].quantity.toString()} ${matiere[index].unity!}',
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        'Consommation: ${matiere[index].consumerQuantity.toString()} ${matiere[index].unity!}',
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        'Reste: ${(matiere[index].quantity! - matiere[index].consumerQuantity!).toString()} ${matiere[index].unity!}',
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      Expanded(child: Container()),
                      Container(
                        height: 100,
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(width, 50),
                                backgroundColor: Palette.secondaryColor,
                              ),
                              onPressed: (() {
                                dialogModif(
                                    context,
                                    matiere[index].mpName!,
                                    matiere[index].quantity!,
                                    matiere[index].unity!);
                              }),
                              icon: const Icon(Icons.edit),
                              label: const Text('Modifier'),
                            ),
                            ElevatedButton.icon(
                              onPressed: (() {
                                dialogDelete(matiere[index].mpName!,
                                    matiere[index].sId!);
                              }),
                              icon: const Icon(Icons.delete),
                              label: const Text('Supprimer'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.deleteColors,
                                  minimumSize: Size(width, 50)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    ));
  }

  Future dialogDelete(String nom, String idMatiere) {
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
                      deleteMatierePremiere(context, idMatiere);
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
                  )));
        });
  }

  Future dialogModif(
      BuildContext contextt, String nom, int init, String mesure) {
    print('dedans');
    int count = init;
    return showDialog(
        context: contextt,
        builder: (contextt) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Modification",
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
                    Icons.delete,
                    size: 14,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.deleteColors),
                  onPressed: () {},
                  label: const Text("Valider."))
            ],
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: 150,
                child: Column(
                  children: [
                    Text(
                      'Type : $nom',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text('Stock Initial : $init $mesure'),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 100,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Palette.greenColors),
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () {
                                setState(() {
                                  count--;
                                });
                                print(count);
                              },
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 16,
                              )),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  count.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  count++;
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
        });
  }

/////////Création de matière premiere
  ///
  Future<void> creationMatierePremiere(
    BuildContext context,
    String nomMatierePremiere,
    String quantite,
    String peremption,
    List<int> selectedFile,
    FilePickerResult? result,
  ) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var restaurantId = prefs.getString('idRestaurant').toString();
    var token = prefs.getString('token');

    var url = Uri.parse("http://13.39.81.126:4008/api/materials/create");
    final request = MultipartRequest(
      'POST',
      url,
      // ignore: avoid_returning_null_for_void
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );

    var json = {
      'restaurant': restaurantId,
      'mp_name': nomMatierePremiere,
      'quantity': quantite,
      'lifetime': peremption,
      '_creator': id,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromBytes('file', selectedFile,
        contentType: MediaType('application', 'octet-stream'),
        filename: result?.files.first.name));

    print("RESPENSE SEND STEAM FILE REQ");
    //var responseString = await streamedResponse.stream.bytesToString();
    var response = await request.send();
    print("Upload Response" + response.toString());
    print(response.statusCode);
    print(request.headers);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });
        //stopMessage();
        //finishWorking();
        ref.refresh(getDataMatiereFuture);
      } else {
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      throw e;
    }
  }

  //////////Suppression de produit
  ///
  Future<http.Response> deleteMatierePremiere(
      BuildContext context, String idMatierePremiere) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getString('IdUser').toString();

      print(id);
      print(idMatierePremiere);

      var token = prefs.getString('token');
      String urlDelete =
          "http://13.39.81.126:4008/api/materials/delete/$idMatierePremiere";

      var json = {'_creator': id};

      var body = jsonEncode(json);

      final http.Response response =
          await http.delete(Uri.parse(urlDelete), headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Accept': 'application/json',
        'authorization': 'Bearer $token',
        //'body': body
      }, body: {
        '_creator': id
      });

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        ref.refresh(getDataMatiereFuture);
        return response;
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
