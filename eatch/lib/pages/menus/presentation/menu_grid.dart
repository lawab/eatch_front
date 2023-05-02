// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../categories/infrastructure/categories_repository.dart';
import '../infrastructure/menus_repository.dart';
import 'menu_card.dart';

// class MenuGrid extends StatefulWidget {
//   const MenuGrid({
//     Key? key,
//     this.crossAxisCount = 1,
//     this.mainAxisSpacing = 10,
//     this.crossAxisSpacing = 00,
//     this.childAspectRatio = 3.1,
//   }) : super(key: key);

//   final int crossAxisCount;
//   final double mainAxisSpacing;
//   final double crossAxisSpacing;
//   final double childAspectRatio;

//   @override
//   State<MenuGrid> createState() => _MenuGridState();
// }

// class _MenuGridState extends State<MenuGrid> {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: SingleChildScrollView(
//         child: GridView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: categoriesList.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: widget.crossAxisCount,
//             mainAxisSpacing: widget.mainAxisSpacing,
//             crossAxisSpacing: widget.crossAxisSpacing,
//             childAspectRatio: widget.childAspectRatio,
//           ),
//           itemBuilder: (context, index) => MenuCard(
//             description: menusList[index].description,
//             imageUrl: menusList[index].imageUrl,
//             price: menusList[index].price,
//             title: menusList[index].title,
//           ),
//         ),
//       ),
//     );
//   }
// }

class MenuGrid extends StatelessWidget {
  const MenuGrid({
    super.key,
    this.crossAxisCount = 1,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 00,
    this.childAspectRatio = 3.1,
  });
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: menusList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) => MenuCard(
            description: menusList[index].description,
            imageUrl: menusList[index].imageUrl,
            price: menusList[index].price,
            title: menusList[index].title,
          ),
        ),
      ),
    );
  }
}
