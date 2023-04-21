import 'package:eatch/utils/palettes/palette.dart';
import 'package:flutter/material.dart';

class SearchCategories extends StatefulWidget {
  const SearchCategories({super.key});

  @override
  State<SearchCategories> createState() => _SearchCategoriesState();
}

class _SearchCategoriesState extends State<SearchCategories> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        return TextField(
          style: TextStyle(
            color: Palette.primaryColor.withOpacity(0.3),
          ),
          controller: _controller,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Palette.fourthColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            hintText: 'Recherche',
            hintStyle: TextStyle(
              color: Palette.primaryColor.withOpacity(0.3),
              fontSize: 15,
            ),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _controller.clear();
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: Palette.primaryColor.withOpacity(0.3),
                    ),
                  )
                : null,
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.search,
                color: Palette.primaryColor,
              ),
            ),
          ),
          onChanged: null,
        );
      },
    );
  }
}
