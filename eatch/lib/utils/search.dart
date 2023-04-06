import 'package:flutter/material.dart';

import 'couleurs/couleurs.dart';

/// Search field used to filter products by name
class SearchTextField extends StatefulWidget {
  const SearchTextField({Key? key}) : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        return TextField(
          controller: _controller,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: eatchJauneSecond,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                color: eatchJauneSecond,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                color: eatchJauneSecond,
              ),
            ),
            hintText: 'Recherche',
            hintStyle: const TextStyle(color: eatchJaune),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _controller.clear();
                    },
                    icon: const Icon(Icons.clear),
                  )
                : null,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Icon(
                Icons.search,
                color: eatchJaune,
              ),
            ),
          ),
          onChanged: null,
        );
      },
    );
  }
}
