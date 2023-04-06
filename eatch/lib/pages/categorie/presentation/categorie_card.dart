import 'package:flutter/material.dart';

import '../../../utils/couleurs/couleurs.dart';
import '../../../utils/images/image.dart';
import '../../produit/infrastructure/produits_repository.dart';
import '../domain/categorie.dart';
import '../infrastructure/categories_repository.dart';

class CategorieCard extends StatefulWidget {
  const CategorieCard({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.categorie,
    required this.onPress,
  });
  final int index;
  final int selectedIndex;
  final Categorie categorie;
  final VoidCallback onPress;

  @override
  State<CategorieCard> createState() => _CategorieCardState();
}

class _CategorieCardState extends State<CategorieCard> {
  final productsList = ProductsRepository.instance.getProductsList();
  final categoriesList = CategoriesRepository.instance.getCategoriesList();
  @override
  Widget build(BuildContext context) {
    final filterproductsLenth = productsList.where((prod) {
      return prod.categories.contains(categoriesList[widget.index].id);
    }).toList();

    return InkWell(
      onTap: widget.onPress,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          border: Border.all(
            color: (widget.selectedIndex == widget.index)
                ? eatchJaune
                : eatchJauneThird,
            width: 01.0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(07.0),
          ),
          color: (widget.selectedIndex == widget.index)
              ? eatchJaune
              : eatchJauneSecond,
        ),
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 500),
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 06.0,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(08.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(05.0),
                  ),
                  color: eatchJauneThird,
                ),
                child: CustomIcon(
                  imageUrl: widget.categorie.imageUrl,
                  imageWidth: 18.0,
                  imageColor: (widget.selectedIndex == widget.index)
                      ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                      : const ColorFilter.mode(eatchJaune, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 05.0),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.categorie.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: (widget.selectedIndex == widget.index)
                          ? Colors.white
                          : eatchTextBleu,
                    ),
                  ),
                  Text(
                    filterproductsLenth.length > 1
                        ? '${filterproductsLenth.length} Produits'
                        : '${filterproductsLenth.length} Produit',
                    style: TextStyle(
                      fontSize: 10,
                      color: (widget.selectedIndex == widget.index)
                          ? Colors.white
                          : eatchTextGris,
                    ),
                  ),
                ],
              )),
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: eatchJauneThird),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                  color: (widget.selectedIndex == widget.index)
                      ? Colors.white
                      : eatchJaune,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
