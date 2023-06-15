import 'package:eatch/servicesAPI/getMatiereFini.dart';
import 'package:eatch/servicesAPI/getMatierebrute.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SotckLabo extends ConsumerStatefulWidget {
  const SotckLabo({Key? key}) : super(key: key);

  @override
  SotckLaboState createState() => SotckLaboState();
}

class SotckLaboState extends ConsumerState<SotckLabo> {
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
    final viewModell = ref.watch(getDataMatiereBruteFuture);
    final viewModel = ref.watch(getDataMatiereFiniFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModell.listMatiereBrute, viewModel.listMatiereFini);
          } else {
            return verticalView(height(context), width(context), context,
                viewModell.listMatiereBrute, viewModel.listMatiereFini);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, contextt,
      List<MatiereBrute> listMatiereBrute, List<MatiereFini> listMatiereFini) {
    return AppLayout(
      content: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 80,
              color: Palette.yellowColor, //Color(0xFFFCEBD1),
              child: Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  const Text('Stock du laboratoire'),
                  Expanded(child: Container()),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(180, 50)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.backspace),
                    label: const Text('Retour'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              height: height - 180,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: height - 180,
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                          child: Text(
                            'Stock de matière initiale',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: height - 210,
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 300,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 50,
                                      mainAxisExtent: 400),
                              itemCount: listMatiereBrute.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 10,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 200,
                                          width: 300,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  AssetImage('emballage.jpeg'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 35,
                                        ),
                                        Text(
                                            'Nom : ${listMatiereBrute[index].title}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Quantité : ${listMatiereBrute[index].available} ${listMatiereBrute[index].unit}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Dernière date : ${listMatiereBrute[index].updatedAt}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Date de création : ${listMatiereBrute[index].createdAt}'),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  )),
                  const VerticalDivider(
                    width: 10,
                    color: Palette.yellowColor,
                  ),
                  Expanded(
                      child: Container(
                    height: height - 180,
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                          child: Text(
                            'Stock de matière finie',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: height - 210,
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 300,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 50,
                                      mainAxisExtent: 400),
                              itemCount: listMatiereFini.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 10,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 200,
                                          width: 300,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  AssetImage('emballage.jpeg'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Text(
                                            'Nom : ${listMatiereFini[index].title}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Quantité : ${listMatiereFini[index].quantity}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Dernière date : ${listMatiereFini[index].updatedAt}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Date de création : ${listMatiereFini[index].createdAt}'),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, contextt,
      List<MatiereBrute> listMatiereBrute, List<MatiereFini> listMatiereFini) {
    return AppLayout(
      content: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 50,
              color: Palette.yellowColor, //Color(0xFFFCEBD1),
              child: Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  const Text('Stock du laboratoire'),
                  Expanded(child: Container()),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(180, 50)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.backspace),
                    label: const Text('Retour'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: height - 180,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: height - 180,
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                          child: Text(
                            'Stock de matière initiale',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: height - 210,
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 300,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 50,
                                      mainAxisExtent: 400),
                              itemCount: listMatiereBrute.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 10,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 200,
                                          width: 300,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  AssetImage('emballage.jpeg'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 35,
                                        ),
                                        Text(
                                            'Nom : ${listMatiereBrute[index].title}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Quantité : ${listMatiereBrute[index].available} ${listMatiereBrute[index].unit}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Dernière date : ${listMatiereBrute[index].updatedAt}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Date de création : ${listMatiereBrute[index].createdAt}'),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  )),
                  const VerticalDivider(
                    width: 10,
                    color: Palette.yellowColor,
                  ),
                  Expanded(
                    child: Container(
                      height: height - 180,
                      child: Column(
                        children: [
                          Container(
                            height: 20,
                            child: Text(
                              'Stock de matière finie',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height - 210,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 300,
                                        childAspectRatio: 3 / 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 50,
                                        mainAxisExtent: 400),
                                itemCount: listMatiereFini.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 10,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 200,
                                            width: 300,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'emballage.jpeg'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Text(
                                              'Nom : ${listMatiereFini[index].title}'),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              'Quantité : ${listMatiereFini[index].quantity}'),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              'Dernière date : ${listMatiereFini[index].updatedAt}'),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              'Date de création : ${listMatiereFini[index].createdAt}'),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
