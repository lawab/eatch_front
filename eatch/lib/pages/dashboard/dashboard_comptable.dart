import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';

import '../../utils/size/size.dart';
import '../statistique/bar_chart.dart';
import '../statistique/buble_chart.dart';
import '../statistique/circular_chart.dart';
import '../statistique/diagram_chart.dart';
import '../statistique/line_chart.dart';
import '../statistique/pie_chart.dart';

class DashboardComptable extends StatefulWidget {
  const DashboardComptable({super.key});

  @override
  State<DashboardComptable> createState() => _DashboardComptableState();
}

class _DashboardComptableState extends State<DashboardComptable> {
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
    SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(
              height(context),
              width(context),
              context,
            );
          } else {
            return verticalView(
              height(context),
              width(context),
              context,
            );
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, BuildContext context) {
    return AppLayout(
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // - entête de la page
              Card(
                elevation: 20,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  height: (height / 4) - 8,
                  width: width,
                  child: Column(
                    children: [
                      Container(
                        height: 20,
                        width: width,
                        decoration: BoxDecoration(
                          color: Palette.yellowColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Card 1',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container()
                    ],
                  ),
                ),
              ),

              // - le corps de la page
              SizedBox(
                height: height * 3 / 4,
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 2 / 4,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Card(
                                          elevation: 20,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: SizedBox(
                                            height: (height / 4) - 8,
                                            width: width,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                    color: Palette.yellowColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: const Text(
                                                    'Card 2',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: ((height / 4) - 28),
                                                  child: const BubleChart(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          elevation: 20,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: SizedBox(
                                            height: (height / 4) - 8,
                                            width: width,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                    color: Palette.yellowColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: const Text(
                                                    'Card 3',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: ((height / 4) - 28),
                                                  child: const DiagramChart(),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Card(
                                      elevation: 20,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SizedBox(
                                        height: (height * 2 / 4) - 8,
                                        width: width,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 20,
                                              width: width,
                                              decoration: BoxDecoration(
                                                color: Palette.yellowColor,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: const Text(
                                                'Card 4',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                              height: (height * 2 / 4) - 28,
                                              child: const LineChart(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 4,
                            child: Card(
                              elevation: 20,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SizedBox(
                                height: (height * 2 / 4) - 8,
                                width: width,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Palette.yellowColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Card 5',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: ((height * 2 / 4) - 215.250),
                                      child: BarChart(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          SizedBox(
                            height: height / 4,
                            child: Card(
                              elevation: 20,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SizedBox(
                                height: (height / 4) - 8,
                                width: width,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Palette.yellowColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Card 6',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: ((height / 4) - 28),
                                      child: const PieChart(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 2 / 4,
                            child: Card(
                              elevation: 20,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SizedBox(
                                height: (height * 2 / 4) - 8,
                                width: width,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Palette.yellowColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Card 7',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: (height * 2 / 4) - 28,
                                      child: const CircularChart(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, BuildContext context) {
    return AppLayout(
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // - entête de la page
              Container(
                child: Card(
                  elevation: 20,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    height: (height / 4) - 8,
                    width: width,
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                          width: width,
                          decoration: BoxDecoration(
                            color: Palette.yellowColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Card 1',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container()
                      ],
                    ),
                  ),
                ),
              ),
              //

              // - Le corps de la page

              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Card(
                              elevation: 20,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SizedBox(
                                height: (height / 4) - 8,
                                width: width,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Palette.yellowColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Card 2',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: ((height / 4) - 28),
                                      child: const BubleChart(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 20,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SizedBox(
                                height: (height / 4) - 8,
                                width: width,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Palette.yellowColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Card 3',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: ((height / 4) - 28),
                                      child: const DiagramChart(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Card(
                          elevation: 20,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            height: (height * 2 / 4) - 8,
                            width: width,
                            child: Column(
                              children: [
                                Container(
                                  height: 20,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Palette.yellowColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Card 4',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: (height * 2 / 4) - 28,
                                  child: const LineChart(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Card(
                          elevation: 20,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            height: (height * 2 / 4) - 8,
                            width: width,
                            child: Column(
                              children: [
                                Container(
                                  height: 20,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Palette.yellowColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Card 6',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: (height * 2 / 4) - 28,
                                  child: const PieChart(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Card(
                          elevation: 20,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            height: (height * 2 / 4) - 8,
                            width: width,
                            child: Column(
                              children: [
                                Container(
                                  height: 20,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Palette.yellowColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Card 7',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: (height * 2 / 4) - 28,
                                  child: const CircularChart(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //
              Container(
                child: Card(
                  elevation: 20,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    height: (height / 4) - 8,
                    width: width,
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                          width: width,
                          decoration: BoxDecoration(
                            color: Palette.yellowColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Card 5',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: (height / 4) - 28,
                          child: BarChart(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
