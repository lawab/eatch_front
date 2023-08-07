import 'dart:convert';
import 'dart:typed_data';
import 'package:eatch/servicesAPI/getMatiere.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
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
  var dateinput = TextEditingController();

  _clear() {
    setState(() {
      nomController.clear();
      stockController.clear();
      peremptionController.clear();
    });
  }

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
  Uint8List? selectedImageInBytes;
  bool filee = false;

  bool isLoading = false;
  bool _selectFile = false;
  String? matiereImage;

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

  List<String> listOfUnite = ["Unité *", "kg", "litre", "Carton"];

  String? unite;
  DateTime date = DateTime.now();
  //String dateJour = '';
  bool dd = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataMatiereFuture);

    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale('en'), Locale('fr')],
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
      double height, double width, contextt, List<Matiere> matiere) {
    return Scaffold(
      body: Column(
        children: [
          ajout == true
              ? Container()
              : Container(
                  alignment: Alignment.centerRight,
                  height: 80,
                  color: Palette.secondaryBackgroundColor,
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(180, 50)),
                        onPressed: () {
                          setState(() {
                            _selectedFile!.clear();
                            result = null;
                            ajout = true;
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter un type de matière'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
          ajout == true
              ? Container(
                  height: height,
                  color: Palette.secondaryBackgroundColor,
                  child: creation())
              : Container(
                  padding: EdgeInsets.only(right: 20, left: 20, bottom: 5),
                  height: height - 270,
                  width: width - 20,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
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
                                    "http://13.39.81.126:4008${matiere[index].image!}"), //13.39.81.126
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
                              SizedBox(
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
                                            matiere[index].unity!,
                                            matiere[index].sId!);
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
                                        minimumSize: Size(width, 50),
                                      ),
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

  Widget creation() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          height: 50,
          color: Palette.yellowColor,
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
        SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          child: TextFormField(
            controller: nomController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {},
            decoration: InputDecoration(
                hoverColor: Palette.primaryBackgroundColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                filled: true,
                fillColor: Palette.primaryBackgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(color: Palette.secondaryBackgroundColor),
                  gapPadding: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(color: Palette.secondaryBackgroundColor),
                  gapPadding: 10,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(color: Palette.secondaryBackgroundColor),
                  gapPadding: 10,
                ),
                hintText: "Entrer le nom du type",
                // If  you are using latest version of flutter then lable text and hint text shown like this
                // if you r using flutter less then 1.20.* then maybe this is not working properly
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: const Icon(Icons.food_bank)),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          child: Row(children: [
            Expanded(
              flex: 7,
              child: SizedBox(
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
                      hintText: "Entrer la quantité de base",
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: const Icon(Icons.food_bank)),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  hoverColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.yellowColor),
                    gapPadding: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.yellowColor),
                    gapPadding: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.yellowColor),
                    gapPadding: 10,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                value: unite,
                hint: const Text(
                  'Unité*',
                ),
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    unite = value;
                  });
                },
                onSaved: (value) {
                  setState(() {
                    unite = value;
                  });
                },
                validator: (String? value) {
                  if (value == null) {
                    return "L'unité est obligatoire.";
                  } else {
                    return null;
                  }
                },
                items: listOfUnite.map((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(
                      val,
                    ),
                  );
                }).toList(),
              ),
            )
          ]),
        ),

        const SizedBox(
          height: 20,
        ),
        // début --------------------------------------------
        SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          child: Row(
            children: [
              const SizedBox(width: 15),
              const Text(
                "Date de péremption",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 20),
              Container(
                width: 200,
                child: TextFormField(
                  controller: dateinput,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {},
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101),
                        //locale: const Locale("fr", "FR"),
                        builder: (BuildContext context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Palette.greenColors, // <-- SEE HERE
                                onPrimary: Colors.white, // <-- SEE HERE
                                onSurface: Colors.black, // <-- SEE HERE
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Colors.white, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        });

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        dateinput.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {
                      print("Date non selectionnée");
                    }
                  },
                  decoration: InputDecoration(
                    hoverColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 42, vertical: 20),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Palette.yellowColor),
                      gapPadding: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Palette.yellowColor),
                      gapPadding: 10,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Palette.yellowColor),
                      gapPadding: 10,
                    ),
                    labelText: "Date",
                    hintText: "Entrer une date ",

                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: const Icon(Icons.date_range),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 50,
        ),
        Container(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Creation du bouton qui reécupere l'image
              Container(
                padding: const EdgeInsets.only(right: 70),
                color: Palette.secondaryBackgroundColor,
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    result = await FilePicker.platform
                        .pickFiles(type: FileType.custom, allowedExtensions: [
                      "png",
                      "jpg",
                      "jpeg",
                    ]);
                    if (result != null) {
                      setState(() {
                        file = result!.files.single;

                        Uint8List fileBytes =
                            result!.files.single.bytes as Uint8List;

                        _selectedFile = fileBytes;

                        filee = true;

                        selectedImageInBytes = result!.files.first.bytes;
                        _selectFile = true;
                      });
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Palette.greenColors,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _selectFile == false
                          ? const Icon(
                              Icons.camera_alt_outlined,
                              color: Palette.greenColors,
                              size: 40,
                            )
                          : Image.memory(
                              selectedImageInBytes!,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: (() {
                  creationMatierePremiere(
                    context,
                    nomController.text,
                    stockController.text,
                    dateinput.text,
                    _selectedFile!,
                    result,
                  );
                  setState(() {
                    ajout = false;
                    _clear();
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
                    _clear();
                  });
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.secondaryBackgroundColor,
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
            ],
          ),
        ),

        // fin --------------------------------------------
        // Creation du bouton qui reécupere l'image
        /*Container(
          padding: const EdgeInsets.only(right: 70),
          color: Palette.secondaryBackgroundColor,
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () async {
              result = await FilePicker.platform
                  .pickFiles(type: FileType.custom, allowedExtensions: [
                "png",
                "jpg",
                "jpeg",
              ]);
              if (result != null) {
                setState(() {
                  file = result!.files.single;

                  Uint8List fileBytes = result!.files.single.bytes as Uint8List;

                  _selectedFile = fileBytes;

                  filee = true;

                  selectedImageInBytes = result!.files.first.bytes;
                  _selectFile = true;
                });
              }
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 4,
                  color: Palette.greenColors,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _selectFile == false
                    ? const Icon(
                        Icons.camera_alt_outlined,
                        color: Palette.greenColors,
                        size: 40,
                      )
                    : Image.memory(
                        selectedImageInBytes!,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 30,
        ),

        // fin de la creation du bouton image
        Container(
          alignment: Alignment.centerRight,
          child: SizedBox(
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
                    dateinput.text,
                    _selectedFile!,
                    result,
                  );
                  setState(() {
                    ajout = false;
                    _clear();
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
                    _clear();
                  });
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.secondaryBackgroundColor,
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
        ),*/
      ],
    );
  }

  Widget verticalView(
      double height, double width, context, List<Matiere> matiere) {
    return Scaffold(
      body: Column(
        children: [
          ajout == true
              ? Container()
              : Container(
                  alignment: Alignment.centerRight,
                  height: 80,
                  color: Palette.secondaryBackgroundColor,
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(180, 50)),
                        onPressed: () {
                          setState(() {
                            _selectedFile!.clear();
                            result = null;
                            ajout = true;
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter un type de matière'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
          ajout == true
              ? Container(
                  height: height,
                  color: Palette.secondaryBackgroundColor,
                  child: creation())
              : SizedBox(
                  height: height - 375,
                  width: width - 20,
                  child: matiere.isEmpty
                      ? const Center(
                          child: Text(
                            "Aucune matière première",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
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
                                        "http://13.39.81.126:4008${matiere[index].image!}"), //13.39.81.126
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
                                  SizedBox(
                                    height: 100,
                                    child: Column(
                                      children: [
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(width, 50),
                                            backgroundColor:
                                                Palette.secondaryColor,
                                          ),
                                          onPressed: (() {
                                            dialogModif(
                                                context,
                                                matiere[index].mpName!,
                                                matiere[index].quantity!,
                                                matiere[index].unity!,
                                                matiere[index].sId!);
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
                                            backgroundColor:
                                                Palette.deleteColors,
                                            minimumSize: Size(width, 50),
                                          ),
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
      },
    );
  }

  Future dialogModif(BuildContext contextt, String nom, int init, String mesure,
      String idMatiere) {
    //print('dedans');
    int count = init;
    return showDialog(
      context: contextt,
      builder: (co) {
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
                  Icons.check,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.greenColors),
                onPressed: () {
                  modificationMatierePremiere(
                      context, nom, count, mesure, idMatiere);
                  Navigator.of(co, rootNavigator: true).pop();
                },
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
      },
    );
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

    //String adressUrl = prefs.getString('ipport').toString();

    var url = Uri.parse(
        "http://13.39.81.126:4008/api/materials/create"); // 13.39.81.126:4008
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
    request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
        contentType: MediaType('application', 'octet-stream'),
        filename: result?.files.first.name));

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
        //stopMessage();
        //finishWorking();
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.greenColors,
            message: "La matière première a été crée",
          ),
        );
        ref.refresh(getDataMatiereFuture);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.deleteColors,
            message: "La matière première n'a pas été crée",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  //////////Suppression de matiere première
  ///
  Future<http.Response> deleteMatierePremiere(
      BuildContext context, String idMatierePremiere) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getString('IdUser').toString();

      //String adressUrl = prefs.getString('ipport').toString();

      var token = prefs.getString('token');
      String urlDelete =
          "http://13.39.81.126:4008/api/materials/delete/$idMatierePremiere"; // 13.39.81.126:4008 //$adressUrl
      var json = {'_creator': id};
      var body = jsonEncode(json);
      final http.Response response = await http.delete(
        Uri.parse(urlDelete),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
          'body': body
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.greenColors,
            message: "La matière première a été supprimée avec succès",
          ),
        );
        ref.refresh(getDataMatiereFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.deleteColors,
            message: "La matière première n'a pas été supprimée",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ///// - Modification de matiere premiere
  ///
  Future<void> modificationMatierePremiere(
    BuildContext context,
    String nomMatierePremiere,
    int quantite,
    String mesures,
    String idModifMatiere,
  ) async {
    ////////////
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var restaurantId = prefs.getString('idRestaurant').toString();
    var token = prefs.getString('token');

    //String adressUrl = prefs.getString('ipport').toString();

    var url = Uri.parse(
        "http://13.39.81.126:4008/api/materials/update/$idModifMatiere"); //$adressUrl
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
      'restaurant': restaurantId,
      'mp_name': nomMatierePremiere,
      'quantity': quantite,
      'unity': mesures,
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
            message: "La matière première a été modifié",
          ),
        );
        setState(() {
          ref.refresh(getDataMatiereFuture);
        });
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "La matière première n'a pas été modifié",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
