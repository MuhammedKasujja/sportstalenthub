import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final Function(String) onTextChange;
  final Function backPressed;
  final String hint = 'Search';

  const SearchWidget(
      {Key key, @required this.onTextChange, hint, @required this.backPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0.0),
      elevation: 9.0,
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.red),
              onPressed: backPressed),
          Expanded(
              child: TextField(
            // autofocus: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16.0),
                hintText: hint),
            onChanged: onTextChange,
          ))
        ],
      ),
    );
  }
}
