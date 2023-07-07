import 'package:eatch/pages/produits/presentation/produit_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../servicesAPI/get_categories.dart';
import 'product_card.dart';

class ProductsGrid extends ConsumerStatefulWidget {
  const ProductsGrid({
    Key? key,
    required this.filterproductsList,
    this.crossAxisCount = 04,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 10,
    this.childAspectRatio = 1 / 1.19,
  }) : super(key: key);

  final List<Products> filterproductsList;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  @override
  ProductsGridState createState() => ProductsGridState();
}

class ProductsGridState extends ConsumerState<ProductsGrid> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 15.0,
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.filterproductsList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            crossAxisSpacing: widget.crossAxisSpacing,
            mainAxisSpacing: widget.mainAxisSpacing,
            childAspectRatio: widget.childAspectRatio,
          ),
          itemBuilder: (context, index) => ProductCard(
            imageUrl: widget.filterproductsList[index].image!,
            price: widget.filterproductsList[index].price!,
            title: widget.filterproductsList[index].productName!,
            onTapProduitCard: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Produitpage(
                    imageUrl: widget.filterproductsList[index].image!,
                    price: widget.filterproductsList[index].price!,
                    title: widget.filterproductsList[index].productName!,
                    sId: widget.filterproductsList[index].sId!,
                    category: widget.filterproductsList[index].category!,
                    quantity: widget.filterproductsList[index].quantity!,
                    recette: widget.filterproductsList[index].recette!,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
