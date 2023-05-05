import 'dart:ui';
import 'package:eatch/servicesAPI/getMatiere.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MatiereAffiche extends ConsumerStatefulWidget {
  const MatiereAffiche({Key? key}) : super(key: key);

  @override
  MatiereAfficheState createState() => MatiereAfficheState();
}

class MatiereAfficheState extends ConsumerState<MatiereAffiche> {
  bool ajout = false;
  var nomController = TextEditingController();
  var stockController = TextEditingController();

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
                color: Color(0xFFFCEBD1),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    Text('Matières premières'),
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
                        /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantCreation()));*/
                      },
                      icon: Icon(Icons.add),
                      label: Text('Ajouter un type de matière'),
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
                        color: Color(0xFFFCEBD1),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 50,
                            ),
                            Text('Création de Type de matière première'),
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
                              labelText: "Nom du type",
                              hintText: "Entrer le nom du type",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: Icon(Icons.food_bank)),
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
                              suffixIcon: Icon(Icons.food_bank)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // --------------------------------------------
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            const Text("Date de péremption"),
                            const SizedBox(width: 6),
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
                                  dateJour =
                                      "${date.year}/${date.month}/${date.day}";
                                });
                                print(date);
                              },
                              child: const Text("Choisir la date:"),
                            ),
                            const SizedBox(width: 10),
                            dd == false
                                ? Text(
                                    "${date.year}/${date.month}/${date.day}",
                                    style: const TextStyle(fontSize: 18),
                                  )
                                : Text(
                                    dateJour,
                                    style: const TextStyle(fontSize: 18),
                                  )
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 50,
                      ),

                      // --------------------------------------------

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
                                backgroundColor:
                                    Palette.secondaryBackgroundColor,
                                minimumSize: Size(150, 50),
                                maximumSize: Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                        image: AssetImage(matiere[index].image!),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        matiere[index].type!,
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Initiale: ${matiere[index].initial.toString()} ${matiere[index].mesure!}',
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        'Consommation: ${matiere[index].consommation.toString()} ${matiere[index].mesure!}',
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        'Reste: ${(matiere[index].initial! - matiere[index].consommation!).toString()} ${matiere[index].mesure!}',
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
                                    matiere[index].type!,
                                    matiere[index].initial!,
                                    matiere[index].mesure!);
                              }),
                              icon: Icon(Icons.edit),
                              label: Text('Modifier'),
                            ),
                            ElevatedButton.icon(
                              onPressed: (() {
                                dialogDelete(matiere[index].type!);
                              }),
                              icon: Icon(Icons.delete),
                              label: Text('Supprimer'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.secondaryColor,
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

  Widget verticalView(
      double height, double width, context, List<Matiere> matiere) {
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
                    Text('Matières premières'),
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
                        /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantCreation()));*/
                      },
                      icon: Icon(Icons.add),
                      label: Text('Ajouter un type de matière'),
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
                        color: Color(0xFFFCEBD1),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 50,
                            ),
                            Text('Création de Type de matière première'),
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
                              labelText: "Nom du type",
                              hintText: "Entrer le nom du type",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: Icon(Icons.food_bank)),
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
                              suffixIcon: Icon(Icons.food_bank)),
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
                                backgroundColor:
                                    Palette.secondaryBackgroundColor,
                                minimumSize: Size(150, 50),
                                maximumSize: Size(200, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                        image: AssetImage(matiere[index].image!),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        matiere[index].type!,
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Initiale: ${matiere[index].initial.toString()} ${matiere[index].mesure!}',
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        'Consommation: ${matiere[index].consommation.toString()} ${matiere[index].mesure!}',
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        'Reste: ${(matiere[index].initial! - matiere[index].consommation!).toString()} ${matiere[index].mesure!}',
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
                                    matiere[index].type!,
                                    matiere[index].initial!,
                                    matiere[index].mesure!);
                              }),
                              icon: Icon(Icons.edit),
                              label: Text('Modifier'),
                            ),
                            ElevatedButton.icon(
                              onPressed: (() {
                                dialogDelete(matiere[index].type!);
                              }),
                              icon: Icon(Icons.delete),
                              label: Text('Supprimer'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.secondaryColor,
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

  Future dialogDelete(String nom) {
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {},
                    label: Text("Supprimer."))
              ],
              content: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  height: 150,
                  child: Text(
                    "Voulez vous supprimer $nom ?",
                    style: TextStyle(
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
                  label: Text("Valider."))
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
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                      padding: EdgeInsets.all(3),
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
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 16,
                              )),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  count.toString(),
                                  style: TextStyle(
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
                              child: Icon(
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
}
