import 'package:app/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CachedOnlineIMG extends StatelessWidget {
  const CachedOnlineIMG({
    Key? key,
    required this.imageURL,
    this.imageHeight = 100,
  }) : super(key: key);

  final String imageURL;
  final int imageHeight;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageURL,
      fit: BoxFit.fill,
      height: imageHeight.h,
      width: double.infinity,
      placeholder: (context, url) => Padding(
        padding: const EdgeInsets.all(30.0),
        child: Image.asset('assets/images/loading_spinner.gif'),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.error_outline,
        color: kGreenColor,
        size: 40,
      ),
    );
  }
}
