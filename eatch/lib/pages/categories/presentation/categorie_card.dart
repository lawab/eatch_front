// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../produits/infrastructure/produits_repository.dart';
import '../infrastructure/categories_repository.dart';
import '../../../utils/palettes/palette.dart';
import '../domain/categorie.dart';

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
  // final productsList = ProductsRepository.instance.getProductsList();
  //  final categoriesList = CategoriesRepository.instance.getCategoriesList();

  @override
  Widget build(BuildContext context) {
    final filterproductsLenth = productsList.where((prod) {
      return prod.categories.contains(categoriesList[widget.index].id);
    }).toList();

    return Container(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: widget.onPress,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            border: Border.all(
              color: (widget.selectedIndex == widget.index)
                  ? Palette.primaryColor
                  : Palette.fourthColor,
              width: 01.0,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            color: (widget.selectedIndex == widget.index)
                ? Palette.primaryColor
                : Palette.tertiaryColor,
          ),
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 500),
          // height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 06.0,
              horizontal: 06.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(05.0),
                    ),
                    color: (widget.selectedIndex == widget.index)
                        ? Palette.secondaryColor
                        : Palette.fourthColor,
                  ),
                  child: SvgPicture.asset(
                    widget.categorie.imageUrl,
                    width: 18.0,
                    color: (widget.selectedIndex == widget.index)
                        ? Palette.primaryBackgroundColor
                        : Palette.primaryColor,
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
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: (widget.selectedIndex == widget.index)
                            ? Colors.white
                            : Palette.textPrimaryColor,
                      ),
                    ),
                    Text(
                      filterproductsLenth.length >= 1
                          ? filterproductsLenth.length > 9
                              ? '${filterproductsLenth.length} Produits'
                              : '0${filterproductsLenth.length} Produits'
                          : '0${filterproductsLenth.length} Produit',
                      style: TextStyle(
                        fontSize: 08.0,
                        color: (widget.selectedIndex == widget.index)
                            ? Colors.white
                            : Palette.textsecondaryColor,
                      ),
                    ),
                  ],
                )),
                Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (widget.selectedIndex == widget.index)
                        ? Palette.secondaryColor
                        : Palette.fourthColor,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 8,
                    color: (widget.selectedIndex == widget.index)
                        ? Colors.white
                        : Palette.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
