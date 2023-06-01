// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../servicesAPI/get_categories.dart';
import '../../../utils/palettes/palette.dart';

class CategorieCard extends ConsumerStatefulWidget {
  const CategorieCard({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.categorie,
    required this.onPress,
    required this.onTapEdit,
    required this.onTapDelete,
  });
  final int index;
  final int selectedIndex;
  final Categorie categorie;
  final VoidCallback onPress;
  final VoidCallback onTapEdit;
  final VoidCallback onTapDelete;

  @override
  CategorieCardState createState() => CategorieCardState();
}

class CategorieCardState extends ConsumerState<CategorieCard> {
  // final productsList = ProductsRepository.instance.getProductsList();
  //  final categoriesList = CategoriesRepository.instance.getCategoriesList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.only(right: 5),
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
                          child: const Icon(Icons.ac_unit),
                          // child: SvgPicture.asset(
                          //   widget.categorie.image!,
                          //   width: 18.0,
                          //   color: (widget.selectedIndex == widget.index)
                          //       ? Palette.primaryBackgroundColor
                          //       : Palette.primaryColor,
                          // ),
                        ),
                        const SizedBox(width: 05.0),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.categorie.title!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: (widget.selectedIndex == widget.index)
                                    ? Colors.white
                                    : Palette.textPrimaryColor,
                              ),
                            ),
                            Text(
                              widget.categorie.products!.length.toString(),
                              style: TextStyle(
                                fontSize: 08.0,
                                color: (widget.selectedIndex == widget.index)
                                    ? Colors.white
                                    : Palette.textsecondaryColor,
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      color: Palette.primaryBackgroundColor,
                      child: InkWell(
                        onTap: widget.onTapEdit,
                        hoverColor: Colors.transparent,
                        splashColor: Palette.primaryBackgroundColor,
                        child: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Palette.primaryBackgroundColor,
                      child: InkWell(
                        onTap: widget.onTapDelete,
                        hoverColor: Colors.transparent,
                        child: const Icon(Icons.delete,
                            color: Palette.deleteColors),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
