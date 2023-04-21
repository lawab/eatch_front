import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';

class RestaurantCreation extends StatefulWidget {
  const RestaurantCreation({Key? key}) : super(key: key);

  @override
  RestaurantCreationState createState() => RestaurantCreationState();
}

class RestaurantCreationState extends State<RestaurantCreation> {
  var nomController = TextEditingController();
  var villeController = TextEditingController();
  var adresseController = TextEditingController();
  var employeController = TextEditingController();

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
    return AppLayout(
        content: Container(
      color: Palette.secondaryBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
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
                  Text('Création de restaurant'),
                  Expanded(child: Container()),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(150, 50)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.backspace),
                    label: Text('Retour'),
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
                    labelText: "Nom",
                    hintText: "Entrer le nom du restaurant",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.food_bank)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              child: TextFormField(
                controller: villeController,
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
                    labelText: "Ville",
                    hintText: "Entrer la ville ou se trouve le restaurant",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.location_city)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              child: TextFormField(
                controller: adresseController,
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
                    labelText: "Adresse",
                    hintText: "Entrer l'adresse du restaurant",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.local_activity)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              child: TextFormField(
                controller: employeController,
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
                    labelText: "Nombre d'employés",
                    hintText: "Entrer le nombre d'employés du restaurant",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.person)),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text(
                  "Vous devriez joindre une image du restaurant lors de l'enregistrement"),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: (() {}),
              child: Text('Enregistrer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.primaryColor,
                minimumSize: Size(150, 50),
                maximumSize: Size(200, 70),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
