import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:eatch/pages/restaurant/modificationRestaurant.dart';
import 'package:eatch/servicesAPI/getRestaurant.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as h;
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class RestaurantAffiche extends ConsumerStatefulWidget {
  const RestaurantAffiche({Key? key}) : super(key: key);

  @override
  RestaurantAfficheState createState() => RestaurantAfficheState();
}

class RestaurantAfficheState extends ConsumerState<RestaurantAffiche> {
  var nomController = TextEditingController();
  var villeController = TextEditingController();
  var adresseController = TextEditingController();
  var employeController = TextEditingController();
  bool ajout = false;

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
                  alignment: Alignment.centerRight,
                  height: 80,
                  color: Color(0xFFFCEBD1),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      Text('Gestion de restaurant'),
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(180, 50)),
                        onPressed: () {
                          setState(() {
                            ajout = true;
                          });
                        },
                        icon: Icon(Icons.add),
                        label: Text('Créer un restaurant'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                )
              : Container(
                  height: 400,
                  child: creation(),
                ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: ajout == false ? height - 175 : height - 495,
            width: width - 20,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 470,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 50,
                    mainAxisExtent: 355),
                itemCount: listRsetaurant.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    height: height,
                    decoration: BoxDecoration(
                      color: Color(0xFF1E9647),
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
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.black,
                                  image: DecorationImage(
                                      opacity: 100,

                                      /*image: NetworkImage(
                                          'http://13.39.81.126:4002${listRsetaurant[index].info!.logo.toString()}'),*/
                                      image: AssetImage('eatch.jpg'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              //Image.asset('eatch.jpg', fit: BoxFit.cover),
                              /*ClipRRect(
                                // Clip it cleanly.
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: Container(
                                      /*color: Colors.grey.withOpacity(0.1),
                                    alignment: Alignment.center,
                                    child: Text('CHOCOLATE'),*/
                                      ),
                                ),
                              ),*/
                              Positioned(
                                top: 5,
                                left: 30,
                                width: width / 5,
                                height: 50,
                                child: Text(
                                  'Nom du restaurant: ${listRsetaurant[index].restaurantName!}',
                                  style: TextStyle(
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
                                  "Ville: ${listRsetaurant[index].info!.town!}",
                                  style: TextStyle(
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
                                  "Adresse: ${listRsetaurant[index].info!.address!}",
                                  style: TextStyle(
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
                                child: Text(
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
                                  style: TextStyle(
                                    fontFamily: 'Righteous',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
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
                                                RestaurantModification()));
                                  }),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Color(0xFFF09F1B),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: (() {
                                    dialogDelete();
                                  }),
                                  icon: Icon(
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
                  );
                }),
          ),
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
                color: Color(0xFFFCEBD1),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    Text('Gestion de restaurant'),
                    Expanded(child: Container()),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        setState(() {
                          ajout = true;
                        });
                      },
                      icon: Icon(Icons.add),
                      label: Text('Créer un restaurant'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              )
            : Container(
                height: 300,
                child: creation(),
              ),
        const SizedBox(
          height: 5,
        ),
        Container(
            height: ajout == false ? height - 245 : height - 465,
            width: width - 20,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 450,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 50,
                    mainAxisExtent: 300),
                itemCount: listRsetaurant.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
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
                                      opacity: 100,
                                      /*image: NetworkImage(
                                          'http://13.39.81.126:4002${listRsetaurant[index].info!.logo.toString()}'),*/
                                      image: AssetImage('Logo_Eatch_png.png'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              //Image.asset('eatch.jpg', fit: BoxFit.cover),
                              /*ClipRRect(
                                // Clip it cleanly.
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 2, sigmaY: 1),
                                  child: Container(),
                                ),
                              ),*/
                              Positioned(
                                top: 5,
                                left: 30,
                                width: width / 5,
                                height: 50,
                                child: Text(
                                  'Nom du restaurant: ${listRsetaurant[index].restaurantName!}',
                                  style: TextStyle(
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
                                  "Ville: ${listRsetaurant[index].info!.town!}",
                                  style: TextStyle(
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
                                  "Adresse: ${listRsetaurant[index].info!.address!}",
                                  style: TextStyle(
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
                                  style: TextStyle(
                                    fontFamily: 'Righteous',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
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
                                                  RestaurantModification()));
                                    }),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Color(0xFFF09F1B),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: (() {
                                      dialogDelete();
                                    }),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Color(0xFFF09F1B),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  );
                })),
      ],
    ));
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
              color: Color(0xFFFCEBD1),
              child: Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  Text('Création de restaurant'),
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
                    labelText: "Nom",
                    hintText: "Entrer le nom du restaurant",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.food_bank)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
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
                    suffixIcon: Icon(Icons.location_city)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
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
                    suffixIcon: Icon(Icons.local_activity)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
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
                    suffixIcon: Icon(Icons.person)),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text(
                  "Vous devriez joindre une image du restaurant lors de l'enregistrement"),
            ),
            const SizedBox(
              height: 5,
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
                      /* creationRestaurant(nomController.text,
                          villeController.text, adresseController.text);*/
                      setState(() {
                        ajout = false;
                      });
                    }),
                    child: Text('Enregistrer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primaryColor,
                      minimumSize: Size(150, 50),
                      maximumSize: Size(200, 70),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
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
                    child: Text(
                      'Annuler',
                      style: TextStyle(color: Colors.grey),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.secondaryBackgroundColor,
                      minimumSize: Size(150, 50),
                      maximumSize: Size(200, 70),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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

  Future dialogDelete() {
    return showDialog(
        context: context,
        builder: (_) {
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
                  label: Text("Quitter   ")),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                  icon: const Icon(
                    Icons.delete,
                    size: 14,
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {},
                  label: Text("Supprimer."))
            ],
            content: Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 150,
              child: const Text(
                "Voulez vous supprimer le restaurant EATCH ?",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ),
          );
        });
  }

  /*Future<void> creationRestaurant(
    String nomRestaurant,
    String villeRestaurant,
    String adresseRestaurant,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    try {
      /////file picker
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: [
        "png",
        "jpg",
        "jpeg",
      ]);
      PlatformFile file = result!.files.single;
      //print(result.files.single.bytes);

      /*print(file.name);
    print(file.extension);*/

      Uint8List? fileBytes;
      if ((result.files.single.bytes ?? []).isEmpty) {
        // Speciale Android

        print('Speciale Android');

        final file = File.fromUri(Uri.parse(result.files.single.path!));
        fileBytes = file.readAsBytesSync();
      } else {
        // Speciale web

        print('Speciale web');
        fileBytes = result.files.single.bytes as Uint8List;
      }

      List<int> selectedFile = fileBytes as List<int>;

      ///[1] CREATING INSTANCE
      var dioRequest = dio.Dio();
      dioRequest.options.baseUrl =
          'http://13.39.81.126:4002/api/restaurant/create';

      //[2] ADDING TOKEN
      dioRequest.options.headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded'
      };

      //[3] ADDING EXTRA INFO
      var formData = dio.FormData.fromMap({
        'restaurant_name': nomRestaurant,
        'address': adresseRestaurant,
        'town': villeRestaurant,
        '_creator': id,
      });
      print(file.name);

      //[4] ADD IMAGE TO UPLOAD
      /*var file = await dio.MultipartFile.fromBytes(value) .fromFile(image.path,
          filename: basename(image.path),
        contentType: MediaType("image", basename(image.path)));*/
      var filet = await dio.MultipartFile.fromBytes(selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result.files.first.name);

      formData.files.add(MapEntry('image', filet));

      //[5] SEND TO SERVER
      var response = await dioRequest.post(
        'http://13.39.81.126:4002/api/restaurant/create',
        data: formData,
      );
      print(response.statusCode);
      final resultt = json.decode(response.toString())['result'];
    } catch (err) {
      print('ERROR  $err');
    }
  }

  Future<void> creationRestaurant(
    String nomRestaurant,
    String villeRestaurant,
    String adresseRestaurant,
  ) async {
    ////////////
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      "png",
      "jpg",
      "jpeg",
    ]);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var nom_file = '';

    if (result != null) {
      PlatformFile file = result.files.single;
      //print(result.files.single.bytes);

      /*print(file.name);
    print(file.extension);*/

      Uint8List? fileBytes;
      if ((result.files.single.bytes ?? []).isEmpty) {
        // Speciale Android

        print('Speciale Android');

        final file = File.fromUri(Uri.parse(result.files.single.path!));
        fileBytes = file.readAsBytesSync();
      } else {
        // Speciale web

        print('Speciale web');
        fileBytes = result.files.single.bytes as Uint8List;
      }

      List<int> selectedFile = fileBytes as List<int>;

      var url = Uri.parse("http://13.39.81.126:4002/api/restaurant/create");
      final request = http.MultipartRequest(
        'POST',
        url,
        /*onProgress: (int bytes, int total) {
          final progress = bytes / total;
          print('progress: $progress ($bytes/$total)');
        },*/
      );

      //var date = DateTime.parse(DateTime.now().toString());

      /*request.headers.addAll({
        "nom_image_salle": nom_image,
        "date_image": 'date',
      });*/

      request.fields['restaurant_name'] = nomRestaurant;
      request.fields['address'] = adresseRestaurant;
      request.fields['town'] = villeRestaurant;
      request.fields['_creator'] = id;
      request.headers['authorization'] = 'Bearer $token';
      //request.headers['content-type'] = 'application/x-www-form-urlencoded';
      request.fields['form_key'] = 'form_value';
      request.headers
          .addAll({'content-type': 'application/x-www-form-urlencoded'});
      request.files.add(await http.MultipartFile.fromBytes(
          'image', selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result.files.first.name));

      print("RESPENSE SEND STEAM FILE REQ");
      //var responseString = await streamedResponse.stream.bytesToString();
      var response = await request.send();
      print("Upload Response" + response.toString());
      print(response.statusCode);
      print(request.headers);
      print(request.fields);

      try {
        if (response.statusCode == 200 || response.statusCode == 201) {
          await response.stream.bytesToString().then((value) {
            print(value);
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Image Téléchager"),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Erreur de serveur"),
          ));
          print("Error Create Programme  !!!");
        }
      } catch (e) {
        throw e;
      }
    }
  }
  Future<void> creationRestaurant(
    String nomRestaurant,
    String villeRestaurant,
    String adresseRestaurant,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    // Créer un objet FormData
    var formData = h.FormData();

    // Ajouter les données du formulaire
    print(id);
    formData.append('restaurant_name', nomRestaurant);
    formData.append('address', adresseRestaurant);
    formData.append('town', villeRestaurant);
    formData.append('_creator', id);

    // Ajouter un fichier
    h.FileUploadInputElement fileInput = h.FileUploadInputElement();
    fileInput.click();
    await fileInput.onChange.first;
    List<h.File> files = fileInput.files!;
    if (files.isNotEmpty) {
      formData.appendBlob('file', files.first);
    }
    print(files.first);
    // Envoyer la requête
    var request = h.HttpRequest();

    request.open(
      'POST',
      'http://13.39.81.126:4002/api/restaurant/create',
    );
    request.setRequestHeader('authorization', 'Bearer $token');
    request.setRequestHeader('enctype', "multipart/form-data");

    request.send(formData);

    // Traiter la réponse
    await request.onLoadEnd.first;
    print(request.status);
    if (request.status == 200) {
      print('Requête réussie !');
    } else {
      print('Erreur ${request.status} : ${request.statusText}');
    }
    ref.refresh(getDataRsetaurantFuture);
  }
}*/
}