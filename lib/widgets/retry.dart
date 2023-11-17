import 'package:flutter/material.dart';

class RetryIcon extends StatelessWidget {
  final String message = "Try Again";

  const RetryIcon({super.key});
  @override
  Widget build(BuildContext context) {
    return Chip(
        backgroundColor: Colors.red,
        label: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ));
  }
}

class RetryAgainIcon extends StatelessWidget {
  final String message = "Try Again";
  final Function()? onTry;

  const RetryAgainIcon({super.key, required this.onTry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTry,
        child: Chip(
          backgroundColor: Colors.red,
          label: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
