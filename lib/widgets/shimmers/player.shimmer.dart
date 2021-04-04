import 'package:flutter/material.dart';

class PlayerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      height: 125,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // color: Colors.white,
          border: Border.all(width: 1, color: Colors.grey[300])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 100.0,
              height: 100.0,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 80,
                  height: 8.0,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 100,
                  height: 8.0,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 60,
                  height: 8.0,
                  color: Colors.white,
                ),
              ],
            )
          ]),
          Container(
            width: double.infinity,
            height: 8.0,
            color: Colors.white,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
          ),
          Container(
            width: double.infinity,
            height: 8.0,
            color: Colors.white,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
          ),
          Container(
            width: 40.0,
            height: 8.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
