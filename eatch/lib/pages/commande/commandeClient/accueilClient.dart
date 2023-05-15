import 'package:eatch/pages/commande/commandeClient/accueilMenu.dart';
import 'package:eatch/pages/commande/commandeClient/menuu.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientAccueil extends StatefulWidget {
  const ClientAccueil({Key? key}) : super(key: key);

  @override
  ClientAccueilState createState() => ClientAccueilState();
}

class ClientAccueilState extends State<ClientAccueil> {
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
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              opacity: 150,
              image: AssetImage('Eatch.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned(
                left: 50,
                width: 300,
                height: 150,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage('logo_vert.png'))),
                ),
              ),
              Positioned(
                bottom: 100,
                left: 100,
                width: 500,
                height: 250,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Eatch",
                                style: TextStyle(
                                    fontFamily: 'Boogaloo',
                                    fontSize: 60,
                                    color: Palette.yellowColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    " propose des tacos francais uniques et délicieux",
                                style: TextStyle(
                                    fontFamily: 'Boogaloo',
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Text(
                          'ainsi que des salades fraîches et savoureuses le tout agrémenté de sauces élaborées avec soin',
                          style: TextStyle(
                              fontFamily: 'Allerta',
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 500,
                        child: Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                'Qui sommes nous',
                                style: TextStyle(
                                    fontFamily: 'Boogaloo',
                                    fontSize: 20,
                                    color: Palette.greenColors,
                                    fontWeight: FontWeight.normal),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.yellowColor,
                                  minimumSize: Size(180, 50)),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                'Voir notre carte',
                                style: TextStyle(
                                    fontFamily: 'Boogaloo',
                                    fontSize: 20,
                                    color: Palette.yellowColor,
                                    fontWeight: FontWeight.normal),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.greenColors,
                                  minimumSize: Size(180, 50)),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt('panier', 0);
                                prefs.setString('panierCommande', 'null');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MenuAccueil()));
                              },
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget verticalView(double height, double width, context) {
    return Scaffold(body: Container());
  }
}
