import 'package:eatch/pages/matiere_premiere/afficheMatiere.dart';
import 'package:eatch/pages/matiere_premiere/approvisionnement.dart';
import 'package:eatch/pages/matiere_premiere/creationMatiere.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatiereMenu extends ConsumerStatefulWidget {
  const MatiereMenu({Key? key}) : super(key: key);

  @override
  MatiereMenuState createState() => MatiereMenuState();
}

class MatiereMenuState extends ConsumerState<MatiereMenu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppLayout(
        content: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Palette.yellowColor,
              automaticallyImplyLeading: false,
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'Matière première via Restaurant',
                    icon: Icon(Icons.all_out),
                  ),
                  Tab(
                    text: 'Matière première via Laboratoire',
                    icon: Icon(Icons.all_out),
                  ),
                  Tab(
                    text: 'Liste des demandes',
                    icon: Icon(Icons.published_with_changes),
                  ),
                ],
              ),
              title: Center(
                child: Text('MATIERES PREMIERES'),
              ),
            ),
            //backgroundColor: Color.fromARGB(255, 232, 228, 213),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const TabBarView(
                    children: [
                      MatiereAffiche(),
                      MatiereLaboAffiche(),
                      Approvisonnement(),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
