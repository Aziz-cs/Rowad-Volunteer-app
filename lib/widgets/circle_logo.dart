import 'package:flutter/material.dart';

class RowadCircleLogo extends StatelessWidget {
  const RowadCircleLogo({
    Key? key,
    this.radius = 22,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1.2,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: Image.asset("assets/images/avatar.png").image,
      ),
    );
  }
}
