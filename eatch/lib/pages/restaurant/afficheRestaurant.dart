// ignore_for_file: sized_box_for_whitespace

import 'dart:ui';

import 'package:eatch/pages/restaurant/creationRestaurant.dart';
import 'package:eatch/pages/restaurant/modificationRestaurant.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';

class RestaurantAffiche extends StatefulWidget {
  const RestaurantAffiche({Key? key}) : super(key: key);

  @override
  RestaurantAfficheState createState() => RestaurantAfficheState();
}

class RestaurantAfficheState extends State<RestaurantAffiche> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, context) {
    return AppLayout(
        content: Column(
      children: [
        Container(
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantCreation()));
                  /* Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => DashboardManager()),
            (Route<dynamic> route) => false);*/
                },
                icon: Icon(Icons.add),
                label: Text('Créer un restaurant'),
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
            height: height - 175,
            width: width - 20,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 470,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 50,
                    mainAxisExtent: 300),
                itemCount: 2,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
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
                                  //color: Colors.white,
                                  image: DecorationImage(
                                      image: AssetImage('eatch.jpg'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              //Image.asset('eatch.jpg', fit: BoxFit.cover),
                              ClipRRect(
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
                              ),
                              Positioned(
                                top: 5,
                                left: 30,
                                width: width / 5,
                                height: 50,
                                child: Text(
                                  'Nom du restaurant: EATCH',
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
                                  "Ville: Casablanca",
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
                                  "Adresse: boulevard Massira",
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
                                  "Date de création: 10/10/2023",
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

  Widget verticalView(double height, double width, context) {
    return AppLayout(
        content: Column(
      children: [
        Container(
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantCreation()));
                  /* Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => DashboardManager()),
            (Route<dynamic> route) => false);*/
                },
                icon: Icon(Icons.add),
                label: Text('Créer un restaurant'),
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
            height: height - 85,
            width: width - 20,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 450,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 50,
                    mainAxisExtent: 300),
                itemCount: 2,
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
                                  borderRadius: BorderRadius.circular(15.0),
                                  //color: Colors.white,
                                  image: const DecorationImage(
                                      image: AssetImage('Logo_Eatch_png.png'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              //Image.asset('eatch.jpg', fit: BoxFit.cover),
                              ClipRRect(
                                // Clip it cleanly.
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 2, sigmaY: 1),
                                  child: Container(),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                left: 30,
                                width: width / 5,
                                height: 50,
                                child: Text(
                                  'Nom du restaurant: EATCH',
                                  style: TextStyle(
                                      fontFamily: 'Righteous',
                                      fontSize: 15,
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
                                  "Ville: Casablanca",
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
                                  "Adresse: boulevard Massira",
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
                                child: const Text(
                                  "Date de création: 10/10/2023",
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
                  child: const Text(
                    "Voulez vous supprimer le restaurant EATCH ?",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'HelveticaNeue',
                    ),
                  )));
        });
  }
}
