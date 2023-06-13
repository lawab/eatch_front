import 'dart:html';
import 'dart:typed_data';
import 'package:eatch/pages/restaurant/detailRestaurant.dart';
import 'package:eatch/servicesAPI/multipart.dart';
import 'package:eatch/utils/default_button/default_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:eatch/pages/restaurant/modificationRestaurant.dart';
import 'package:eatch/servicesAPI/getRestaurant.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RestaurantAffiche extends ConsumerStatefulWidget {
  const RestaurantAffiche({Key? key}) : super(key: key);

  @override
  RestaurantAfficheState createState() => RestaurantAfficheState();
}

class RestaurantAfficheState extends ConsumerState<RestaurantAffiche> {
  @override
  void initState() {
    ip();
    // TODO: implement initState
    super.initState();
  }

  String adress_url = '';
  void ip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    adress_url = prefs.getString('ipport').toString();
  }

  var nomController = TextEditingController();
  var villeController = TextEditingController();
  var adresseController = TextEditingController();
  var employeController = TextEditingController();

  bool ajout = false;
  List<int> _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  bool filee = false;
  Uint8List? selectedImageInBytes;

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

  bool _selectFile = false;
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

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataRsetaurantFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listRsetaurant);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listRsetaurant);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, context, List<Restaurant> listRsetaurant) {
    return AppLayout(
      content: Column(
        children: [
          ajout == false
              ? Container(
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
                            const Text('GESTION DE RESTAURANT'),
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
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Créer un restaurant'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: ajout == false ? height - 145 : height - 465,
                        width: width,
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 470,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 50,
                                  mainAxisExtent: 355),
                          itemCount: listRsetaurant.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return GestureDetector(
                              child: Container(
                                height: height,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E9647),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: width / 3,
                                      height: height / 3 - 20,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          //Logo_Eatch_png.png
                                          Container(
                                            width: width / 5,
                                            height: height / 3 - 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              color: Colors.black,
                                              image: DecorationImage(
                                                  opacity: 150,
                                                  image: NetworkImage(
                                                      'http://192.168.1.105:4002${listRsetaurant[index].infos!.logo.toString()}'), //192.168.1.105:4002
                                                  fit: BoxFit.cover),
                                            ),
                                          ),

                                          Positioned(
                                            top: 5,
                                            left: 30,
                                            width: width / 5,
                                            height: 50,
                                            child: Text(
                                              'Nom du restaurant: ${listRsetaurant[index].restaurantName!}',
                                              style: const TextStyle(
                                                  fontFamily: 'Righteous',
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                          Positioned(
                                            top: 60,
                                            left: 30,
                                            width: width / 5,
                                            height: 30,
                                            child: Text(
                                              "Ville: ${listRsetaurant[index].infos!.town!}",
                                              style: const TextStyle(
                                                fontFamily: 'Righteous',
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 90,
                                            left: 30,
                                            width: width / 5,
                                            height: 30,
                                            child: Text(
                                              "Adresse: ${listRsetaurant[index].infos!.address!}",
                                              style: const TextStyle(
                                                fontFamily: 'Righteous',
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 120,
                                            left: 30,
                                            width: width / 5,
                                            height: 30,
                                            child: const Text(
                                              "Nombre d'emplyé: 50",
                                              style: TextStyle(
                                                fontFamily: 'Righteous',
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 150,
                                            left: 30,
                                            width: width / 5,
                                            height: 30,
                                            child: Text(
                                              "Date de création: ${listRsetaurant[index].createdAt}",
                                              style: const TextStyle(
                                                fontFamily: 'Righteous',
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 5,
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: IconButton(
                                              onPressed: (() {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RestaurantModification(
                                                      restaurant:
                                                          listRsetaurant[index],
                                                    ),
                                                  ),
                                                );
                                              }),
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Color(0xFFF09F1B),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: IconButton(
                                              onPressed: (() {
                                                dialogDelete(
                                                    listRsetaurant[index]
                                                        .sId
                                                        .toString(),
                                                    listRsetaurant[index]
                                                        .restaurantName
                                                        .toString());
                                              }),
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Color(0xFFF09F1B),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RestaurantDetail(
                                              restaurant: listRsetaurant[index],
                                            )));
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  child: creation(),
                ),
          /*ajout == true
              ? const Divider(
                  height: 5,
                  color: Palette.yellowColor,
                )
              : */
        ],
      ),
    );
  }

  Widget verticalView(
      double height, double width, context, List<Restaurant> listRsetaurant) {
    return AppLayout(
      content: Column(
        children: [
          ajout == false
              ? Container(
                  alignment: Alignment.centerRight,
                  height: 80,
                  color: Palette.yellowColor,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      const Text('Gestion de restaurant'),
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
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Créer un restaurant'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 300,
                  child: creation(),
                ),
          ajout == true
              ? const Divider(
                  height: 5,
                  color: Palette.yellowColor,
                )
              : const SizedBox(
                  height: 5,
                ),
          Container(
            height: ajout == false ? height - 216 : height - 436,
            width: width,
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 450,
                  childAspectRatio: 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 50,
                  mainAxisExtent: 300),
              itemCount: listRsetaurant.length,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green, //Color(0xFF1E9647),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: width / 3,
                          height: height / 3 - 20,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              //Logo_Eatch_png.png
                              Container(
                                width: width / 5,
                                height: height / 3 - 20,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15.0),
                                  //color: Colors.white,

                                  image: DecorationImage(
                                      opacity: 150,
                                      image: NetworkImage(
                                          'http://192.168.1.105:4002${listRsetaurant[index].infos!.logo.toString()}'),
                                      //image: AssetImage('Logo_Eatch_png.png'),
                                      fit: BoxFit.cover),
                                ),
                              ),

                              Positioned(
                                top: 5,
                                left: 30,
                                width: width / 5,
                                height: 50,
                                child: Text(
                                  'Nom du restaurant: ${listRsetaurant[index].restaurantName!}',
                                  style: const TextStyle(
                                      fontFamily: 'Righteous',
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              Positioned(
                                top: 60,
                                left: 30,
                                width: width / 5,
                                height: 30,
                                child: Text(
                                  "Ville: ${listRsetaurant[index].infos!.town!}",
                                  style: const TextStyle(
                                    fontFamily: 'Righteous',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 90,
                                left: 30,
                                width: width / 5,
                                height: 30,
                                child: Text(
                                  "Adresse: ${listRsetaurant[index].infos!.address!}",
                                  style: const TextStyle(
                                    fontFamily: 'Righteous',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 120,
                                left: 30,
                                width: width / 5,
                                height: 30,
                                child: const Text(
                                  "Nombre d'emplyé: 50",
                                  style: TextStyle(
                                    fontFamily: 'Righteous',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 150,
                                left: 30,
                                width: width / 5,
                                height: 30,
                                child: Text(
                                  "Date de création: ${listRsetaurant[index].createdAt}",
                                  style: const TextStyle(
                                    fontFamily: 'Righteous',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: width / 5,
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: IconButton(
                                    onPressed: (() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RestaurantModification(
                                                    restaurant:
                                                        listRsetaurant[index],
                                                  )));
                                    }),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color(0xFFF09F1B),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: (() {
                                      dialogDelete(
                                          listRsetaurant[index].sId.toString(),
                                          listRsetaurant[index]
                                              .restaurantName
                                              .toString());
                                    }),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Palette.deleteColors,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantDetail(
                                  restaurant: listRsetaurant[index],
                                )));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget creation() {
    return Container(
      color: Palette.secondaryBackgroundColor,
      child: SingleChildScrollView(
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
                  const Text('Création de restaurant'),
                  Expanded(child: Container()),
                  const SizedBox(
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
                    labelText: "Nom",
                    hintText: "Entrer le nom du restaurant",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: const Icon(Icons.food_bank)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: TextFormField(
                controller: villeController,
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
                    labelText: "Ville",
                    hintText: "Entrer la ville ou se trouve le restaurant",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: const Icon(Icons.location_city)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: TextFormField(
                controller: adresseController,
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
                    labelText: "Adresse",
                    hintText: "Entrer l'adresse du restaurant",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: const Icon(Icons.local_activity)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: TextFormField(
                controller: employeController,
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
                    labelText: "Nombre d'employés",
                    hintText: "Entrer le nombre d'employés du restaurant",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: const Icon(Icons.person)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
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
            const SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 420,
                child: Row(children: [
                  SizedBox(
                    width: 200,
                    child: DefaultButton(
                      color: Palette.primaryColor,
                      foreground: Colors.red,
                      text: 'ENREGISTRER',
                      textcolor: Palette.primaryBackgroundColor,
                      onPressed: () {
                        creationRestaurant(
                          context,
                          nomController.text,
                          villeController.text,
                          adresseController.text,
                          _selectedFile,
                          result,
                        );
                        setState(() {
                          ajout = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 200,
                    child: DefaultButton(
                      color: Palette.secondaryBackgroundColor,
                      foreground: Colors.red,
                      text: 'ANNULER',
                      textcolor: Palette.textsecondaryColor,
                      onPressed: () {
                        setState(() {
                          ajout = false;
                        });
                      },
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Future dialogDelete(id, nom) {
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
                    deleteRestaurant(context, id);
                    Navigator.pop(con);
                  },
                  label: const Text("Supprimer."))
            ],
            content: Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 150,
              child: Text(
                "Voulez vous supprimer le restaurant $nom ?",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ),
          );
        });

    ////////////////////////////////
  }

  ///////// - Création restaurant
  Future<void> creationRestaurant(
    contextt,
    String nomRestaurant,
    String villeRestaurant,
    String adresseRestaurant,
    selectedFile,
    result,
  ) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    var url = Uri.parse(
        "http://192.168.1.105:4002/api/restaurants/create"); //192.168.1.105
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      'restaurant_name': nomRestaurant,
      'address': adresseRestaurant,
      'town': villeRestaurant,
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
        filename: result.files.first.name));

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
          Overlay.of(contextt)!,
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Restaurant Modifié",
          ),
        );
        ref.refresh(getDataRsetaurantFuture);
      } else {
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "Erreur de création",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  /////// - Suppression restaurant
  Future<http.Response> deleteRestaurant(contextt, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      String urlDelete = "http://192.168.1.105:4002/api/restaurants/delete/$id";
      //192.168.1.105

      final http.Response response =
          await http.put(Uri.parse(urlDelete), headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Accept': 'application/json',
        'authorization': 'Bearer $token',
      }, body: {
        '_creator': id
      });

      print(response.statusCode);
      if (response.statusCode == 200) {
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Restaurant supprimé",
          ),
        );
        ref.refresh(getDataRsetaurantFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "Erreur de suppression",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
