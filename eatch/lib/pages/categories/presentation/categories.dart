// ignore_for_file: avoid_function_literals_in_foreach_calls, unused_field, prefer_final_fields

import 'dart:convert';

import 'package:eatch/pages/produits/presentation/creation_produit.dart';
import 'package:eatch/servicesAPI/get_produits.dart' as products;
import 'package:eatch/servicesAPI/multipart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../servicesAPI/get_categories.dart';
import '../../../utils/applayout.dart';
import '../../../utils/default_button/default_button.dart';
import '../../../utils/palettes/palette.dart';
import '../../../utils/size/size.dart';
import '../../produits/presentation/product_grid.dart';
import 'categorie_card.dart';
import 'modification_categorie.dart';
import 'package:http/http.dart' as http;

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({
    super.key,
  });

  @override
  CategoriesPageState createState() => CategoriesPageState();
}

class CategoriesPageState extends ConsumerState<CategoriesPage> {
  // ***** LES VARIABLES ****** //
  bool isLoading = false;
  bool _selectFile = false;

  Uint8List? selectedImageInBytes;
  FilePickerResult? result;

  List<int> _selectedFile = [];
  bool filee = false;
  PlatformFile? file;
  String? recetteImage;
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //**********************/
  bool search = false;
  List<Categorie> categorieSearch = [];
  void filterCategorieResults(String query) {
    final viewModel = ref.watch(getDataCategoriesFuture);
    List<Categorie> dummySearchList = [];
    dummySearchList.addAll(viewModel.listCategories);
    if (query.isNotEmpty) {
      List<Categorie> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.title!.contains(query)) {
          dummyListData.add(item);
          //print(dummyListData);
        }
      });
      setState(() {
        search = true;
        categorieSearch.clear();
        categorieSearch.addAll(dummyListData);
        _controller.clear();
        searchProduit = false;
      });

      return;
    } else {
      setState(() {
        search = false;
        _controller.clear();
        searchProduit = false;
      });
      print("###################");
    }
  }

  int selectedIndexCategorie = 0;
  bool searchProduit = false;
  List<Products> produitSearch = [];
  void filterProduitResults(String query) {
    final viewModel = ref.watch(getDataCategoriesFuture);
    List<Products> dummySearchList = [];
    dummySearchList.addAll(
      search == false
          ? viewModel.listCategories[selectedIndexCategorie].products!
          : categorieSearch[selectedIndexCategorie].products!,
    );
    if (query.isNotEmpty) {
      List<Products> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.productName!.contains(query)) {
          dummyListData.add(item);
          //print(dummyListData);
        }
      });
      setState(() {
        searchProduit = true;
        produitSearch.clear();
        produitSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        searchProduit = false;
      });
      print("###################");
    }
  }

  bool _showContent = false;
  final _formKey = GlobalKey<FormState>();

  String _nomCategorie = "";

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataCategoriesFuture);
    final viewModelProduit = ref.watch(products.getDataProduitFuture);
    SizeConfig().init(context);
    return AppLayout(
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            top: 10,
          ),
          color: Palette.secondaryBackgroundColor,
          child: Column(children: [
            /**
                !PREMIERE LIGNE 
                                **/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("TOUTES LES CATÉGORIES"),
                if (!_showContent)
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showContent = !_showContent;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        color: Palette.primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.add,
                            color: Palette.primaryBackgroundColor,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 05.0,
                              ),
                              child: Text(
                                "Ajouter une catégorie",
                                style: TextStyle(
                                  color: Palette.primaryBackgroundColor,
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
            const SizedBox(height: 20),
            _showContent
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          nomCategorie(),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                color: Palette.secondaryBackgroundColor,
                                child: GestureDetector(
                                  onTap: () async {
                                    recetteImage = null;
                                    result = await FilePicker.platform
                                        .pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                          "png",
                                          "jpg",
                                          "jpeg",
                                        ]);
                                    if (result != null) {
                                      setState(() {
                                        file = result!.files.single;

                                        Uint8List fileBytes = result!
                                            .files.single.bytes as Uint8List;

                                        _selectedFile = fileBytes;

                                        filee = true;

                                        selectedImageInBytes =
                                            result!.files.first.bytes;
                                        _selectFile = true;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: const Color(0xFFDCE0E0),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: recetteImage != null
                                          ? Image.asset(
                                              recetteImage!,
                                              fit: BoxFit.fill,
                                            )
                                          : _selectFile == false
                                              ? const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: Color(0xFFDCE0E0),
                                                  size: 40,
                                                )
                                              : isLoading
                                                  ? const CircularProgressIndicator()
                                                  : Image.memory(
                                                      selectedImageInBytes!,
                                                      fit: BoxFit.fill,
                                                    ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 200,
                                child: DefaultButton(
                                  color: Palette.primaryColor,
                                  foreground: Colors.red,
                                  text: 'ENREGISTRER',
                                  textcolor: Palette.primaryBackgroundColor,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      creationCategorie(
                                        context,
                                        _selectedFile,
                                        result,
                                        _nomCategorie,
                                      );
                                    } else {
                                      print("Bad");
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 200,
                                child: DefaultButton(
                                  color: Palette.secondaryBackgroundColor,
                                  foreground: Colors.red,
                                  text: 'ANNULER',
                                  textcolor: Palette.textsecondaryColor,
                                  onPressed: () {
                                    setState(() {
                                      _showContent = !_showContent;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: SizedBox(
                      width: 300,
                      child: TextField(
                        // onChanged: (value) => onSearch(value.toLowerCase()),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        onChanged: (value) {
                          filterCategorieResults(value);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Palette.fourthColor,
                          contentPadding: const EdgeInsets.all(0),
                          prefixIcon: const Icon(Icons.search,
                              color: Palette.primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          hintText: "Rechercher une catégorie ...",
                        ),
                      ),
                    ),
                  ),
            /**
                !DEUXIEME LIGNE 
                               **/
            Row(
              children: [
                Expanded(
                  flex: MediaQuery.of(context).size.width < 485
                      ? 1
                      : MediaQuery.of(context).size.width < 485
                          ? 3
                          : MediaQuery.of(context).size.width < 530
                              ? 2
                              : MediaQuery.of(context).size.width < 635
                                  ? 4
                                  : MediaQuery.of(context).size.width < 1000
                                      ? 3
                                      : 2,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    shadowColor: Palette.fourthColor,
                    child: SizedBox(
                      height: getProportionateScreenHeight(760.0),
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
                                child: search == false
                                    ? viewModel.listCategories.isEmpty
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
                                                categorie: viewModel
                                                    .listCategories[index],
                                                index: index,
                                                onPress: () {
                                                  setState(() {
                                                    selectedIndexCategorie =
                                                        index;
                                                    _pageController
                                                        .jumpToPage(index);
                                                  });
                                                },
                                                selectedIndex:
                                                    selectedIndexCategorie,
                                                onTapDelete: () {
                                                  dialogDelete(
                                                    idcategorie: viewModel
                                                        .listCategories[index]
                                                        .sId!,
                                                    nomcategorie: viewModel
                                                        .listCategories[index]
                                                        .title!,
                                                  );
                                                },
                                                onTapEdit: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                      return ModificationCategorie(
                                                        title: viewModel
                                                            .listCategories[
                                                                index]
                                                            .title!,
                                                        image:
                                                            "http://192.168.11.110:4005${viewModel.listCategories[index].image}",
                                                        sId: viewModel
                                                            .listCategories[
                                                                index]
                                                            .sId!,
                                                      );
                                                    }),
                                                  );
                                                },
                                              );
                                            })
                                    : categorieSearch.isEmpty
                                        ? const Center(
                                            child: Text(
                                              'Aucune Catégorie trouvée',
                                            ),
                                          )
                                        : GridView.builder(
                                            itemCount: categorieSearch.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 01,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: 4.1,
                                            ),
                                            itemBuilder: (context, index) {
                                              print(
                                                  "##################################################################################################################################################################");

                                              return CategorieCard(
                                                categorie:
                                                    categorieSearch[index],
                                                index: index,
                                                onPress: () {
                                                  setState(() {
                                                    selectedIndexCategorie =
                                                        index;
                                                    _pageController
                                                        .jumpToPage(index);
                                                  });
                                                },
                                                selectedIndex:
                                                    selectedIndexCategorie,
                                                onTapDelete: () {
                                                  dialogDelete(
                                                    idcategorie:
                                                        categorieSearch[index]
                                                            .sId!,
                                                    nomcategorie:
                                                        categorieSearch[index]
                                                            .title!,
                                                  );
                                                },
                                                onTapEdit: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                      return ModificationCategorie(
                                                        title: categorieSearch[
                                                                index]
                                                            .title!,
                                                        image:
                                                            "http://192.168.11.110:4005${categorieSearch[index].image}",
                                                        sId: categorieSearch[
                                                                index]
                                                            .sId!,
                                                      );
                                                    }),
                                                  );
                                                },
                                              );
                                            })),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: MediaQuery.of(context).size.width < 485
                      ? 1
                      : MediaQuery.of(context).size.width < 485
                          ? 4
                          : MediaQuery.of(context).size.width < 530
                              ? 3
                              : MediaQuery.of(context).size.width < 575
                                  ? 7
                                  : MediaQuery.of(context).size.width < 635
                                      ? 8
                                      : 7,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    shadowColor: Palette.fourthColor,
                    child: SizedBox(
                      height: getProportionateScreenHeight(760.0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                          left: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MediaQuery.of(context).size.width > 682
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10.0,
                                            right: 10.0,
                                          ),
                                          child: Text(
                                            search == false
                                                ? viewModel
                                                    .listCategories[
                                                        selectedIndexCategorie]
                                                    .title!
                                                : categorieSearch.isNotEmpty
                                                    ? categorieSearch[
                                                            selectedIndexCategorie]
                                                        .title!
                                                    : "",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Palette.textPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                            bottom: 10,
                                          ),
                                          child: SizedBox(
                                            width: 300,
                                            child: TextField(
                                              controller: _controller,
                                              // onChanged: (value) => onSearch(value.toLowerCase()),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                              onChanged: (value) {
                                                filterProduitResults(value);
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Palette.fourthColor,
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                prefixIcon: const Icon(
                                                    Icons.search,
                                                    color:
                                                        Palette.primaryColor),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  borderSide: BorderSide.none,
                                                ),
                                                hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade500,
                                                ),
                                                hintText:
                                                    "Rechercher un produit ...",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10.0,
                                            right: 10.0,
                                          ),
                                          child: Text(
                                            search == false
                                                ? viewModel
                                                    .listCategories[
                                                        selectedIndexCategorie]
                                                    .title!
                                                : categorieSearch.isNotEmpty
                                                    ? categorieSearch[
                                                            selectedIndexCategorie]
                                                        .title!
                                                    : "",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Palette.textPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                            bottom: 10,
                                          ),
                                          child: SizedBox(
                                            width: 200,
                                            child: TextField(
                                              controller: _controller,
                                              // onChanged: (value) => onSearch(value.toLowerCase()),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                              onChanged: (value) {
                                                filterProduitResults(value);
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Palette.fourthColor,
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                prefixIcon: const Icon(
                                                    Icons.search,
                                                    color:
                                                        Palette.primaryColor),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  borderSide: BorderSide.none,
                                                ),
                                                hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade500,
                                                ),
                                                hintText:
                                                    "Rechercher un produit ...",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            search == false
                                ? Expanded(
                                    child: PageView(
                                      scrollDirection: Axis.vertical,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      controller: _pageController,
                                      children: [
                                        viewModel
                                                .listCategories[
                                                    selectedIndexCategorie]
                                                .products!
                                                .isEmpty
                                            ? const Center(
                                                child: Text(
                                                  'Aucun Produit trouvé',
                                                ),
                                              )
                                            : searchProduit == false
                                                ? ProductsGrid(
                                                    filterproductsList: viewModel
                                                        .listCategories[
                                                            selectedIndexCategorie]
                                                        .products!,
                                                    crossAxisCount: MediaQuery
                                                                    .of(context)
                                                                .size
                                                                .width <
                                                            485
                                                        ? 1
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .width <
                                                                605
                                                            ? 02
                                                            : MediaQuery.of(context)
                                                                        .size
                                                                        .width <
                                                                    750
                                                                ? 03
                                                                : 04,
                                                    mainAxisSpacing: 10,
                                                    crossAxisSpacing: 10,
                                                    childAspectRatio: 1 / 1.19,
                                                  )
                                                : produitSearch.isEmpty
                                                    ? const Center(
                                                        child: Text(
                                                          'Aucun Produit trouvé',
                                                        ),
                                                      )
                                                    : produitSearch.isEmpty
                                                        ? const Center(
                                                            child: Text(
                                                              'Aucun Produit trouvé',
                                                            ),
                                                          )
                                                        : ProductsGrid(
                                                            filterproductsList:
                                                                produitSearch
                                                                        .isEmpty
                                                                    ? []
                                                                    : produitSearch,
                                                            crossAxisCount: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width <
                                                                    485
                                                                ? 1
                                                                : MediaQuery.of(context)
                                                                            .size
                                                                            .width <
                                                                        605
                                                                    ? 02
                                                                    : MediaQuery.of(context).size.width <
                                                                            750
                                                                        ? 03
                                                                        : 04,
                                                            mainAxisSpacing: 10,
                                                            crossAxisSpacing:
                                                                10,
                                                            childAspectRatio:
                                                                1 / 1.19,
                                                          ),
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: PageView(
                                      scrollDirection: Axis.vertical,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      controller: _pageController,
                                      children: [
                                        categorieSearch.isEmpty
                                            ? const Center(
                                                child: Text(
                                                  'Aucun Produit trouvé',
                                                ),
                                              )
                                            : categorieSearch[
                                                        selectedIndexCategorie]
                                                    .products!
                                                    .isEmpty
                                                ? const Center(
                                                    child: Text(
                                                      'Aucun Produit trouvé',
                                                    ),
                                                  )
                                                : searchProduit == false
                                                    ? ProductsGrid(
                                                        filterproductsList:
                                                            categorieSearch
                                                                    .isEmpty
                                                                ? []
                                                                : categorieSearch[
                                                                        selectedIndexCategorie]
                                                                    .products!,
                                                        crossAxisCount: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width <
                                                                485
                                                            ? 1
                                                            : MediaQuery.of(context)
                                                                        .size
                                                                        .width <
                                                                    605
                                                                ? 02
                                                                : MediaQuery.of(context)
                                                                            .size
                                                                            .width <
                                                                        750
                                                                    ? 03
                                                                    : 04,
                                                        mainAxisSpacing: 10,
                                                        crossAxisSpacing: 10,
                                                        childAspectRatio:
                                                            1 / 1.19,
                                                      )
                                                    : ProductsGrid(
                                                        filterproductsList:
                                                            produitSearch
                                                                    .isEmpty
                                                                ? []
                                                                : produitSearch,
                                                        crossAxisCount: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width <
                                                                485
                                                            ? 1
                                                            : MediaQuery.of(context)
                                                                        .size
                                                                        .width <
                                                                    605
                                                                ? 02
                                                                : MediaQuery.of(context)
                                                                            .size
                                                                            .width <
                                                                        750
                                                                    ? 03
                                                                    : 04,
                                                        mainAxisSpacing: 10,
                                                        crossAxisSpacing: 10,
                                                        childAspectRatio:
                                                            1 / 1.19,
                                                      ),
                                      ],
                                    ),
                                  ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    print(viewModel
                                        .listCategories[selectedIndexCategorie]
                                        .title!);
                                    print(viewModel
                                        .listCategories[selectedIndexCategorie]
                                        .sId!);
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return CreationProduit(
                                        categorieTitle: viewModel
                                            .listCategories[
                                                selectedIndexCategorie]
                                            .title!,
                                        categorieId: viewModel
                                            .listCategories[
                                                selectedIndexCategorie]
                                            .sId!,
                                      );
                                    }),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20),
                                    backgroundColor: Palette.primaryColor),
                                child: const Icon(
                                  Icons.add,
                                  color: Palette.primaryBackgroundColor,
                                  size: 20,
                                ),
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
          ]),
        ),
      ),
    );
  }

  Future dialogDelete({
    required String idcategorie,
    required String nomcategorie,
  }) {
    return showDialog(
        context: context,
        builder: (con) {
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
                  onPressed: () {
                    deleteCategorie(context, idcategorie);
                    Navigator.pop(con);
                  },
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

  Future<http.Response> deleteCategorie(BuildContext context, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userdelete = prefs.getString('IdUser').toString();
      var restaurantid = prefs.getString('idRestaurant');
      var token = prefs.getString('token');
      String urlDelete = "http://192.168.11.110:4005/api/categories/delete/$id";
      var json = {
        '_creator': userdelete,
        "restaurant_id": restaurantid!,
      };
      var body = jsonEncode(json);

      final http.Response response = await http.patch(
        Uri.parse(urlDelete),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
          'body': body,
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        ref.refresh(getDataCategoriesFuture);

        return response;
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  TextFormField nomCategorie() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      autocorrect: true,
      textCapitalization: TextCapitalization.characters,
      enableSuggestions: false,
      onEditingComplete: (() => FocusScope.of(context).requestFocus()),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "S'il vous plaît entrez le nom de l'utilisateur .";
        } else if (value.length < 2) {
          return "Ce champ doit contenir au moins 2 lettres.";
        }
        return null;
      },
      decoration: InputDecoration(
        hoverColor: Palette.primaryBackgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        filled: true,
        fillColor: Palette.primaryBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Palette.secondaryBackgroundColor),
          gapPadding: 10,
        ),
        prefix: const Padding(padding: EdgeInsets.only(left: 0.0)),
        hintText: "Titre Catégorie*",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/user.svg"),
      ),
      onSaved: (value) {
        _nomCategorie = value!;
      },
    );
  }

  Future<void> creationCategorie(
    contextt,
    selectedFile,
    result,
    String nomCategorie,
  ) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    String adressUrl = prefs.getString('ipport').toString();
    var restaurantid = prefs.getString('idRestaurant');
    print("categorie id resto  : $restaurantid");
    var url = Uri.parse(
        "http://192.168.11.110:4005/api/categories/create"); //13.39.81.126
    print(url);
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      'title': nomCategorie,
      'products': [],
      'user_id': id,
      "restaurant_id": restaurantid,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
        contentType: MediaType('application', 'octet-stream'),
        filename: result.files.first.name));

    print("RESPENSE SEND STEAM FILE REQ");
    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Catégorie Crée",
          ),
        );
        ref.refresh(getDataCategoriesFuture);
      } else {
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "Erreur de création",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}

class CustomSurffixIcon extends StatelessWidget {
  const CustomSurffixIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(5),
        getProportionateScreenWidth(5),
        getProportionateScreenWidth(5),
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: getProportionateScreenWidth(4),
        color: Palette.textsecondaryColor,
      ),
    );
  }
}
