import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/utils/extensions.dart';
import '../../gen/assets.gen.dart';

class LoadingBtn extends StatelessWidget {
  const LoadingBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      MyAssets.lottie.loadingA.path,
      width: 40,
      fit: BoxFit.cover,
    ).center;
  }
}

class LoadingApp extends StatelessWidget {
  final double? height;
  const LoadingApp({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 90,
      child: Lottie.asset(
        MyAssets.lottie.loadingA.path,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      ).center,
    ).center;
  }
}

class CustomProgress extends StatelessWidget {
  final double size;
  final double? strokeWidth;
  final Color? color;
  const CustomProgress({
    super.key,
    required this.size,
    this.strokeWidth,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth ?? 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? context.theme!.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
