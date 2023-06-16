import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../servicesAPI/get_categories.dart';
import '../../utils/applayout.dart';
import '../../utils/palettes/palette.dart';
import '../../utils/size/size.dart';
import '../categories/presentation/categorie_card.dart';
import '../categories/presentation/modification_categorie.dart';
import '../menus/presentation/menu_grid.dart';

import '../produits/presentation/product_grid.dart';

class DashboardManager extends ConsumerStatefulWidget {
  const DashboardManager({
    super.key,
  });

  @override
  DashboardManagerState createState() => DashboardManagerState();
}

class DashboardManagerState extends ConsumerState<DashboardManager> {
  int selectedIndexCategorie = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataCategoriesFuture);
    SizeConfig().init(context);
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
                    child: ManagerGrid(
                      crossAxisCount: MediaQuery.of(context).size.width < 840
                          ? 03
                          : MediaQuery.of(context).size.width < 1242
                              ? 04
                              : 05,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              /**
                !DEUXIEME LIGNE 
                               **/
              Row(
                children: [
                  Expanded(
                    flex: MediaQuery.of(context).size.width < 530
                        ? 1
                        : MediaQuery.of(context).size.width < 578
                            ? 3
                            : MediaQuery.of(context).size.width < 663
                                ? 3
                                : MediaQuery.of(context).size.width < 752
                                    ? 2
                                    : 1,
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
                                child: viewModel.listCategories.isEmpty
                                    ? Container()
                                    : GridView.builder(
                                        itemCount:
                                            viewModel.listCategories.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 01,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 4.1,
                                        ),
                                        itemBuilder: (context, index) {
                                          return CategorieCard(
                                            categorie:
                                                viewModel.listCategories[index],
                                            index: index,
                                            onPress: () {
                                              setState(() {
                                                selectedIndexCategorie = index;
                                                _pageController
                                                    .jumpToPage(index);
                                              });
                                            },
                                            selectedIndex:
                                                selectedIndexCategorie,
                                            onTapDelete: () {
                                              dialogDelete(viewModel
                                                  .listCategories[index]
                                                  .title!);
                                            },
                                            onTapEdit: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return ModificationCategorie(
                                                    nomCategorie: viewModel
                                                        .listCategories[index]
                                                        .title!,
                                                    imageUrl: viewModel
                                                        .listCategories[index]
                                                        .image!,
                                                    sId: viewModel
                                                        .listCategories[index]
                                                        .sId!,
                                                  );
                                                }),
                                              );
                                            },
                                          );
                                        }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: MediaQuery.of(context).size.width < 530
                        ? 1
                        : MediaQuery.of(context).size.width < 578
                            ? 5
                            : MediaQuery.of(context).size.width < 663
                                ? 6
                                : MediaQuery.of(context).size.width < 752
                                    ? 5
                                    : 3,
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
                                    viewModel.listCategories.isEmpty
                                        ? ''
                                        : viewModel
                                            .listCategories[
                                                selectedIndexCategorie]
                                            .title!,
                                    // viewModel
                                    //     .listCategories[selectedIndexCategorie]
                                    //     .title!,
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
                                    viewModel.listCategories.isEmpty
                                        ? const Center(
                                            child: Text(
                                              'Aucun Produit trouvé',
                                            ),
                                          )
                                        : viewModel
                                                .listCategories[
                                                    selectedIndexCategorie]
                                                .products!
                                                .isEmpty
                                            ? const Center(
                                                child: Text(
                                                  'Aucun Produit trouvé',
                                                ),
                                              )
                                            : ProductsGrid(
                                                filterproductsList: viewModel
                                                    .listCategories[
                                                        selectedIndexCategorie]
                                                    .products!,
                                                crossAxisCount: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width <
                                                        530
                                                    ? 1
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width <
                                                            605
                                                        ? 02
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .width <
                                                                731
                                                            ? 03
                                                            : 04,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 10,
                                                childAspectRatio: 1 / 1.19,
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
                  if (MediaQuery.of(context).size.width > 1104)
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
              if (MediaQuery.of(context).size.width <= 1104)
                const SizedBox(height: 10),
              if (MediaQuery.of(context).size.width <= 1104)
                Card(
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
                          MenuGrid(
                            crossAxisCount:
                                MediaQuery.of(context).size.width < 473
                                    ? 02
                                    : MediaQuery.of(context).size.width <= 680
                                        ? 03
                                        : 4,
                            mainAxisSpacing: 30,
                            crossAxisSpacing: 30,
                            childAspectRatio: 3.1,
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
    );
  }

  Future dialogDelete(String nomcategorie) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(
                child: Text(
                  "Confirmez la suppression",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: [
                ElevatedButton.icon(
                    icon: const Icon(
                      Icons.close,
                      size: 14,
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    label: const Text("Quitter   ")),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.delete,
                    size: 14,
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {},
                  label: const Text("Supprimer."),
                )
              ],
              content: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  height: 150,
                  child: Text(
                    "Voulez vous supprimer la catégorie $nomcategorie?",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  )));
        });
  }
}

class ManagerGrid extends StatelessWidget {
  const ManagerGrid({
    super.key,
    this.crossAxisCount = 05,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 10,
    this.childAspectRatio = 1,
  });
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 05,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        shadowColor: Palette.fourthColor,
        child: const Center(
          child: Text("DDDDDDDDDDDDDDDDDDD"),
        ),
      ),
    );
  }
}
