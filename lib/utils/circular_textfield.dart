import 'package:flutter/material.dart';

class ChipInputField extends StatelessWidget {
  final TextEditingController? controller;
  const ChipInputField({Key? key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: InputChip(
        avatar: Icon(
          Icons.cancel,
          color: Colors.red,
        ),
        label: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "search"),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 5.0,
        ),
      ),
    );
  }
}
