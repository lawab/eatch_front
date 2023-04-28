import 'dart:convert';

import 'package:eatch/pages/dashboard/dashboard_manager.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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

  // Show the password or hide it
  bool notVisible = true;

  // Sign user method
  //void signUserIn() {}

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
      body: SizedBox(
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
                      height: 50,
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
                      height: 50,
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
                        obscureText: true,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Mot de passe oublié',
                          style: GoogleFonts.raleway().copyWith(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          login(
                              usernameController.text, passwordController.text);
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
    );
  }

  Widget verticalView(double height, double width, context) {
    return Scaffold(
      body: SizedBox(
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
                      height: 50,
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
                      height: 50,
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
                        obscureText: true,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Mot de passe oublié',
                          style: GoogleFonts.raleway().copyWith(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          login(
                              usernameController.text, passwordController.text);
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
    );
  }

  Future<void> login(email, pass) async {
    String url = "http://13.39.81.126:4001/api/users/login";
    print(url);

    if (pass.isNotEmpty && email.isNotEmpty) {
      var response = await http.post(Uri.parse(url),
          body: ({
            'email': email,
            'password': pass,
          }));
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("Vous êtes connecté");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardManager()));
        /* Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => DashboardManager()),
            (Route<dynamic> route) => false);*/
      } else {
        print("Vous n'êtes pas connecté");
      }
    } else {
      print("Il y'a une erreur");
    }
  }
}
