import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final Function(String) onTextChange;
  final Function()? backPressed;
  final String hint = 'Search';

  const SearchWidget({
    super.key,
    required this.onTextChange,
    hint,
    this.backPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      elevation: 9.0,
      child: Row(
        children: <Widget>[
          backPressed != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.red),
                  onPressed: backPressed)
              : IconButton(
                  icon: const Icon(Icons.search, color: Colors.red),
                  onPressed: () {},
                ),
          Expanded(
            child: TextField(
              // autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16.0),
                hintText: hint,
              ),
              onChanged: onTextChange,
            ),
          )
        ],
      ),
    );
  }
}
