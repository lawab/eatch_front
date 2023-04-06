import 'package:flutter/material.dart';

import '../../utils/applayout.dart';
import '../../utils/couleurs/couleurs.dart';
import '../../utils/formatter/formatter.dart';
import '../../utils/images/image.dart';
import '../../utils/responsive/responsive_center.dart';
import '../categorie/application/categories_grid.dart';
import '../categorie/infrastructure/categories_repository.dart';
import '../categorie/presentation/categorie_card.dart';
import '../menu/application/menus_grid.dart';
import '../menu/infrastructure/menus_repository.dart';
import '../produit/application/produits_grid.dart';
import '../produit/infrastructure/produits_repository.dart';

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

  final categoriesList = CategoriesRepository.instance.getCategoriesList();
  final productsList = ProductsRepository.instance.getProductsList();
  final menusList = MenusRepository.instance.getMenusList();
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final filterproductsList = productsList.where((prod) {
      return prod.categories.contains(categoriesList[selectedIndex].id);
    }).toList();

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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          child: CustomImage(
                            imageUrl: 'assets/WAB.png',
                            // imageWidth: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
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
                                      Container(
                                        color: Colors.white,
                                        child: Padding(
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
                                              InkWell(
                                                hoverColor: Colors.transparent,
                                                onTap: () {},
                                                child: const Text(
                                                  "Voir Plus",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: eatchJaune,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomScrollView(
                                            // controller: _scrollController,
                                            slivers: [
                                              ResponsiveSliverCenter(
                                                child: categoriesList.isEmpty
                                                    ? const Center(
                                                        child: Text(
                                                          'Aucune catégorie trouvée',
                                                        ),
                                                      )
                                                    : CategoriesLayoutGrid(
                                                        itemCount:
                                                            categoriesList
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          final categorie =
                                                              categoriesList[
                                                                  index];
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              right: 15,
                                                            ),
                                                            child:
                                                                CategorieCard(
                                                              categorie:
                                                                  categorie,
                                                              selectedIndex:
                                                                  selectedIndex,
                                                              index: index,
                                                              onPress: () {
                                                                setState(() {
                                                                  selectedIndex =
                                                                      index;
                                                                  _pageController
                                                                      .jumpToPage(
                                                                          index);
                                                                });
                                                              },
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
                                              Text(
                                                categoriesList[selectedIndex]
                                                    .title,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: eatchTextBleu,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 05.0,
                                                        vertical: 05.0),
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(05.0),
                                                  ),
                                                  color: eatchJauneThird,
                                                ),
                                                child: InkWell(
                                                  hoverColor:
                                                      Colors.transparent,
                                                  onTap: () {},
                                                  child: Row(
                                                    children: const [
                                                      Text(
                                                        "Par nom",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: eatchJaune,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        size: 13.0,
                                                        color: eatchJaune,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: PageView(
                                            controller: _pageController,
                                            children: [
                                              for (var i = 0;
                                                  i < categoriesList.length;
                                                  i++)
                                                CustomScrollView(
                                                  // controller: _scrollController,
                                                  slivers: [
                                                    ResponsiveSliverCenter(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 15.0,
                                                        ),
                                                        child: filterproductsList
                                                                .isEmpty
                                                            ? const Center(
                                                                child: Text(
                                                                  'Aucun Produit trouvé',
                                                                ),
                                                              )
                                                            : ProductsLayoutGrid(
                                                                itemBuilder:
                                                                    (_, index) {
                                                                  return Card(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {},
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                const BorderRadius.only(
                                                                              topLeft: Radius.circular(10.0),
                                                                              topRight: Radius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                CustomImage(
                                                                              imageUrl: filterproductsList[index].imageUrl,
                                                                              imageWidth: double.infinity,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(
                                                                              vertical: 08.0,
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Text(
                                                                                  filterproductsList[index].title,
                                                                                  textAlign: TextAlign.center,
                                                                                  style: const TextStyle(
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: eatchTextBleu,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  currencyFormatter.format(filterproductsList[index].price),
                                                                                  style: const TextStyle(
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: eatchJaune,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                itemCount:
                                                                    filterproductsList
                                                                        .length,
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 15.0,
                            bottom: 15.0,
                            left: 15.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.white,
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Text(
                                    "Menus",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: eatchTextBleu,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CustomScrollView(
                                  slivers: [
                                    ResponsiveSliverCenter(
                                      child: menusList.isEmpty
                                          ? const Center(
                                              child: Text(
                                                'Aucun menu trouvé',
                                              ),
                                            )
                                          : MenusLayoutGrid(
                                              itemCount: menusList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final menu = menusList[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 15,
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 05.0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: eatchTextGris
                                                              .withOpacity(0.1),
                                                          width: 01.0,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(07.0),
                                                        ),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      height: 50,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  menu.title,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        eatchTextBleu,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      currencyFormatter
                                                                          .format(
                                                                              menu.price),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color:
                                                                            eatchJaune,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      menu.description,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            eatchTextGris,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 05.0),
                                                          ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  07.0),
                                                            ),
                                                            child: CustomImage(
                                                              imageUrl:
                                                                  menu.imageUrl,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
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
