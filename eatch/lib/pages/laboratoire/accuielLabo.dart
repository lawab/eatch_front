import 'package:eatch/pages/laboratoire/fournisseur.dart';
import 'package:eatch/pages/laboratoire/matiereFini.dart';
import 'package:eatch/pages/laboratoire/matierebrute.dart';
import 'package:eatch/pages/laboratoire/sortieMatiere.dart';
import 'package:eatch/pages/laboratoire/stockLabo.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccuilLabo extends StatefulWidget {
  const AccuilLabo({Key? key}) : super(key: key);

  @override
  AccuilLaboState createState() => AccuilLaboState();
}

class AccuilLaboState extends State<AccuilLabo> {
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
                  const Text('Gestion du laboratoire'),
                  Expanded(child: Container()),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              alignment: Alignment.center,
              height: height - 180,
              child: Container(
                height: 200,
                child: Row(children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Card(
                        elevation: 10,
                        child: InkWell(
                          child: Container(
                            height: 200,
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage('fourni.jpg'),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                const Text(
                                  'Approvisionner',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MatiereBrutee()),
                            );
                          },
                        )),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Card(
                        elevation: 10,
                        child: InkWell(
                          child: Container(
                            height: 200,
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage('founisseur.png'),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                const Text(
                                  'Fournisseur',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FournisseurPage()),
                            );
                          },
                        )),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Card(
                      elevation: 10,
                      child: InkWell(
                        child: Container(
                          height: 200,
                          child: Column(
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('stockk.png'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              const Text(
                                'Voir le stock',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SotckLabo()),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Card(
                        elevation: 10,
                        child: InkWell(
                          child: Container(
                            height: 200,
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage('fini.jpg'),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                const Text(
                                  'Gestion de la matière finie',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MatiereFiniPage()),
                            );
                          },
                        )),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Card(
                        elevation: 10,
                        child: InkWell(
                          child: Container(
                            height: 200,
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage('logo_vert.png'),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                const Text(
                                  'Sortie de la matière finie',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SortieMatiere()),
                            );
                          },
                        )),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return Scaffold();
  }
}
