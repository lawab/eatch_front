import 'package:flutter/material.dart';

import '../../utils/applayout.dart';
import '../../utils/couleurs/couleurs.dart';
import '../../utils/images/image.dart';
import '../../utils/responsive/responsive_center.dart';
import '../categorie/application/categories_grid.dart';
import '../categorie/infrastructure/categories_repository.dart';

class DashboardManager extends StatefulWidget {
  const DashboardManager({super.key});

  @override
  State<DashboardManager> createState() => _DashboardManagerState();
}

class _DashboardManagerState extends State<DashboardManager> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_dismissOnScreenKeyboard);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_dismissOnScreenKeyboard);
    super.dispose();
  }

  // When the search text field gets the focus, the keyboard appears on mobile.
  // This method is used to dismiss the keyboard when the user scrolls.
  void _dismissOnScreenKeyboard() {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  final categorieslist = CategoriesRepository.instance.getCategoriesList();
  int selectedIndex = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: Container(
        decoration: const BoxDecoration(
          color: eatchJauneThird,
          // color: const Color(0xFFf8f7f4),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
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
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        width: double.infinity,
                        height: 300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 10.0,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15.0,
                                    bottom: 15.0,
                                    left: 15.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 15.0,
                                          right: 15.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Catégories",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: eatchTextBleu,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {},
                                              child: const Text(
                                                "Voir Plus",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: eatchJaune,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomScrollView(
                                            controller: _scrollController,
                                            slivers: [
                                              ResponsiveSliverCenter(
                                                child: CategoriesLayoutGrid(
                                                  itemCount:
                                                      categorieslist.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final categorie =
                                                        categorieslist[index];
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 15,
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedIndex =
                                                                index;
                                                            _pageController
                                                                .jumpToPage(
                                                                    index);
                                                          });
                                                        },
                                                        child:
                                                            AnimatedContainer(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: (selectedIndex ==
                                                                      index)
                                                                  ? eatchJaune
                                                                  : eatchJauneThird,
                                                              width: 01.0,
                                                            ),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  05.0),
                                                            ),
                                                            color: (selectedIndex ==
                                                                    index)
                                                                ? eatchJaune
                                                                : eatchJauneSecond,
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          height: 50,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 0,
                                                              horizontal: 06.0,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          08.0),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          03.0),
                                                                    ),
                                                                    color:
                                                                        eatchJauneThird,
                                                                  ),
                                                                  child:
                                                                      CustomIcon(
                                                                    imageUrl:
                                                                        categorie
                                                                            .imageUrl,
                                                                    imageWidth:
                                                                        18.0,
                                                                    imageColor: (selectedIndex ==
                                                                            index)
                                                                        ? const ColorFilter.mode(
                                                                            Colors
                                                                                .white,
                                                                            BlendMode
                                                                                .srcIn)
                                                                        : const ColorFilter.mode(
                                                                            eatchJaune,
                                                                            BlendMode.srcIn),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        05.0),
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      categorie
                                                                          .title,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: (selectedIndex ==
                                                                                index)
                                                                            ? Colors.white
                                                                            : eatchTextBleu,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      categorie
                                                                          .title,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: (selectedIndex ==
                                                                                index)
                                                                            ? Colors.white
                                                                            : eatchTextGris,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                                Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color:
                                                                          eatchJauneThird),
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    size: 10,
                                                                    color: (selectedIndex ==
                                                                            index)
                                                                        ? Colors
                                                                            .white
                                                                        : eatchJaune,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
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
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    width: double.infinity,
                                    child: Expanded(
                                      child: Container(
                                        child: PageView(
                                          controller: _pageController,
                                          children: [
                                            for (var i = 0;
                                                i < categorieslist.length;
                                                i++)
                                              Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                    child: Text("Page $i")),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          width: double.infinity,
                          child: const Placeholder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
