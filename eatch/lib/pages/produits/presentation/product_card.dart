import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/palettes/palette.dart';
// import '../domain/produit.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.onTapProduitCard,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final int price;
  final VoidCallback onTapProduitCard;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Palette.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Palette.primaryBackgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: widget.onTapProduitCard,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Image.network(
                  'http://13.39.81.126:4003${widget.imageUrl}',
                  width: double.infinity,
                  height: 95,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Palette.textPrimaryColor,
                      ),
                    ),
                    Text(
                      NumberFormat.simpleCurrency(name: "MAD ")
                          .format(widget.price),
                      style: const TextStyle(
                        fontSize: 08.0,
                        fontWeight: FontWeight.bold,
                        color: Palette.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
