import 'package:eatch/pages/authentification/authentification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

Future<http.Response> deconnexionUser(contextt) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getString('IdUser').toString();

    String adressUrl = prefs.getString('ipport').toString();
    String urlDelete = "http://13.39.81.126:4001/api/users/disconnect/$id";

    final http.Response response = await http.put(
      Uri.parse(urlDelete),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Accept': 'application/json',
        //'Context-Type': 'application/json;charSet=UTF-8',
        //'Authorization': 'Bearer $token ',
      },
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      prefs.setString("isLogin", 'false');
      showTopSnackBar(
        Overlay.of(contextt),
        const CustomSnackBar.info(
          backgroundColor: Colors.green,
          message: "Vous etes déconnecté",
        ),
      );
      Navigator.push(
        contextt,
        MaterialPageRoute(
          builder: (BuildContext context) => const Authentification(),
        ),
      );
      return response;
    } else {
      showTopSnackBar(
        Overlay.of(contextt),
        const CustomSnackBar.info(
          backgroundColor: Colors.red,
          message: "Déconnexion impossible",
        ),
      );
      return Future.error("Server Error");
    }
  } catch (e) {
    return Future.error(e);
  }
}
