import 'package:eatch/pages/commande/commandeCuisine/commandeAnnuler.dart';
import 'package:eatch/pages/commande/commandeCuisine/commandeDONE.dart';
import 'package:eatch/pages/commande/commandeCuisine/commandePaid.dart';
import 'package:eatch/pages/commande/commandeCuisine/commandeTreatment.dart';
import 'package:eatch/pages/commande/commandeCuisine/commandeWaited.dart';
import 'package:eatch/servicesAPI/getCommandeCuisine.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommandeMenu extends ConsumerStatefulWidget {
  const CommandeMenu({Key? key}) : super(key: key);

  @override
  CommandeMenuState createState() => CommandeMenuState();
}

class CommandeMenuState extends ConsumerState<CommandeMenu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppLayout(
        content: DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Palette.yellowColor,
              automaticallyImplyLeading: false,
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'Commandes en attente',
                    icon: Icon(Icons.all_out),
                  ),
                  Tab(
                    text: 'Commandes en traitement',
                    icon: Icon(Icons.all_out),
                  ),
                  Tab(
                    text: 'Commandes terminées',
                    icon: Icon(Icons.published_with_changes),
                  ),
                  Tab(
                    text: 'Commandes payées',
                    icon: Icon(Icons.published_with_changes),
                  ),
                  Tab(
                    text: 'Commandes annulées',
                    icon: Icon(Icons.published_with_changes),
                  ),
                ],
              ),
              title: Row(
                children: [
                  const Spacer(),
                  Container(
                    child: const Center(
                      child: Text(' TOUTES LES COMMANDES'),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ref.refresh(getDataCommandeCuisineFuture);
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            //backgroundColor: Color.fromARGB(255, 232, 228, 213),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 190,
                  width: MediaQuery.of(context).size.width,
                  child: const TabBarView(
                    children: [
                      CommandeWaited(),
                      CommandeTreatment(),
                      CommandeDone(),
                      CommandePaid(),
                      CommandeAnnuler(),
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
