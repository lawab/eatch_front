import 'package:eatch/pages/laboAccueil.dart';
import 'package:eatch/pages/restaurantAccueil.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  AccueilState createState() => AccueilState();
}

class AccueilState extends State<Accueil> {
  @override
  void initState() {
    rr();
    // TODO: implement initState
    super.initState();
  }

  void rr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('index', 20);
  }

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

  bool create = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      height: height(context),
      width: width(context),
      child: /*SingleChildScrollView(
            child:*/
          Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: height(context) / 3,
            width: width(context) / 3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('logo_vert.png'), fit: BoxFit.fill),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Container(
            child: Row(
              children: [
                const SizedBox(
                  width: 50,
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      height: height(context) / 3,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Palette.greenColors,
                        image: DecorationImage(
                          image: AssetImage('Restau_eatch.jpg'),
                          opacity: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: const Text(
                        'RESTAURANTS',
                        style: TextStyle(
                            letterSpacing: 5,
                            fontFamily: 'Bevan',
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setInt('index', 0);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RestaurantAccueil()));
                    },
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      height: height(context) / 3,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Palette.greenColors,
                        image: DecorationImage(
                          image: AssetImage('Labo_eatch.jpg'),
                          opacity: 50,
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: const Text(
                        'LABORATOIRES',
                        style: TextStyle(
                            letterSpacing: 5,
                            fontFamily: 'Bevan',
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setInt('index', 9);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LaboAccueil()));
                    },
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    ) //),
        );
  }
}
