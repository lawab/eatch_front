import 'package:flutter/material.dart';

import '../../../../../utils/currency_formatter.dart';
import '../../../commons_widgets/custom_image.dart';
import '../../domain/categorie.dart';

/// Used to show a single product inside a card.
class CategorieCard extends StatelessWidget {
  const CategorieCard({
    Key? key,
    required this.categorie,
    this.onPressed,
  }) : super(key: key);
  final Categorie categorie;
  final VoidCallback? onPressed;

  // * Keys for testing using find.byKey()
  static const productCardKey = Key('product-card');

  @override
  Widget build(BuildContext context) {
    final priceFormatted = kCurrencyFormatter.format(categorie.price);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        key: productCardKey,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 05.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: CustomImage(imageUrl: categorie.imageUrl),
              ),
              Text(
                categorie.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111A45),
                ),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
              Text(
                priceFormatted,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf09f1b),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
