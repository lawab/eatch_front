import 'dart:convert';
import 'dart:typed_data';
import 'package:eatch/pages/laboratoire/accuielLabo.dart';
import 'package:eatch/servicesAPI/getFournisseur.dart';
import 'package:eatch/servicesAPI/getLabo.dart';
import 'package:eatch/servicesAPI/getMatiereFini.dart';
import 'package:eatch/servicesAPI/getMatierebrute.dart';
import 'package:eatch/servicesAPI/multipart.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;

class LaboAccueil extends ConsumerStatefulWidget {
  const LaboAccueil({Key? key}) : super(key: key);

  @override
  LaboAccueilState createState() => LaboAccueilState();
}

class LaboAccueilState extends ConsumerState<LaboAccueil> {
  @override
  void initState() {
    rr();
    // TODO: implement initState
    super.initState();
  }

  void rr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('index', 30);
  }

  var nomController = TextEditingController();
  var emailController = TextEditingController();
  var adresseController = TextEditingController();
  var employeController = TextEditingController();
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

  List<String> listLaboratoire = [];
  bool create = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataLaboratoriesFuture);
    return Scaffold(
      backgroundColor: const Color(0xFFF4B012),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            height: 80,
            child: Row(
              children: [
                const SizedBox(
                  width: 50,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(100, 50)),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.backspace),
                  label: const Text('Retour'),
                ),
                Expanded(child: Container()),
                create == true
                    ? Container()
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(180, 50)),
                        onPressed: () async {
                          setState(() {
                            create = true;
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter un Laboratoire'),
                      ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),

          //////////////////
          Container(
            height: MediaQuery.of(context).size.height - 80,
            width: MediaQuery.of(context).size.width - 20,
            alignment: Alignment.center,
            child: Card(
              color: Palette.primaryColor,
              child: create == true
                  ? Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height - 100,
                      width: MediaQuery.of(context).size.width / 2,
                      child: creation(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 100,
                        width: MediaQuery.of(context).size.width / 2,
                        alignment: Alignment.center,
                        child: viewModel.listLabo.isEmpty
                            ? Center(
                                child: Text('PAS DE LABORATOIRE'),
                              )
                            : ListView.builder(
                                itemCount: viewModel.listLabo.length,
                                itemBuilder: ((context, index) {
                                  return InkWell(
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: Column(children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4 -
                                              50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            //color: Colors.white,

                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'http://13.39.81.126:4015${viewModel.listLabo[index].image.toString()}'), //13.39.81.126:4002 //13.39.81.126
                                                //image: AssetImage('Logo_Eatch_png.png'),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: Text(
                                            viewModel.listLabo[index].laboName!,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Palette.yellowColor),
                                          ),
                                        ),
                                      ]),
                                    ),
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'idLabo',
                                          viewModel.listLabo[index].sId
                                              .toString());
                                      prefs.setBool('lab', true);
                                      prefs.setInt('index', 9);
                                      ref.refresh(getDataFournisseurFuture);
                                      ref.refresh(getDataMatiereBruteFuture);
                                      ref.refresh(getDataMatiereFiniFuture);
                                      ref.refresh(getDataLaboratoriesFuture);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AccuilLabo(),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                      ),
                    ),
            ),
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
          color: const Color(0xFFFCEBD1),
          child: Row(
            children: [
              const SizedBox(
                width: 50,
              ),
              const Text('Création de laboratoire'),
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
                labelText: "Nom",
                hintText: "Entrer le nom du laboratoire",
                // If  you are using latest version of flutter then lable text and hint text shown like this
                // if you r using flutter less then 1.20.* then maybe this is not working properly
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: const Icon(Icons.all_out)),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          child: TextFormField(
            controller: emailController,
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
                labelText: "Email",
                hintText: "Entrer l'email du laboratoire",
                // If  you are using latest version of flutter then lable text and hint text shown like this
                // if you r using flutter less then 1.20.* then maybe this is not working properly
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: const Icon(Icons.email)),
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
                labelText: "Adresse",
                hintText: "Entrer l'adresse du laboratoire",
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
                labelText: "Nombre d'employés",
                hintText: "Entrer le nombre d'employés du laboratoire",
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
                  creationLabo(
                    context,
                    nomController.text,
                    emailController.text,
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
                    create = false;
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
    );
  }

  Future<void> creationLabo(
    contextt,
    String nomRestaurant,
    String emailController,
    String adresseRestaurant,
    selectedFile,
    result,
  ) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    var url = Uri.parse(
        "http://13.39.81.126:4015/api/laboratories/create"); //13.39.81.126 // 13.39.81.126 //13.39.81.126
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      'labo_name': nomRestaurant,
      'address': adresseRestaurant,
      'email': emailController,
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
    print('llllllllllllllllllllllllllllllllaaaaaaaaaaaaaaaaaaaaaaaaa');
    print(response.request!.headers);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
          setState(() {
            create = false;
          });
        });
        //stopMessage();
        //finishWorking();

        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Le laboratoire a été créé",
          ),
        );
        ref.refresh(getDataLaboratoriesFuture);
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "Le laboratoire n'a pas été créé",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
