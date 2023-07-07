import 'package:eatch/pages/accueil.dart';
import 'package:eatch/pages/authentification/authentification.dart';
import 'package:eatch/pages/categories/presentation/categories.dart';
import 'package:eatch/pages/dashboard/dashboard_comptable.dart';
import 'package:eatch/pages/dashboard/dashboard_manager.dart';
import 'package:eatch/pages/laboAccueil.dart';
import 'package:eatch/pages/laboratoire/accuielLabo.dart';
import 'package:eatch/pages/matiere_premiere/menu_Matiere.dart';
import 'package:eatch/pages/menus/presentation/menu.dart';
import 'package:eatch/pages/promotion/affichePromotion.dart';
import 'package:eatch/pages/recettes/recettes.dart';
import 'package:eatch/pages/restaurant/afficheRestaurant.dart';
import 'package:eatch/pages/restaurantAccueil.dart';
import 'package:eatch/pages/users/presentation/users.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runApp(const ProviderScope(child: MyApp()));
  prefs = await SharedPreferences.getInstance();
  if (prefs!.getString("isLogin").toString() == 'true') {
    login = true;
  } else {
    login = false;
  }
}

bool login = false;
SharedPreferences? prefs;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('fr')
        ],
        debugShowCheckedModeBanner: false,
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        title: 'Eatch',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:
            displayPage() //const DashboardComptable() //const Authentification() //Authentification(),ClientAccueil()
        );
  }

  Widget displayPage() {
    Widget widget = CircularProgressIndicator();
    int jour = 0;
    if (prefs!.getString('token') != null) {
      String yourToken = prefs!.getString('token').toString();
      DateTime expirationDate = JwtDecoder.getExpirationDate(yourToken);
      print('expirationDate');
      print(expirationDate);

      DateTime bb = DateTime.now();

      expirationDate = DateTime(
          expirationDate.year, expirationDate.month, expirationDate.day);
      bb = DateTime(bb.year, bb.month, bb.day);
      print('jour');
      print((bb.difference(expirationDate).inHours / 24).round());
      jour = (expirationDate.difference(bb).inHours / 24).round();
      print(jour);
    } else {}

//&& jour<>/////////////&& jour > 0
    if (login == true && jour > 0) {
      if (prefs!.getInt('index')!.toInt() == 0) {
        widget = const DashboardManager();
      } else if (prefs!.getInt('index')!.toInt() == 1) {
        widget = const DashboardComptable();
      } else if (prefs!.getInt('index')!.toInt() == 2) {
        widget = const Users();
      } else if (prefs!.getInt('index')!.toInt() == 3) {
        widget = const CategoriesPage();
      } else if (prefs!.getInt('index')!.toInt() == 4) {
        widget = const RestaurantAffiche();
      } else if (prefs!.getInt('index')!.toInt() == 5) {
        widget = const MatiereMenu();
      } else if (prefs!.getInt('index')!.toInt() == 6) {
        widget = const Menu();
      } else if (prefs!.getInt('index')!.toInt() == 7) {
        widget = const PromotionAffiche();
      } else if (prefs!.getInt('index')!.toInt() == 8) {
        widget = const RecettesPage();
      } else if (prefs!.getInt('index')!.toInt() == 9) {
        widget = const AccuilLabo();
      } else if (prefs!.getInt('index')!.toInt() == 20) {
        widget = const Accueil();
      } else if (prefs!.getInt('index')!.toInt() == 30) {
        widget = const LaboAccueil();
      } else if (prefs!.getInt('index')!.toInt() == 40) {
        widget = const RestaurantAccueil();
      }

      //////
    } else {
      prefs!.setString("isLogin", 'false');
      widget = const Authentification();
    }
    return widget;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
