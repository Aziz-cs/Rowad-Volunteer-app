import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(
          color: kGreenColor,
        ),
      ),
    );
  }
}
