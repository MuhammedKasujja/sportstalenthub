import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget{
  @override
  _SearchPageState createState() {
    return _SearchPageState();
  }

}

class _SearchPageState extends State<SearchPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(hintText: 'Search',
           hintStyle: TextStyle(color: Colors.white),
            suffixIcon: Icon(Icons.search)
         ),
        ),
      ),
      body: Container(

      ),
    );
  }

}