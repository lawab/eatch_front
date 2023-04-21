// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../utils/applayout.dart';
import '../../utils/palettes/palette.dart';
import '../../utils/size/size.dart';
import '../categories/infrastructure/categories_repository.dart';
import '../categories/presentation/categorie_card.dart';
import '../menus/presentation/menu_grid.dart';
import '../produits/infrastructure/produits_repository.dart';
import '../produits/presentation/product_grid.dart';

class DashboardManager extends StatefulWidget {
  const DashboardManager({
    super.key,
  });

  @override
  State<DashboardManager> createState() => _DashboardManagerState();
}

class _DashboardManagerState extends State<DashboardManager> {
  int selectedIndexCategorie = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final filterproductsList = productsList.where((prod) {
      return prod.categories
          .contains(categoriesList[selectedIndexCategorie].id);
    }).toList();
    return AppLayout(
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            top: 10,
          ),
          color: Palette.secondaryBackgroundColor,
          child: Column(
            children: [
              /**
                !PREMIERE LIGNE 
                                **/
              Row(
                children: [
                  Expanded(
                      child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 05,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 05,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) => Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      shadowColor: Palette.fourthColor,
                    ),
                  ))
                ],
              ),
              const SizedBox(height: 10),
              /**
                !DEUXIEME LIGNE 
                               **/
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      shadowColor: Palette.fourthColor,
                      child: SizedBox(
                        height: getProportionateScreenHeight(605.0),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            bottom: 10.0,
                            left: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.white,
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 10.0,
                                    right: 10.0,
                                  ),
                                  child: Text(
                                    "Catégories",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.textPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: categoriesList.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 01,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 4.1,
                                    ),
                                    itemBuilder: (context, index) =>
                                        CategorieCard(
                                      categorie: categoriesList[index],
                                      index: index,
                                      onPress: () {
                                        setState(() {
                                          selectedIndexCategorie = index;
                                          _pageController.jumpToPage(index);
                                        });
                                      },
                                      selectedIndex: selectedIndexCategorie,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      shadowColor: Palette.fourthColor,
                      child: SizedBox(
                        height: getProportionateScreenHeight(605.0),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            bottom: 10.0,
                            left: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10.0,
                                    right: 10.0,
                                  ),
                                  child: Text(
                                    categoriesList[selectedIndexCategorie]
                                        .title,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.textPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              //LES PRODUITS
                              Expanded(
                                child: PageView(
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: _pageController,
                                  children: [
                                    for (var i = 0;
                                        i < categoriesList.length;
                                        i++)
                                      filterproductsList.isEmpty
                                          ? const Center(
                                              child: Text(
                                                'Aucun Produit trouvé',
                                              ),
                                            )
                                          : ProductsGrid(
                                              filterproductsList:
                                                  filterproductsList,
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
                  Expanded(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      shadowColor: Palette.fourthColor,
                      child: SizedBox(
                        height: getProportionateScreenHeight(605.0),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            bottom: 10.0,
                            left: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.white,
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 10.0,
                                    right: 10.0,
                                  ),
                                  child: Text(
                                    "Menus",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.textPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              //LES CATEGORIES
                              const MenuGrid(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
