// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:eatch/servicesAPI/getFournisseur.dart';
import 'package:eatch/servicesAPI/getMatierebrute.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:eatch/servicesAPI/multipart.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MatiereBrutee extends ConsumerStatefulWidget {
  const MatiereBrutee({Key? key}) : super(key: key);

  @override
  MatiereBruteeState createState() => MatiereBruteeState();
}

class MatiereBruteeState extends ConsumerState<MatiereBrutee> {
  // Text editing controller
  int count = 1;
  var nombrecontrol = TextEditingController();
  final titleController = TextEditingController();
  final quantiteController = TextEditingController();
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
  ///////////////
  List<int> _selectedFile1 = [];
  FilePickerResult? result1;
  PlatformFile? file1;
  bool filee1 = false;
  Uint8List? selectedImageInBytes1;
  bool _selectFile1 = false;
  ///////////////
  List<String> listOfUnite = ["Unité *", "kg", "litre", "Carton"];

  String? unite;
  String? fournisseur;
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

  bool ajoutbrute = false;
  bool ajoutfourni = false;
  bool modif = false;
  String idBrute = "";
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataFournisseurFuture);
    final viewModell = ref.watch(getDataMatiereBruteFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listFournisseur, viewModell.listMatiereBrute);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listFournisseur, viewModell.listMatiereBrute);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, contextt,
      List<Fournisseur> fournisseurr, List<MatiereBrute> listMatiereBrute) {
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
                      const Text('Approvisionnement'),
                      Expanded(child: Container()),
                      ajoutbrute == true
                          ? ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minimumSize: const Size(180, 50)),
                              onPressed: () {
                                if (modif == false) {
                                  setState(() {
                                    ajoutbrute = false;
                                    modif = false;
                                  });
                                } else {
                                  setState(() {
                                    idBrute = '';
                                    titleController.clear();
                                    quantiteController.clear();
                                    idFournisseur = '';
                                    fournisseur = listfournisseurrr.first;
                                    unite = listOfUnite.first;
                                    image = '';
                                    modif = false;

                                    ajoutbrute = false;
                                  });
                                }
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
                                  ajoutbrute = true;
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
                ajoutbrute == true
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
                ajoutbrute == true
                    ? Container(
                        child: creation(fournisseurr, idBrute),
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
                            itemCount: listMatiereBrute.length,
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
                                        /*decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('emballage.jpeg'),
                                          ),
                                        ),*/
                                        child: Image.network(
                                          "http://13.39.81.126:4015${listMatiereBrute[index].image}",
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
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Text(
                                          'Nom : ${listMatiereBrute[index].title}'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'Quantité : ${listMatiereBrute[index].available} ${listMatiereBrute[index].unit}'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'Dernière date : ${listMatiereBrute[index].updatedAt}'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'Date de création : ${listMatiereBrute[index].createdAt}'),
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
                                                  onPressed: () {
                                                    setState(() {
                                                      idBrute =
                                                          listMatiereBrute[
                                                                  index]
                                                              .sId!;
                                                      titleController.text =
                                                          listMatiereBrute[
                                                                  index]
                                                              .title!;
                                                      quantiteController.text =
                                                          listMatiereBrute[
                                                                  index]
                                                              .available
                                                              .toString();
                                                      idFournisseur =
                                                          listMatiereBrute[
                                                                  index]
                                                              .provider!;
                                                      unite = listMatiereBrute[
                                                              index]
                                                          .unit!;
                                                      image = listMatiereBrute[
                                                              index]
                                                          .image!;
                                                      modif = true;
                                                      ajoutbrute = true;
                                                    });
                                                  },
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
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        shape: BoxShape.circle),
                                                    child: IconButton(
                                                      splashColor:
                                                          Palette.greenColors,
                                                      onPressed: () {
                                                        dialogAjout(
                                                            contextt,
                                                            listMatiereBrute[
                                                                    index]
                                                                .available!,
                                                            listMatiereBrute[
                                                                    index]
                                                                .title!,
                                                            listMatiereBrute[
                                                                    index]
                                                                .unit!,
                                                            listMatiereBrute[
                                                                    index]
                                                                .sId!,
                                                            listMatiereBrute[
                                                                    index]
                                                                .provider!);
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
                                                      listMatiereBrute[index]
                                                          .sId!,
                                                      listMatiereBrute[index]
                                                          .title!,
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 30,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, contextt,
      List<Fournisseur> fournisseurr, List<MatiereBrute> listMatiereBrute) {
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
                      const Text('Approvisionnement'),
                      Expanded(child: Container()),
                      ajoutbrute == true
                          ? ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minimumSize: const Size(180, 40)),
                              onPressed: () {
                                if (modif == false) {
                                  setState(() {
                                    ajoutbrute = false;
                                    modif = false;
                                  });
                                } else {
                                  setState(() {
                                    idBrute = '';
                                    titleController.clear();
                                    quantiteController.clear();
                                    idFournisseur = '';
                                    fournisseur = listfournisseurrr.first;
                                    unite = listOfUnite.first;
                                    image = '';
                                    modif = false;

                                    ajoutbrute = false;
                                  });
                                }
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
                                  ajoutbrute = true;
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
                ajoutbrute == true
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
                ajoutbrute == true
                    ? Container(
                        height: height - 232,
                        child: creation(fournisseurr, ''),
                      )
                    : Container(
                        height: height - 232,
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 50,
                                    mainAxisExtent: 380),
                            itemCount: listMatiereBrute.length,
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
                                        /*decoration:  BoxDecoration(
                                          image:
                                        ),*/
                                        child: Image.network(
                                          "http://13.39.81.126:4015${listMatiereBrute[index].image}",
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
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Text(
                                        'Nom : ${listMatiereBrute[index].title}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Quantité : ${listMatiereBrute[index].available} ${listMatiereBrute[index].unit}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Dernière date : ${listMatiereBrute[index].updatedAt}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Date de création : ${listMatiereBrute[index].createdAt}',
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
                                                  onPressed: () {
                                                    setState(() {
                                                      idBrute =
                                                          listMatiereBrute[
                                                                  index]
                                                              .sId!;
                                                      titleController.text =
                                                          listMatiereBrute[
                                                                  index]
                                                              .title!;
                                                      quantiteController.text =
                                                          listMatiereBrute[
                                                                  index]
                                                              .available
                                                              .toString();
                                                      idFournisseur =
                                                          listMatiereBrute[
                                                                  index]
                                                              .provider!;
                                                      unite = listMatiereBrute[
                                                              index]
                                                          .unit!;
                                                      image = listMatiereBrute[
                                                              index]
                                                          .image!;
                                                      modif = true;
                                                      ajoutbrute = true;
                                                    });
                                                  },
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
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        shape: BoxShape.circle),
                                                    child: IconButton(
                                                      splashColor:
                                                          Palette.greenColors,
                                                      onPressed: () {
                                                        dialogAjout(
                                                            contextt,
                                                            listMatiereBrute[
                                                                    index]
                                                                .available!,
                                                            listMatiereBrute[
                                                                    index]
                                                                .title!,
                                                            listMatiereBrute[
                                                                    index]
                                                                .unit!,
                                                            listMatiereBrute[
                                                                    index]
                                                                .sId!,
                                                            listMatiereBrute[
                                                                    index]
                                                                .provider!);
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
                                                      listMatiereBrute[index]
                                                          .sId!,
                                                      listMatiereBrute[index]
                                                          .title!,
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 30,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String image = '';
  bool vertical = false;
  var idFournisseur = '';
  List<String> listfournisseurrr = ['Fournisseur *'];
  Widget creation(
    List<Fournisseur> fournisseurLIST,
    String id,
  ) {
    for (int i = 0; i < fournisseurLIST.length; i++) {
      listfournisseurrr.add(
          '${fournisseurLIST[i].firstName!} ${fournisseurLIST[i].lastName!}');
      if (modif == true) {
        if (idFournisseur == fournisseurLIST[i].sId) {
          fournisseur =
              '${fournisseurLIST[i].firstName!} ${fournisseurLIST[i].lastName!}';
        }
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: vertical == false
                ? MediaQuery.of(context).size.width / 4
                : MediaQuery.of(context).size.width - 100,
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: DropdownButtonFormField(
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
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    value: fournisseur,
                    hint: const Text(
                      'Fournisseur*',
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        fournisseur = value;
                        for (int i = 0; i < fournisseurLIST.length; i++) {
                          if (fournisseur ==
                              '${fournisseurLIST[i].firstName!} ${fournisseurLIST[i].lastName!}') {
                            idFournisseur = fournisseurLIST[i].sId!;
                          }
                        }
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        fournisseur = value;
                      });
                    },
                    validator: (String? value) {
                      if (value == null) {
                        return "Le fournisseur est obligatoire.";
                      } else {
                        return null;
                      }
                    },
                    items: listfournisseurrr.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.yellowColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(50, 60)),
                      onPressed: () async {
                        dialogFournisseur(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Fournisseur'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: vertical == false ? 50 : 20,
          ),
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
                        labelText: "Quantité",
                        hintText: "Inscrire la quantité",
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
                  items: listOfUnite.map((String val) {
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
          const SizedBox(
            height: 20,
          ),
          modif == true
              ? Container(
                  width: vertical == false
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width - 100,
                  padding: const EdgeInsets.only(right: 70),
                  color: Palette.secondaryBackgroundColor,
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 100,
                    width: 100,
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
                            _selectFile = true;
                            selectedImageInBytes = result!.files.first.bytes;
                          });
                        } else {
                          setState(() {
                            _selectFile = false;
                          });
                        }
                        ////////////////////
                      },
                      //splashColor: Colors.brown.withOpacity(0.5),
                      child: _selectFile == true
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Palette.violetColor,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: MemoryImage(
                                      selectedImageInBytes!,
                                      //fit: BoxFit.fill,
                                    ),
                                  )),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Palette.violetColor,
                                size: 40,
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Palette.greenColors,
                                ),
                              ),
                              child: Image.network(
                                  'http://13.39.81.126:4015$image'),
                            ),
                    ),
                  ),
                )
              : Container(
                  width: vertical == false
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width - 100,
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
                    if (idFournisseur != '') {
                      if (modif == false) {
                        creationMatiereBrute(
                          context,
                          titleController.text,
                          quantiteController.text,
                          idFournisseur,
                          unite!,
                          _selectedFile1,
                          result1,
                        );
                      } else {
                        modificationBrute(
                          context,
                          titleController.text,
                          quantiteController.text,
                          idFournisseur,
                          unite!,
                          _selectedFile,
                          result,
                          id,
                        );
                      }
                    } else {
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.info(
                          backgroundColor: Colors.amber,
                          message: "Veuillez choisir le fournisseur ",
                        ),
                      );
                    }
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
                    if (modif == false) {
                      setState(() {
                        ajoutbrute = false;
                        modif = false;
                      });
                    } else {
                      setState(() {
                        idBrute = '';
                        titleController.clear();
                        quantiteController.clear();
                        idFournisseur = '';
                        fournisseur = listfournisseurrr.first;
                        unite = listOfUnite.first;
                        image = '';
                        modif = false;

                        ajoutbrute = false;
                      });
                    }
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
        ],
      ),
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
                  deleteMatiereBrute(contextt, id);
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
              child: Text('Voulez vous supprimer  $nom?'),
            );
          }),
        );
      },
    );
  }

  Future dialogFournisseur(BuildContext contextt) {
    return showDialog(
      context: contextt,
      builder: (co) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Ajout de fournisseur",
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
                  creationFournisseur(
                      context,
                      firstNameController.text,
                      lasttNameController.text,
                      emailController.text,
                      adressController.text,
                      phoneController.text,
                      _selectedFile,
                      result);
                  Navigator.pop(co);
                },
                label: const Text("Valider."))
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
                    width: MediaQuery.of(context).size.width / 4,
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
                    width: MediaQuery.of(context).size.width / 4,
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
                    width: MediaQuery.of(context).size.width / 4,
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
                    width: MediaQuery.of(context).size.width / 4,
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

  Future dialogAjout(BuildContext contextt, int quantite, String titre,
      String unit, String rawId, String providerId) {
    nombrecontrol.text = 1.toString();
    return showDialog(
      context: contextt,
      builder: (co) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Ajout de matière",
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
                ajoutMatiereBrute(
                    contextt, rawId, providerId, nombrecontrol.text);
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
              height: 170,
              child: Column(
                children: [
                  Text(
                    'Type : $titre',
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
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> creationMatiereBrute(
    contextt,
    String titre,
    String gram,
    String provider,
    String unit,
    selectedFile,
    result,
  ) async {
    ////////////
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var idLabo = prefs.getString('idLabo');

    var url = Uri.parse(
        "http://13.39.81.126:4015/api/raws/create"); //13.39.81.126 // 13.39.81.126 //13.39.81.126
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      'title': titre,
      'available': gram,
      'unit': unit,
      'laboratoryId': idLabo,
      'providerId': provider,
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
        setState(() {
          ajoutbrute = false;
        });
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "La matière a été crée",
          ),
        );

        ref.refresh(getDataMatiereBruteFuture);
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "La matière n'a pas été crée",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> modificationBrute(
      contextt,
      String titre,
      String gram,
      String provider,
      String unit,
      selectedFile,
      result,
      String idUpdate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var idLabo = prefs.getString('idLabo');
    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:4015/api/raws/update/$idUpdate");
    final request = MultipartRequest(
      'PATCH',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    print(url);
    var json = {
      'title': titre,
      'available': gram,
      'unit': unit,
      'laboratoryId': idLabo,
      'providerId': provider,
      '_creator': id,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });
    request.headers['authorization'] = 'Bearer $token';
    if (result != null) {
      request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result.files.first.name));
    }
    print("RESPENSE SEND STEAM FILE REQ");
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
          idBrute = '';
          titleController.clear();
          quantiteController.clear();
          idFournisseur = '';
          fournisseur = listfournisseurrr.first;
          unite = listOfUnite.first;
          image = '';
          modif = false;

          ajoutbrute = false;
        });
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "La matière a été modifié",
          ),
        );

        ref.refresh(getDataMatiereBruteFuture);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de modification",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> ajoutMatiereBrute(
    contextt,
    String rawId,
    String providerId,
    String qte,
  ) async {
    ////////////
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var idLabo = prefs.getString('idLabo');

    var url = Uri.parse(
        "http://13.39.81.126:4015/api/laboratories/updateProviding"); //13.39.81.126 // 13.39.81.126 //13.39.81.126
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
      'rawId': rawId,
      'laboratoryId': idLabo,
      'providerId': providerId,
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
        setState(() {
          ajoutbrute = false;
        });
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "La matière a été crée",
          ),
        );

        ref.refresh(getDataMatiereBruteFuture);
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "La matière n'a pas été crée",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

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

  Future<http.Response> deleteMatiereBrute(contextt, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      //String adress_url = prefs.getString('ipport').toString();
      String urlDelete = "http://13.39.81.126:4015/api/raws/delete/$id";
      print(urlDelete);
      final http.Response response = await http.patch(
        Uri.parse(urlDelete),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Matière brute supprimée",
          ),
        );
        // ignore: unused_result
        ref.refresh(getDataMatiereBruteFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.error(
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
