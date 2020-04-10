import 'package:flutter/material.dart';

class LoadingIcon extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Image.asset('assets/images/loading.gif')
    );
  }

}