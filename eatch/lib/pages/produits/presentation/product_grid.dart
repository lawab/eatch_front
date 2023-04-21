import 'package:flutter/material.dart';

import '../domain/produit.dart';
import 'product_card.dart';

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({
    Key? key,
    required this.filterproductsList,
    this.crossAxisCount = 04,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 10,
    this.childAspectRatio = 1 / 1.19,
  }) : super(key: key);

  final List<Product> filterproductsList;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
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
            imageUrl: widget.filterproductsList[index].imageUrl,
            price: widget.filterproductsList[index].price,
            title: widget.filterproductsList[index].title,
            filterproductsList: widget.filterproductsList,
          ),
        ),
      ),
    );
  }
}
