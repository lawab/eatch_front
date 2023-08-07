import 'package:eatch/pages/accueil.dart';
import 'package:eatch/pages/authentification/authentification.dart';
import 'package:eatch/pages/laboAccueil.dart';
import 'package:eatch/pages/restaurantAccueil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'palettes/palette.dart';

enum SampleItem { itemOne, itemTwo, itemThree, itemFour }

class BarreHaute extends StatefulWidget {
  const BarreHaute({
    Key? key,
  }) : super(key: key);
  @override
  State<BarreHaute> createState() => BarreHauteState();
}

class BarreHauteState extends State<BarreHaute> {
  @override
  void initState() {
    rr();
    // TODO: implement initState
    super.initState();
  }

  var nom = '';
  var nomRestaut = '';
  void rr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nom = prefs.getString('UserName')!;
      nomRestaut = prefs.getString('NomRestaurant')!;
    });
  }

  SampleItem? selectedMenu;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.primaryBackgroundColor,
      child: Row(
        children: [
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Restaurant : ",
                  style: TextStyle(
                      fontFamily: 'Bevan',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: nomRestaut,
                  style: const TextStyle(
                      fontFamily: 'Bevan',
                      fontSize: 20,
                      color: Palette.yellowColor,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            width: 180.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            decoration: const BoxDecoration(
              color: Palette.fourthColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(05.0),
                  child: Image.asset(
                    "assets/profile.jpg",
                    height: 30,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 05.0,
                    ),
                    child: Text(
                      nom,
                      style: const TextStyle(
                        color: Palette.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: PopupMenuButton(
              tooltip: 'Menu',
              initialValue: selectedMenu,
              onSelected: (SampleItem item) async {
                setState(() {
                  selectedMenu = item;
                });

                if (item == SampleItem.itemOne) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Accueil()));
                } else if (item == SampleItem.itemTwo) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantAccueil()));
                } else if (item == SampleItem.itemThree) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LaboAccueil()));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const Authentification(),
                    ),
                  );
                }
              },
              child: Image.asset(
                'change.png',
                height: 40,
              ),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SampleItem>>[
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemOne,
                  child: Text('Accueil'),
                ),
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemTwo,
                  child: Text('Accueil Restaurant '),
                ),
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemThree,
                  child: Text('Accueil Laboratoire'),
                ),
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemFour,
                  child: Text('Déconnexion'),
                ),
              ],
            ),
            //Image.asset('change.png'),
          ),
        ],
      ),
    );
  }
}
