import 'dart:convert';
import 'dart:typed_data';
import 'package:eatch/pages/restaurant/afficheRestaurant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:eatch/servicesAPI/getRestaurant.dart';
import 'package:eatch/servicesAPI/multipart.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RestaurantModification extends ConsumerStatefulWidget {
  Restaurant restaurant;
  RestaurantModification({Key? key, required this.restaurant})
      : super(key: key);

  @override
  RestaurantModificationState createState() => RestaurantModificationState();
}

class RestaurantModificationState
    extends ConsumerState<RestaurantModification> {
  @override
  void initState() {
    donne();
    // TODO: implement initState
    super.initState();
  }

  void donne() {
    setState(() {
      nomController.text = widget.restaurant.restaurantName!;
      villeController.text = widget.restaurant.info!.town!;
      adresseController.text = widget.restaurant.info!.address!;
    });
  }

  var nomController = TextEditingController();
  var villeController = TextEditingController();
  var adresseController = TextEditingController();
  var employeController = TextEditingController();

  List<int> _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  bool filee = false;

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
    return AppLayout(
      content: Container(
        color: Palette.secondaryBackgroundColor,
        child: SingleChildScrollView(
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
                    const Text('Modification de restaurant'),
                    Expanded(child: Container()),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: Size(150, 50)),
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
                      suffixIcon: const Icon(Icons.location_city)),
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
                      suffixIcon: const Icon(Icons.local_activity)),
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
                      suffixIcon: const Icon(Icons.person)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                child: Row(children: [
                  const SizedBox(
                    width: 50,
                  ),
                  Container(
                    height: 100,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        /////////////////////
                        result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
                              "png",
                              "jpg",
                              "jpeg",
                            ]);
                        if (result != null) {
                          file = result!.files.single;

                          Uint8List fileBytes =
                              result!.files.single.bytes as Uint8List;
                          //print(base64Encode(fileBytes));
                          //List<int>
                          _selectedFile = fileBytes;
                          setState(() {
                            filee = true;
                          });
                        } else {
                          setState(() {
                            filee = false;
                          });
                        }
                        ////////////////////
                      },
                      //splashColor: Colors.brown.withOpacity(0.5),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Palette.greenColors,
                          image: DecorationImage(
                              opacity: 100,
                              image: NetworkImage(
                                  'http://13.39.81.126:4002${widget.restaurant.info!.logo.toString()}'),
                              fit: BoxFit.cover),
                        ),
                        child: const Text(
                          "Modifier",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  filee == true
                      ? Container(
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          child: Text(file!.name),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                        ),
                ]),
              ),
              const SizedBox(
                height: 80,
              ),
              ElevatedButton(
                onPressed: (() {
                  modificationRestaurant(
                      context,
                      nomController.text,
                      villeController.text,
                      adresseController.text,
                      _selectedFile,
                      result,
                      widget.restaurant.sId.toString());
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primaryColor,
                  minimumSize: const Size(150, 50),
                  maximumSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Modifier'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> modificationRestaurant(
      contextt,
      String nomRestaurant,
      String villeRestaurant,
      String adresseRestaurant,
      selectedFile,
      result,
      idChoisie) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    var url =
        Uri.parse("http://13.39.81.126:4002/api/restaurants/update/$idChoisie");
    final request = MultipartRequest(
      'PUT',
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
    if (result != null) {
      request.files.add(await http.MultipartFile.fromBytes('file', selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result.files.first.name));
    }

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
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Restaurant Modifié",
          ),
        );
        ref.refresh(getDataRsetaurantFuture);
        Navigator.pop(contextt);
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "Erreur de création",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      throw e;
    }
  }
}
