import 'dart:convert';
import 'dart:html';

import 'package:eatch/pages/dashboard/dashboard_manager.dart';
import 'package:eatch/pages/restaurantAccueil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../servicesAPI/get_categories.dart';

class Authentification extends StatefulWidget {
  const Authentification({Key? key}) : super(key: key);

  @override
  AuthentificationState createState() => AuthentificationState();
}

class AuthentificationState extends State<Authentification> {
  // Text editing controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isChecked = false;
  // Show the password or hide it
  bool notVisible = true;
  @override
  void initState() {
    _loadSettings();
    // TODO: implement initState
    super.initState();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool('login') == true) {
        isChecked = true;
        usernameController.text = prefs.getString('emailLogin').toString();
        passwordController.text = prefs.getString('passLogin').toString();
      } else {
        isChecked = false;
        usernameController.text = '';
        passwordController.text = '';
      }
    });
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
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: height,
          width: width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: height,
                  width: width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/eatch5.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  /*child: Center(
                  child: Text(
                    'Gestion de restaurant',
                    style: GoogleFonts.raleway().copyWith(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  ),
                ),*/
                ),
              ),
              Expanded(
                child: Container(
                  height: height,
                  width: width,
                  padding: EdgeInsets.symmetric(
                    horizontal: height * 0.12,
                  ),
                  color: Colors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //////////
                      Container(
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/Logo_Eatch.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ////////////
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Connexion",
                              style: GoogleFonts.raleway().copyWith(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: " Eatch",
                              style: GoogleFonts.raleway().copyWith(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'Bienvenue sur notre application Eatch, J\'espère que vous serez satisfait de nos services.',
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: height * 0.032),
                      const SizedBox(height: 6),
                      Container(
                        height: 60,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: usernameController,
                          style: GoogleFonts.raleway().copyWith(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '    Ne laissez pas vide';
                            } else if (RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return null;
                            } else {
                              return '    Entrer un email valide';
                            }
                          },
                          decoration: InputDecoration(
                            label: const Text(
                              "Nom d'utlisateur",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Image.asset("assets/images/user.png"),
                            ),
                            contentPadding: const EdgeInsets.only(top: 16),
                            hintText: "Entrer votre nom d'utilisateur",
                            hintStyle: GoogleFonts.raleway().copyWith(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.014),
                      const SizedBox(height: 6),
                      Container(
                        height: 60,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          style: GoogleFonts.raleway().copyWith(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          obscureText: notVisible,
                          validator: (valuep) {
                            if (valuep!.isEmpty) {
                              return '    Ne laissez pas vide';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text(
                              "Mot de passe",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Image.asset("assets/images/cle.png"),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  notVisible = !notVisible;
                                });
                              },
                              icon: Icon(
                                  notVisible == true
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black12),
                            ),
                            hintText: "Entrer votre mot de passe",
                            hintStyle: GoogleFonts.raleway().copyWith(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      Container(
                        width: width,
                        child: Row(
                          children: [
                            Container(
                              //height: 20,
                              width:
                                  150, //MediaQuery.of(context).size.width / 6,
                              child: CheckboxListTile(
                                title: Text(
                                  "Se souvenir",
                                  style: GoogleFonts.raleway().copyWith(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                value: isChecked,
                                onChanged: (newValue) {
                                  setState(() {
                                    isChecked = newValue!;
                                  });
                                },
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              width: 150,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Mot de passe oublié ?',
                                  style: GoogleFonts.raleway().copyWith(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.05),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            if (_formKey.currentState!.validate()) {
                              if (isChecked == true) {
                                prefs.setBool('login', isChecked);
                                prefs.setString(
                                    'emailLogin', usernameController.text);
                                prefs.setString(
                                    'passLogin', passwordController.text);
                              } else {
                                prefs.setBool('login', isChecked);
                                prefs.setString('emailLogin', 'non');
                                prefs.setString('passLogin', 'non');
                              }
                              login(context, usernameController.text,
                                  passwordController.text);
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.yellow,
                            ),
                            child: Text(
                              'Se connecter',
                              style: GoogleFonts.raleway().copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: height,
          width: width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: height,
                  width: width,
                  //color: Colors.blue,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/eatch5.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  /*child: Center(
                  child: Text(
                    'Gestion de restaurant',
                    style: GoogleFonts.raleway().copyWith(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  ),
                ),*/
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  height: height,
                  width: width,
                  padding: EdgeInsets.symmetric(
                    horizontal: height * 0.12,
                  ),
                  color: Colors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //////////
                      Container(
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/Logo_Eatch.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ////////////
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Connexion",
                              style: GoogleFonts.raleway().copyWith(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: " Eatch",
                              style: GoogleFonts.raleway().copyWith(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'Bienvenue sur notre application Eatch, J\'espère que vous serez satisfait de nos services.',
                        style: GoogleFonts.raleway().copyWith(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: height * 0.032),
                      const SizedBox(height: 6),
                      Container(
                        height: 60,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: usernameController,
                          style: GoogleFonts.raleway().copyWith(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '    Ne laissez pas vide';
                            } else if (RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return null;
                            } else {
                              return '    Entrer un email valide';
                            }
                          },
                          decoration: InputDecoration(
                            label: const Text(
                              "Nom d'utlisateur",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Image.asset("assets/images/user.png"),
                            ),
                            contentPadding: const EdgeInsets.only(top: 16),
                            hintText: "Entrer votre nom d'utilisateur",
                            hintStyle: GoogleFonts.raleway().copyWith(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.014),
                      const SizedBox(height: 6),
                      Container(
                        height: 60,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          style: GoogleFonts.raleway().copyWith(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          obscureText: notVisible,
                          validator: (valuep) {
                            if (valuep!.isEmpty) {
                              return '    Ne laissez pas vide';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text(
                              "Mot de passe",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Image.asset("assets/images/cle.png"),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  notVisible = !notVisible;
                                });
                              },
                              icon: Icon(
                                  notVisible == true
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black12),
                            ),
                            hintText: "Entrer votre mot de passe",
                            hintStyle: GoogleFonts.raleway().copyWith(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      Container(
                        width: width,
                        child: Row(
                          children: [
                            Container(
                              //height: 20,
                              width:
                                  130, //MediaQuery.of(context).size.width / 6,
                              child: CheckboxListTile(
                                title: Text(
                                  "Se souvenir",
                                  style: GoogleFonts.raleway().copyWith(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                value: isChecked,
                                onChanged: (newValue) {
                                  setState(() {
                                    isChecked = newValue!;
                                  });
                                },
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              width: 130,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Mot de passe oublié ?',
                                  style: GoogleFonts.raleway().copyWith(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              login(context, usernameController.text,
                                  passwordController.text);
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.yellow,
                            ),
                            child: Text(
                              'Se connecter',
                              style: GoogleFonts.raleway().copyWith(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context, email, pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /*final String response = await rootBundle.loadString('assets/server.json');
    final data = await json.decode(response);
    String adress_url = data['ip'] + ":" + data['port'];

    prefs.setString('ipport', adress_url);*/
    String url = "http://13.39.81.126:4001/api/users/login"; //13.39.81.126:4001
    print(url);
    print(email);
    print(pass);

    if (pass.isNotEmpty && email.isNotEmpty) {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': pass,
        }),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        prefs.setString('IdUser', data['user']['_id']);
        prefs.setString('token', data['accessToken']);

        print("Vous êtes connecté");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RestaurantAccueil()));

        /* Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => DashboardManager()),
            (Route<dynamic> route) => false);*/
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email ou Mot de passe incorrect."),
        ));

        print("Vous n'êtes pas connecté");
      }
    } else {
      print("Il y'a une erreur");
    }
  }
}
