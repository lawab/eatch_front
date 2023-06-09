import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SortieMatiere extends StatefulWidget {
  const SortieMatiere({Key? key}) : super(key: key);

  @override
  SortieMatiereState createState() => SortieMatiereState();
}

class SortieMatiereState extends State<SortieMatiere> {
  var demandeController = TextEditingController();
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

  var nombrecontrol = TextEditingController(text: '10');

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

  int count = 0;
  Widget horizontalView(double height, double width, contextt) {
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
                const Text('Sortie de Matière finie'),
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
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 10,
                      child: InkWell(
                        child: Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text('Matière fini $index'),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                    maxRadius: 20,
                                    backgroundColor: Colors.black,
                                    child: IconButton(
                                        onPressed: () {
                                          dialogSortie(context);
                                        },
                                        icon: const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        )),
                                  )),
                            ],
                          ),
                        ),
                        onTap: () {
                          dialogSortie(context);
                        },
                      ));
                }),
          ),
        ],
      ),
    ));
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(content: Container());
  }

  Future dialogSortie(BuildContext contextt) {
    //print('dedans');
    demandeController.text = 100.toString();
    return showDialog(
      context: contextt,
      builder: (co) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "DEMANDE",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'HelveticaNeue',
              ),
            ),
          ),
          actions: [
            ElevatedButton.icon(
                icon: const Icon(
                  Icons.close,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Refuser   ")),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton.icon(
                icon: const Icon(
                  Icons.check,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.greenColors),
                onPressed: () {},
                label: const Text("Accepter."))
          ],
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 170,
              child: Column(
                children: [
                  Text(
                    'Type : Matière finie',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text('Stock Initial : 500'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Stock possible : 200'),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 250,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Stock demandé : '),
                        ),
                        Expanded(
                          child: SizedBox(
                            //width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
                              controller: demandeController,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                  hoverColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 42, vertical: 20),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Palette.yellowColor),
                                    gapPadding: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Palette.yellowColor),
                                    gapPadding: 10,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Palette.yellowColor),
                                    gapPadding: 10,
                                  ),
                                  labelText: "Quantite",
                                  hintText: "Inscrire le titre",
                                  // If  you are using latest version of flutter then lable text and hint text shown like this
                                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  suffixIcon: const Icon(Icons.title)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
