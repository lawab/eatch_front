import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    Key? key,
    required this.imageUrl,
    this.imageWidth,
    this.imageHeight,
    this.fit,
  }) : super(key: key);
  final String imageUrl;
  final double? imageWidth;
  final double? imageHeight;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageUrl,
      width: imageWidth,
      height: imageHeight,
      fit: fit,
    );
  }
}

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    Key? key,
    required this.imageUrl,
    this.imageWidth,
    this.imageHeight,
    this.imageColor,
  }) : super(key: key);
  final String imageUrl;
  final double? imageWidth;
  final double? imageHeight;
  final ColorFilter? imageColor;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imageUrl,
      width: imageWidth,
      height: imageHeight,
      colorFilter: imageColor,
    );
  }
}
