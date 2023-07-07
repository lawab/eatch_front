import 'dart:convert';

import 'package:eatch/servicesAPI/getFournisseur.dart';
import 'package:eatch/servicesAPI/multipart.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;

class FournisseurPage extends ConsumerStatefulWidget {
  const FournisseurPage({Key? key}) : super(key: key);

  @override
  FournisseurPageState createState() => FournisseurPageState();
}

class FournisseurPageState extends ConsumerState<FournisseurPage> {
  var firstNameController = TextEditingController();
  var lasttNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var adressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<int> _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  bool filee = false;
  Uint8List? selectedImageInBytes;
  bool _selectFile = false;
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
    final viewModel = ref.watch(getDataFournisseurFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listFournisseur);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listFournisseur);
          }
        },
      ),
    );
  }

  bool modif = false;
  Widget horizontalView(double height, double width, contextt,
      List<Fournisseur> fournisseurLIST) {
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
                  const Text('Fournisseurs'),
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
              height: height - 300,
              child: fournisseurLIST.isEmpty
                  ? const Center(
                      child: Text(
                        "Aucun fournisseur",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  : ListView.builder(
                      itemCount: fournisseurLIST.length,
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
                                      flex: 1,
                                      child: Container(
                                          height: 100,
                                          alignment: Alignment.center,
                                          child: Image.network(
                                            'http://13.39.81.126:4015${fournisseurLIST[index].image}',
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.black,
                                                child: const Center(
                                                  child: Text(
                                                    "Pas d'image",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              );
                                            },
                                          )),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                            '${fournisseurLIST[index].firstName!} ${fournisseurLIST[index].lastName!}'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
                                        maxRadius: 20,
                                        backgroundColor: Colors.black,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              modif = true;
                                              firstNameController.text =
                                                  fournisseurLIST[index]
                                                      .firstName!;
                                              lasttNameController.text =
                                                  fournisseurLIST[index]
                                                      .lastName!;
                                              emailController.text =
                                                  fournisseurLIST[index].email!;
                                              adressController.text =
                                                  fournisseurLIST[index]
                                                      .adresse!;
                                              phoneController.text =
                                                  fournisseurLIST[index].phone!;
                                            });
                                            dialog(context,
                                                fournisseurLIST[index].sId!);
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
                                        maxRadius: 20,
                                        backgroundColor: Colors.red,
                                        child: IconButton(
                                            onPressed: () {
                                              dialogDelete(
                                                  context,
                                                  fournisseurLIST[index].sId!,
                                                  fournisseurLIST[index]
                                                      .firstName!);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                //dialogSortie(context);
                              },
                            ));
                      }),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: (() {
                  dialog(contextt, '');
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primaryColor,
                  minimumSize: const Size(150, 50),
                  maximumSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(Icons.add),
                label: const Text('Ajouter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, contextt,
      List<Fournisseur> fournisseurLIST) {
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
                  const Text('Fournisseurs'),
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
              height: height - 242,
              child: fournisseurLIST.isEmpty
                  ? const Center(
                      child: Text(
                        "Aucun fournisseur",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  : ListView.builder(
                      itemCount: fournisseurLIST.length,
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
                                      flex: 1,
                                      child: Container(
                                          height: 100,
                                          alignment: Alignment.center,
                                          child: Image.network(
                                            'http://13.39.81.126:4015${fournisseurLIST[index].image}',
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.black,
                                                child: const Center(
                                                  child: Text(
                                                    "Pas d'image",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              );
                                            },
                                          )),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                            '${fournisseurLIST[index].firstName!} ${fournisseurLIST[index].lastName!}'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
                                        maxRadius: 20,
                                        backgroundColor: Colors.black,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              modif = true;
                                              firstNameController.text =
                                                  fournisseurLIST[index]
                                                      .firstName!;
                                              lasttNameController.text =
                                                  fournisseurLIST[index]
                                                      .lastName!;
                                              emailController.text =
                                                  fournisseurLIST[index].email!;
                                              adressController.text =
                                                  fournisseurLIST[index]
                                                      .adresse!;
                                              phoneController.text =
                                                  fournisseurLIST[index].phone!;
                                            });
                                            dialog(context,
                                                fournisseurLIST[index].sId!);
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
                                        maxRadius: 20,
                                        backgroundColor: Colors.red,
                                        child: IconButton(
                                            onPressed: () {
                                              dialogDelete(
                                                  context,
                                                  fournisseurLIST[index].sId!,
                                                  fournisseurLIST[index]
                                                      .firstName!);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                //dialogSortie(context);
                              },
                            ));
                      }),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: (() {
                  dialog(contextt, '');
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primaryColor,
                  minimumSize: const Size(150, 50),
                  maximumSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(Icons.add),
                label: const Text('Ajouter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future dialog(BuildContext contextt, String id) {
    return showDialog(
      context: contextt,
      builder: (co) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              modif == true ? " MODIFICATION FOURNISSEUR" : "FOURNISSEUR",
              style: const TextStyle(
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
                  setState(() {
                    modif == false;
                    firstNameController.clear();
                    lasttNameController.clear();
                    emailController.clear();
                    adressController.clear();
                    phoneController.clear();
                  });
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Quitter.")),
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
                  modif == true
                      ? modificationFournisseur(
                          contextt,
                          firstNameController.text,
                          lasttNameController.text,
                          emailController.text,
                          adressController.text,
                          phoneController.text,
                          _selectedFile,
                          result,
                          id,
                        )
                      : creationFournisseur(
                          contextt,
                          firstNameController.text,
                          lasttNameController.text,
                          emailController.text,
                          adressController.text,
                          phoneController.text,
                          _selectedFile,
                          result);
                  Navigator.pop(co);
                },
                label: const Text("Enregistrer."))
          ],
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 410,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextFormField(
                      controller: firstNameController,
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
                          labelText: "Nom",
                          hintText: "Nom du fornisseur",
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const Icon(Icons.title)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextFormField(
                      controller: lasttNameController,
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
                          labelText: "Prénom",
                          hintText: "Prénom du fornisseur",
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const Icon(Icons.title)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextFormField(
                      controller: emailController,
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
                          labelText: "Email",
                          hintText: "Email du fornisseur",
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const Icon(Icons.mail)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextFormField(
                      controller: adressController,
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
                          labelText: "Adresse",
                          hintText: "Adresse du fornisseur",
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const Icon(Icons.title)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 70),
                    color: Palette.secondaryBackgroundColor,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
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
                    height: 20,
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
                  deleteFournisseur(contextt, id);
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
                child: Text('Voulez vous supprimer le fournisseur $nom?'));
          }),
        );
      },
    );
  }

/////////////////////////////////////////////////////////////////////////////////////SERVICES
  Future<void> creationFournisseur(
    contextt,
    String nomfournisseur,
    String prenomfournisseur,
    String email,
    String adresse,
    String phone,
    selectedFile,
    result,
  ) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var idLabo = prefs.getString('idLabo');

    var url = Uri.parse(
        "http://13.39.81.126:4015/api/providers/create"); //13.39.81.126 // 13.39.81.126 //13.39.81.126
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      'firstName': nomfournisseur,
      'lastName': prenomfournisseur,
      'email': email,
      'phone': phone,
      'adresse': adresse,
      'laboratorId': idLabo,
      '_creator': id,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    if (result != null) {
      request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result.files.first.name));
    }

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
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Le fournisseur a été crée",
          ),
        );

        ref.refresh(getDataFournisseurFuture);
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
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

  Future<void> modificationFournisseur(
      contextt,
      String nomfournisseur,
      String prenomfournisseur,
      String email,
      String adresse,
      String phone,
      selectedFile,
      result,
      idChoisie) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    //String adress_url = prefs.getString('ipport').toString();
    var idLabo = prefs.getString('idLabo');

    var url = Uri.parse(
        "http://13.39.81.126:4015/api/providers/update/$idChoisie"); //13.39.81.126
    final request = MultipartRequest(
      'PATCH',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      'firstName': nomfournisseur,
      'lastName': prenomfournisseur,
      'email': email,
      'phone': phone,
      'adresse': adresse,
      'laboratorId': idLabo,
      '_creator': id,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    if (result != null) {
      request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result.files.first.name));
    }

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
        setState(() {
          modif == false;
          firstNameController.clear();
          lasttNameController.clear();
          emailController.clear();
          adressController.clear();
          phoneController.clear();
        });
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Fournisseur Modifié",
          ),
        );
        ref.refresh(getDataFournisseurFuture);
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
      rethrow;
    }
  }

  Future<http.Response> deleteFournisseur(contextt, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      String urlDelete = "http://13.39.81.126:4015/api/providers/delete/$id";
      //13.39.81.126

      final http.Response response =
          await http.patch(Uri.parse(urlDelete), headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Accept': 'application/json',
        'authorization': 'Bearer $token',
      }, body: {
        '_creator': id
      });

      print(response.statusCode);
      if (response.statusCode == 200) {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Fournisseur supprimé",
          ),
        );
        ref.refresh(getDataFournisseurFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
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
