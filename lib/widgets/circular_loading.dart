import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  CircularLoading({
    Key? key,
    this.color = kGreenColor,
  }) : super(key: key);
  Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(
          color: color,
        ),
      ),
    );
  }
}
