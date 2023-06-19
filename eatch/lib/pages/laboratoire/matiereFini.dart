// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:eatch/servicesAPI/getMatiereFini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:eatch/servicesAPI/multipart.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MatiereFiniPage extends ConsumerStatefulWidget {
  const MatiereFiniPage({Key? key}) : super(key: key);

  @override
  MatiereFiniPageState createState() => MatiereFiniPageState();
}

class MatiereFiniPageState extends ConsumerState<MatiereFiniPage> {
  // Text editing controller
  int count = 1;
  var nombrecontrol = TextEditingController();
  final titleController = TextEditingController();
  final quantiteController = TextEditingController();
  var dateinput = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<int> _selectedFile1 = [];
  FilePickerResult? result1;
  PlatformFile? file1;
  bool filee1 = false;
  Uint8List? selectedImageInBytes1;
  bool _selectFile1 = false;
  List<String> listOfQuantite = [
    "Mesure *",
    "kg",
    "litre",
    "Steak",
  ];

  String? unite;

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

  bool vertical = false;
  bool ajoutFini = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataMatiereFiniFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listMatiereFini);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listMatiereFini);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, contextt, List<MatiereFini> listFini) {
    return Scaffold(
      body: AppLayout(
        content: Container(
          child: Form(
            key: _formKey,
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
                      const Text('Gestion des matières finies'),
                      Expanded(child: Container()),
                      ajoutFini == true
                          ? ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minimumSize: const Size(180, 50)),
                              onPressed: () {
                                setState(() {
                                  ajoutFini = false;
                                });
                              },
                              icon: const Icon(Icons.backspace),
                              label: const Text('Retour'),
                            )
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(180, 50)),
                              onPressed: () async {
                                setState(() {
                                  ajoutFini = true;
                                  vertical = false;
                                });
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Ajouter une matière brute'),
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
                ajoutFini == true
                    ? Container()
                    : Container(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minimumSize: const Size(100, 50)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.backspace),
                          label: const Text('Retour'),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                ajoutFini == true
                    ? Container(
                        child: creation(),
                      )
                    : Container(
                        height: height - 222,
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 50,
                                    mainAxisExtent: 400),
                            itemCount: listFini.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 10,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 200,
                                        width: 300,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('emballage.jpeg'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Text('Nom : ${listFini[index].title}'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'Quantité : ${listFini[index].quantity} ${listFini[index].unit}'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'Dernière date : ${listFini[index].updatedAt}'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'Date de création : ${listFini[index].createdAt}'),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: IconButton(
                                                alignment: Alignment.center,
                                                splashColor:
                                                    Palette.greenColors,
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 30,
                                                  color: Palette.greenColors,
                                                ),
                                              ),
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
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.black,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: IconButton(
                                                    splashColor:
                                                        Palette.greenColors,
                                                    onPressed: () {
                                                      dialogAjout(
                                                          contextt,
                                                          listFini[index].sId!,
                                                          'Steak',
                                                          listFini[index]
                                                              .title!,
                                                          listFini[index]
                                                              .quantity
                                                              .toString());
                                                    },
                                                    iconSize: 30,
                                                    icon: const Icon(
                                                      Icons.add_box,
                                                      color:
                                                          Palette.greenColors,
                                                    ),
                                                  ),
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: IconButton(
                                                alignment: Alignment.center,
                                                splashColor: Colors.red,
                                                onPressed: () {
                                                  dialogDelete(
                                                      context,
                                                      listFini[index].sId!,
                                                      listFini[index].title!);
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 30,
                                                  color: Colors.red,
                                                ),
                                              ),
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
        ),
      ),
    );
  }

  Widget verticalView(
      double height, double width, contextt, List<MatiereFini> listFini) {
    return Scaffold(
      body: AppLayout(
        content: Container(
          child: Form(
            key: _formKey,
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
                      const Text('Gestion des matières finies'),
                      Expanded(child: Container()),
                      ajoutFini == true
                          ? ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minimumSize: const Size(180, 50)),
                              onPressed: () {
                                setState(() {
                                  ajoutFini = false;
                                });
                              },
                              icon: const Icon(Icons.backspace),
                              label: const Text('Retour'),
                            )
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(180, 50)),
                              onPressed: () async {
                                setState(() {
                                  ajoutFini = true;
                                  vertical = true;
                                });
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Ajouter une matière brute'),
                            ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ajoutFini == true
                    ? Container()
                    : Container(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minimumSize: const Size(100, 50)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.backspace),
                          label: const Text('Retour'),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                ajoutFini == true
                    ? Container(
                        height: height - 222,
                        child: creation(),
                      )
                    : Container(
                        height: height - 222,
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 50,
                                    mainAxisExtent: 380),
                            itemCount: listFini.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 10,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 180,
                                        width: 300,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('emballage.jpeg'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Nom : ${listFini[index].title}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Quantité : ${listFini[index].quantity} ${listFini[index].unit}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Dernière date : ${listFini[index].updatedAt}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Date de création : ${listFini[index].createdAt}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: IconButton(
                                                alignment: Alignment.center,
                                                splashColor:
                                                    Palette.greenColors,
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 30,
                                                  color: Palette.greenColors,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                flex: 5,
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  alignment: Alignment.center,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.black,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: IconButton(
                                                    splashColor:
                                                        Palette.greenColors,
                                                    onPressed: () {
                                                      dialogAjout(
                                                          contextt,
                                                          listFini[index].sId!,
                                                          'Steak',
                                                          listFini[index]
                                                              .title!,
                                                          listFini[index]
                                                              .quantity
                                                              .toString());
                                                    },
                                                    iconSize: 30,
                                                    icon: const Icon(
                                                      Icons.add_box,
                                                      color:
                                                          Palette.greenColors,
                                                    ),
                                                  ),
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: IconButton(
                                                alignment: Alignment.center,
                                                splashColor: Colors.red,
                                                onPressed: () {
                                                  dialogDelete(
                                                      context,
                                                      listFini[index].sId!,
                                                      listFini[index].title!);
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 30,
                                                  color: Colors.red,
                                                ),
                                              ),
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
        ),
      ),
    );
  }

  Widget creation() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: vertical == false
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width - 100,
            child: TextFormField(
              controller: titleController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
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
                  labelText: "Titre",
                  hintText: "Inscrire le titre",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.title)),
            ),
          ),
          SizedBox(
            height: vertical == false ? 50 : 20,
          ),
          Container(
            width: vertical == false
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width - 100,
            height: 50,
            child: Row(children: [
              Expanded(
                flex: 7,
                child: SizedBox(
                  child: TextFormField(
                    controller: quantiteController,
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
                          borderSide:
                              const BorderSide(color: Palette.yellowColor),
                          gapPadding: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Palette.yellowColor),
                          gapPadding: 10,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Palette.yellowColor),
                          gapPadding: 10,
                        ),
                        labelText: "Mesure",
                        hintText: "Inscrire la mesure",
                        // If  you are using latest version of flutter then lable text and hint text shown like this
                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: const Icon(Icons.accessibility)),
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
                      return "La quantité est obligatoire.";
                    } else {
                      return null;
                    }
                  },
                  items: listOfQuantite.map((String val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ]),
          ),
          SizedBox(
            height: vertical == false ? 50 : 20,
          ),
          Container(
            width: 300,
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
                    lastDate: DateTime(2101));

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
                labelText: "Date",
                hintText: "Entrer la date de péremption",

                // If  you are using latest version of flutter then lable text and hint text shown like this
                // if you r using flutter less then 1.20.* then maybe this is not working properly
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: const Icon(Icons.date_range),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.only(right: 70),
            color: Palette.secondaryBackgroundColor,
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () async {
                result1 = await FilePicker.platform
                    .pickFiles(type: FileType.custom, allowedExtensions: [
                  "png",
                  "jpg",
                  "jpeg",
                ]);
                if (result1 != null) {
                  setState(() {
                    file1 = result1!.files.single;

                    Uint8List fileBytes =
                        result1!.files.single.bytes as Uint8List;

                    _selectedFile1 = fileBytes;

                    filee1 = true;

                    selectedImageInBytes1 = result1!.files.first.bytes;
                    _selectFile1 = true;
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
                  child: _selectFile1 == false
                      ? const Icon(
                          Icons.camera_alt_outlined,
                          color: Palette.greenColors,
                          size: 40,
                        )
                      : Image.memory(
                          selectedImageInBytes1!,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: vertical == false ? 100 : 50,
          ),
          Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: 350,
              child: Row(children: [
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: (() {
                    creationMatiereSemiFini(
                        context,
                        titleController.text,
                        quantiteController.text,
                        dateinput.text,
                        _selectedFile1,
                        result1,
                        unite!);
                    dateinput.clear();
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
                  onPressed: (() {}),
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
          ),
        ],
      ),
    );
  }

  Future dialogAjout(BuildContext contextt, String id, String unit,
      String title, String quantite) {
    nombrecontrol.text = 1.toString();
    return showDialog(
      context: contextt,
      builder: (co) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Ajout de matière Fini",
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
                dateinput.clear();
                Navigator.of(context, rootNavigator: true).pop();
              },
              label: const Text("Quitter   "),
            ),
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
                ajoutMatiereFini(contextt, id, nombrecontrol.text);

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
              height: 204,
              child: Column(
                children: [
                  Text(
                    'Type : $title',
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
                  const SizedBox(
                    height: 10,
                  ),
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
                            lastDate: DateTime(2101));

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
                          borderSide:
                              const BorderSide(color: Palette.violetColor),
                          gapPadding: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Palette.violetColor),
                          gapPadding: 10,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Palette.violetColor),
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

  Future dialogDelete(BuildContext contextt, String id, String nom) {
    return showDialog(
      context: contextt,
      builder: (co) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "SUPPRESSION",
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  //deleteFournisseur(contextt, id);
                  Navigator.pop(co);
                },
                label: const Text("Supprimer."))
          ],
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: 170,
                child: Text('Voulez vous supprimer  $nom ?'));
          }),
        );
      },
    );
  }

  Future<void> creationMatiereSemiFini(
    BuildContext context,
    String nomMatierePremiere,
    String quantite,
    String peremption,
    List<int> selectedFile,
    FilePickerResult? result,
    String unit,
  ) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var idLabo = prefs.getString('idLabo').toString();

    var token = prefs.getString('token');

    //String adressUrl = prefs.getString('ipport').toString();

    var url = Uri.parse(
        "http://13.39.81.126:4015/api/semiMaterials/create"); // 13.39.81.126:4008
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
      'unit': unit,
      'laboratoryId': idLabo,
      'title': nomMatierePremiere,
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

        setState(() {
          dateinput.clear();
          ajoutFini = false;
        });
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.greenColors,
            message: "La matière semi-fini a été crée",
          ),
        );
        ref.refresh(getDataMatiereFiniFuture);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.deleteColors,
            message: "La matière semi-fini n'a pas été crée",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> ajoutMatiereFini(
    contextt,
    String materialId,
    String qte,
  ) async {
    ////////////
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var idLabo = prefs.getString('idLabo');

    var url = Uri.parse(
        "http://13.39.81.126:4015/api/laboratories/updateManufacturing"); //13.39.81.126 // 13.39.81.126 //13.39.81.126
    final request = MultipartRequest(
      'PATCH',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      'qte': qte,
      'materialId': materialId,
      'laboratoryId': idLabo,
      '_creator': id,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    /*if (result != null) {
      request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result.files.first.name));
    }*/

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
        /*setState(() {
          ajoutbrute = false;
        });*/
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "La matière fini a été ajouté",
          ),
        );

        ref.refresh(getDataMatiereFiniFuture);
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "La matière fini n'a pas été ajouté",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
