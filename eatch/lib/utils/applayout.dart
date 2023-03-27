import 'package:flutter/material.dart';

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
      body: Container(
        child: Row(
          children: [
            //NAVIGATION
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //BAR DE HAUT
                    //const SizedBox(height: 100, child: HomePageBar()),
                    Expanded(child: content),
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
      body: Container(
        child: Column(
          children: [
            //BAR DE HAUT
            //const SizedBox(height: 100, child: HomePageBar()),
            //
            //NAVIGATION
            //
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
