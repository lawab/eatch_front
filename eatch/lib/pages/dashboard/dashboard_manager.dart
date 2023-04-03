import 'package:flutter/material.dart';

import '../../utils/applayout.dart';
import '../categorie/categorie/presentation/categories_list/categories_list_screen.dart';
import '../produit/products/presentation/products_list/products_list_screen.dart';

class DashboardManager extends StatefulWidget {
  const DashboardManager({super.key});

  @override
  State<DashboardManager> createState() => _DashboardManagerState();
}

class _DashboardManagerState extends State<DashboardManager> {
  final List<Widget> _screens = [
    // Content for Home tab
    Container(
      color: Colors.yellow.shade100,
      alignment: Alignment.center,
      child: const ProductsListScreen(),
    ),
    // Content for Feed tab
    Container(
      color: Colors.purple.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Feed',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // Content for Favorites tab
    Container(
      color: Colors.red.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Favorites',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // Content for Settings tab
    Container(
      color: Colors.pink.shade300,
      alignment: Alignment.center,
      child: const Text(
        'Settings',
        style: TextStyle(fontSize: 40),
      ),
    )
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: Container(
        decoration: const BoxDecoration(
          color: Colors.yellow,
          // color: const Color(0xFFf8f7f4),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        width: double.infinity,
                        height: 300,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20.0,
                        right: 20.0,
                        top: 20.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        width: double.infinity,
                        height: 300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                width: double.infinity,
                                height: 300,
                                child: NavigationRail(
                                  selectedIndex: _selectedIndex,
                                  destinations: _buildDestinations(),
                                  onDestinationSelected: (int index) {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                ),
                                // child: NavigationRail(
                                //   onDestinationSelected: (int index) {
                                //     setState(() {
                                //       _selectedIndex = index;
                                //     });
                                //   },
                                //   selectedIndex: _selectedIndex,
                                //   destinations: const [
                                //     NavigationRailDestination(
                                //         icon: Icon(Icons.home),
                                //         label: Text('Home')),
                                //     NavigationRailDestination(
                                //         icon: Icon(Icons.feed),
                                //         label: Text('Feed')),
                                //     NavigationRailDestination(
                                //         icon: Icon(Icons.favorite),
                                //         label: Text('Favorites')),
                                //     NavigationRailDestination(
                                //         icon: Icon(Icons.settings),
                                //         label: Text('Settings')),
                                //   ],

                                //   labelType: NavigationRailLabelType.all,
                                //   selectedLabelTextStyle: const TextStyle(
                                //     color: Colors.teal,
                                //   ),

                                //   unselectedLabelTextStyle: const TextStyle(),
                                //   // Called when one tab is selected
                                //   leading: Column(
                                //     children: const [
                                //       SizedBox(
                                //         height: 8,
                                //       ),
                                //       CircleAvatar(
                                //         radius: 20,
                                //         child: Icon(Icons.person),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                              ),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  width: double.infinity,
                                  height: 300,
                                  child:
                                      Expanded(child: _screens[_selectedIndex]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 20.0,
                      ),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const SizedBox(
                          width: double.infinity,
                          height: 300,
                        ),
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

  List<NavigationRailDestination> _buildDestinations() {
    Icon icon = Icon(Icons.check_circle_outline);

    return [
      NavigationRailDestination(
        icon: icon,
        label: Text('Menu 1'),
      ),
      // NavigationRailDestination(
      //   icon: icon,
      //   label: Text('Menu 1'),
      // ),
      // NavigationRailDestination(
      //   icon: icon,
      //   label: Text('Menu 2'),
      // ),
      // NavigationRailDestination(
      //   icon: icon,
      //   label: Text('Menu 3'),
      // ),
    ];
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ListView.builder")),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: const Icon(Icons.list),
                trailing: const Text(
                  "GFG",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                title: Text("List item $index"));
          }),
    );
  }
}
