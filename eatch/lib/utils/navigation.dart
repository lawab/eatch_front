// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:eatch/pages/categories/presentation/categories.dart';
import 'package:eatch/pages/dashboard/dashboard_manager.dart';
import 'package:eatch/pages/restaurant/afficheRestaurant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/users/presentation/users.dart';
import 'palettes/palette.dart';
import 'size/size.dart';

class Navigation extends StatefulWidget {
  Navigation({
    Key? key,
    required this.orientation,
  }) : super(key: key);

  Axis orientation;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int index = 0;
  @override
  void initState() {
    ind();
    // TODO: implement initState
    super.initState();
  }

  Future ind() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //if(prefs.getInt('index').toInt().is)
    setState(() {
      if (prefs.getInt('index') != null) {
        int aa = prefs.getInt('index')!.toInt();
        index = aa;
      } else {
        print('nullllllllllllll');
        index = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: widget.orientation,
      children: [
        NavigationButton(
          index: index,
          text: "ACCUEIL",
          selectedIndex: 0,
          onPress: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            setState(() {
              index = 0;
              prefs.setInt('index', index);
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const DashboardManager(),
              ),
            );
          },
        ),
        NavigationButton(
          index: index,
          text: "UTILISATEURS",
          selectedIndex: 1,
          onPress: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              index = 1;
              prefs.setInt('index', index);
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const Users(),
              ),
            );
          },
        ),
        NavigationButton(
          index: index,
          text: "CATÉGORIES",
          selectedIndex: 2,
          onPress: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              index = 2;
              prefs.setInt('index', index);
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const CategoriesPage(),
              ),
            );
          },
        ),
        NavigationButton(
          index: index,
          text: "GESTION DE RESTAURANT",
          selectedIndex: 3,
          onPress: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              index = 3;
              prefs.setInt('index', index);
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const RestaurantAffiche(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    super.key,
    required this.text,
    required this.index,
    required this.onPress,
    required this.selectedIndex,
  });

  final int index;
  final String text;
  final int selectedIndex;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 05.0,
      ),
      height: 50.0,
      // width: 130.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          foregroundColor: Palette.primaryColor,
          backgroundColor: (selectedIndex == index)
              ? Palette.primaryColor
              : Palette.secondaryBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: (selectedIndex == index)
                ? Palette.primaryBackgroundColor
                : Palette.textsecondaryColor,
          ),
        ),
      ),
    );
  }
}
