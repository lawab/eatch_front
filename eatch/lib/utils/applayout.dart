import 'package:flutter/material.dart';

import 'bar_haut.dart';
import 'navigation.dart';

class AppLayout extends StatelessWidget {
  final Widget content;
  static BuildContext? context2;

  const AppLayout({Key? key, required this.content}) : super(key: key);
  @override
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
      body: Row(
        children: [
          //NAVIGATION

          const Expanded(
            flex: 2,
            child: Navigation(
              ecran: 'horizontal',
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //BAR DE HAUT
                  const BarHaut(),
                  //const SizedBox(height: 100, child: HomePageBar()),
                  Expanded(child: content),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    print("object");
    return Scaffold(
      body: Column(
        children: [
          //const SizedBox(height: 100, child: BAR DE HAUT()),
          //
          const BarHaut(),
          //NAVIGATION
          const SizedBox(
            height: 100,
            child: Navigation(
              ecran: 'vertical',
            ),
          ),
          //
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}


/*
drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: AssetImage("assets/WAB.png"),
                ),
              ),
              child: null,
            ),
            const Divider(
              height: 6,
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_customize_rounded),
              title: const Text('Dashboard'),
              onTap: () {},
            ),
            const Divider(
              height: 6,
            ),
            ListTile(
              leading: const Icon(Icons.explore),
              title: const Text('Recherche'),
              onTap: () {},
            ),
            const Divider(
              height: 6,
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favoris'),
              onTap: () {},
            ),
            const Divider(
              height: 6,
            ),
            ListTile(
              leading: const Icon(Icons.bento_rounded),
              title: const Text('Commande'),
              onTap: () {},
            ),
            const Divider(
              height: 6,
            ),
            ListTile(
              leading: const Icon(Icons.chat_rounded),
              title: const Text('Message'),
              onTap: () {},
            ),
            const Divider(
              height: 6,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {},
            ),
            const Divider(
              height: 6,
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Paramètres'),
              onTap: () {},
            ),
            const Divider(
              height: 6,
            ),
          ],
        ),
      ),
*/