// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../servicesAPI/getMenu.dart';
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

class MenuGrid extends ConsumerStatefulWidget {
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
  ConsumerState<MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends ConsumerState<MenuGrid> {
  @override
  Widget build(BuildContext context) {
    final viewModel1 = ref.watch(getDataMenuFuture);

    return Expanded(
      child: SingleChildScrollView(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: viewModel1.listMenus.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            mainAxisSpacing: widget.mainAxisSpacing,
            crossAxisSpacing: widget.crossAxisSpacing,
            childAspectRatio: widget.childAspectRatio,
          ),
          itemBuilder: (context, index) => MenuCard(
            description: viewModel1.listMenus[index].description!,
            imageUrl: viewModel1.listMenus[index].image!,
            price: viewModel1.listMenus[index].price!,
            title: viewModel1.listMenus[index].menuTitle!,
            sId: viewModel1.listMenus[index].sId!,
            index: index,
            products: viewModel1.listMenus[index].products!,
          ),
        ),
      ),
    );
  }
}
