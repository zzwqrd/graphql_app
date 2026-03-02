import 'package:flutter/material.dart';

extension GifGenImage on String {
  Widget gif({double? width, double? height, BoxFit? fit}) {
    return Image.asset(
      this,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
    );
  }
}
