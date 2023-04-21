// ignore_for_file: must_be_immutable

import 'package:eatch/pages/categories/presentation/categories.dart';
import 'package:eatch/pages/dashboard/dashboard_manager.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: widget.orientation,
      children: [
        NavigationButton(
          index: index,
          text: "ACCUEIL",
          selectedIndex: 0,
          onPress: () {
            setState(() {
              index = 0;
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
          onPress: () {
            setState(() {
              index = 1;
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
          selectedIndex: 1,
          onPress: () {
            setState(() {
              index = 1;
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
          text: "ACCUEIL 3",
          selectedIndex: 3,
          onPress: () {
            setState(() {
              index = 3;
            });
          },
        ),
        NavigationButton(
          index: index,
          text: "ACCUEIL 4",
          selectedIndex: 4,
          onPress: () {
            setState(() {
              index = 4;
            });
          },
        ),
        NavigationButton(
          index: index,
          text: "ACCUEIL 5",
          selectedIndex: 5,
          onPress: () {
            setState(() {
              index = 5;
            });
          },
        ),
        NavigationButton(
          index: index,
          text: "ACCUEIL 6",
          selectedIndex: 6,
          onPress: () {
            setState(() {
              index = 6;
            });
          },
        ),
        NavigationButton(
          index: index,
          text: "ACCUEIL 7",
          selectedIndex: 7,
          onPress: () {
            setState(() {
              index = 7;
            });
          },
        ),
        NavigationButton(
          index: index,
          text: "ACCUEIL 8",
          selectedIndex: 8,
          onPress: () {
            setState(() {
              index = 8;
            });
          },
        ),
        NavigationButton(
          index: index,
          text: "ACCUEIL 9",
          selectedIndex: 9,
          onPress: () {
            setState(() {
              index = 9;
            });
          },
        ),
        NavigationButton(
          index: index,
          text: "ACCUEIL 10",
          selectedIndex: 10,
          onPress: () {
            setState(() {
              index = 10;
            });
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
      height: getProportionateScreenHeight(100.0),
      width: getProportionateScreenWidth(130.0),
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
