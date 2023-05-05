import 'package:eatch/utils/size/size.dart';
import 'package:flutter/material.dart';

import 'bar_haut.dart';
import 'navigation.dart';
import 'palettes/palette.dart';

class AppLayout extends StatefulWidget {
  final Widget content;
  static BuildContext? context2;

  const AppLayout({Key? key, required this.content}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
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
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            /**
            !BARRE DE NAVIGATION VERTICAL 
                                      **/
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      width: 4,
                      color: Palette.fourthColor,
                    ),
                  ),
                  color: Palette.primaryBackgroundColor,
                ),
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Image.asset(
                        'assets/logo_vert.png',
                      ),
                    ),
                    Expanded(
                      child: Navigation(
                        orientation: Axis.vertical,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /**
                        !BARRE HAUTE 
                                      **/
                    const BarreHaute(),
                    Expanded(child: widget.content),
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
        color: Colors.transparent,
        child: Column(
          children: [
            /**
                        !BARRE HAUTE 
                                      **/
            const BarreHaute(),
            /**
            !BARRE DE NAVIGATION VERTICAL 
                                      **/
            SizedBox(
              height: getProportionateScreenHeight(120.0),
              child: Navigation(
                orientation: Axis.horizontal,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: widget.content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
