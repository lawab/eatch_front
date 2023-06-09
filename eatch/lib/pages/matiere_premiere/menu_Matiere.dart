import 'package:eatch/pages/matiere_premiere/afficheMatiere.dart';
import 'package:eatch/pages/matiere_premiere/creationMatiere.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SingingCharacter { restaurant, laboratoire }

class MatiereMenu extends ConsumerStatefulWidget {
  const MatiereMenu({Key? key}) : super(key: key);

  @override
  MatiereMenuState createState() => MatiereMenuState();
}

class MatiereMenuState extends ConsumerState<MatiereMenu> {
  SingingCharacter? _character = SingingCharacter.restaurant;
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: Container(
        height: MediaQuery.of(context).size.height - 60,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 80,
              color: Palette.yellowColor,
              child: Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  const Text('Matières premières'),
                  Expanded(child: Container()),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              child: Row(children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Matière première via Restaurant'),
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.restaurant,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Matière première via Laboratoire'),
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.laboratoire,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                ),
              ]),
            ),
            _character == SingingCharacter.restaurant
                ? Container(
                    color: Colors.red,
                    height: MediaQuery.of(context).size.height - 200,
                    child: MatiereAffiche(),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: MatiereLaboAffiche(),
                  ),
          ],
        ),
      ),
    );
  }
}
