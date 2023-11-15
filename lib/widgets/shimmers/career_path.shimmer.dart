import 'package:flutter/material.dart';

class CareerPathShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        // color: Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 100.0,
              height: 10.0,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 100.0,
              height: 10.0,
              color: Colors.white,
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 8.0,
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
                width: MediaQuery.of(context).size.width - 100,
                height: 8.0,
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
                width: MediaQuery.of(context).size.width - 80,
                height: 8.0,
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 40.0,
                height: 8.0,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
