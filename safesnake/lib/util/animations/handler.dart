import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

///Animations Handler
class AnimationsHandler {
  ///Asset Animation
  static LottieBuilder asset({
    required String animation,
    Animation<double>? controller,
    bool? animateAutomatically,
    bool? repeat,
    bool? reverse,
    double? height = 200.0,
    BoxFit? fit,
  }) {
    return LottieBuilder.asset(
      "assets/anim/$animation.json",
      controller: controller,
      repeat: repeat,
      height: height,
      frameRate: FrameRate.max,
      filterQuality: FilterQuality.high,
      animate: animateAutomatically ?? true,
      reverse: reverse,
      fit: fit,
    );
  }
}
