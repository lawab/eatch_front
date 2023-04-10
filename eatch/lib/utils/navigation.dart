import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  final String ecran;
  const Navigation({Key? key, required this.ecran}) : super(key: key);

  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.ecran == 'horizontal'
        ? horizontalView(context)
        : verticalView(context);
    /*MaterialApp(
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
    );*/
  }

  Widget horizontalView(context) {
    return Scaffold(
      //backgroundColor: Colors.lightBlue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 88,
            width: 88,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/WAB.png"),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const Divider(
                  height: 6,
                ),
                ListTile(
                  //selected: _selectedIndex == 0,
                  leading: const Icon(Icons.dashboard_customize_rounded),
                  title: const Text('Dashboard'),
                  onTap: () {
                    //_onMenuItemSelected(0);
                    //Navigator.pop(context);
                  },
                ),
                const Divider(
                  height: 6,
                ),
                ListTile(
                  //selected: _selectedIndex == 1,
                  leading: const Icon(Icons.explore),
                  title: const Text('Recherche'),
                  onTap: () {
                    //_onMenuItemSelected(1);
                    //Navigator.pop(context);
                  },
                ),
                const Divider(
                  height: 6,
                ),
                ListTile(
                  //selected: _selectedIndex == 2,
                  leading: const Icon(Icons.favorite),
                  title: const Text('Favoris'),
                  onTap: () {
                    //_onMenuItemSelected(2);
                    //Navigator.pop(context);
                  },
                ),
                const Divider(
                  height: 6,
                ),
                ListTile(
                  //selected: _selectedIndex == 3,
                  leading: const Icon(Icons.bento_rounded),
                  title: const Text('Commande'),
                  onTap: () {
                    //_onMenuItemSelected(3);
                    //Navigator.pop(context);
                  },
                ),
                const Divider(
                  height: 6,
                ),
                ListTile(
                  //selected: _selectedIndex == 4,
                  leading: const Icon(Icons.chat_rounded),
                  title: const Text('Message'),
                  onTap: () {
                    //_onMenuItemSelected(4);
                    //Navigator.pop(context);
                  },
                ),
                const Divider(
                  height: 6,
                ),
                ListTile(
                  //selected: _selectedIndex == 5,
                  leading: const Icon(Icons.settings),
                  title: const Text('Paramètres'),
                  onTap: () {
                    //_onMenuItemSelected(5);
                    //Navigator.pop(context);
                  },
                ),
                const Divider(
                  height: 6,
                ),
                ListTile(
                  //selected: _selectedIndex == 6,
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Se déconnecter'),
                  onTap: () {
                    //_onMenuItemSelected(6);
                    //Navigator.pop(context);
                  },
                ),
                /*const Divider(
                  height: 6,
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget verticalView(context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                image: AssetImage("assets/WAB.png"),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Dashboard"),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Recherche"),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Favoris"),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Commande"),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Message"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
