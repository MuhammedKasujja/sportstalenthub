import 'package:flutter/material.dart';

class PostShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // color: Colors.white,
          border: Border.all(width: 1, color: Colors.grey[500])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 200.0,
            color: Colors.white,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 8.0,
            color: Colors.white,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: 8.0,
            color: Colors.white,
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 60.0,
              height: 8.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
