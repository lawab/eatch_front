import 'dart:convert';
import 'dart:typed_data';

import 'package:eatch/pages/restaurantAccueil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../servicesAPI/getRestaurant.dart';
import '../servicesAPI/multipart.dart';
import '../utils/palettes/palette.dart';
import 'package:http/http.dart' as http;

class CreationRestaurant extends ConsumerStatefulWidget {
  const CreationRestaurant({Key? key}) : super(key: key);

  @override
  CreationRestaurantState createState() => CreationRestaurantState();
}

class CreationRestaurantState extends ConsumerState<CreationRestaurant> {
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
    return Scaffold(
        body: Container(
      color: Palette.secondaryBackgroundColor,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            height: 50,
            color: const Color(0xFFFCEBD1),
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
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
              width: 350,
              child: Row(children: [
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: (() {
                    creationRestaurant(
                      context,
                      nomController.text,
                      villeController.text,
                      adresseController.text,
                      _selectedFile,
                      result,
                    );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RestaurantAccueil(),
                        ),
                      );
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
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    )
        /////////
        );
  }

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
        "http://192.168.1.34:4002/api/restaurants/create"); //13.39.81.126 // 192.168.1.34 //192.168.1.34
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RestaurantAccueil(),
            ),
          );
        });
        //stopMessage();
        //finishWorking();

        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Le restaurant a été crée",
          ),
        );
        ref.refresh(getDataRsetaurantFuture);
      } else {
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "Le restaurant n'a pas été crée",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
