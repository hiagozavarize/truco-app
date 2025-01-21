import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:truco/screens/home.dart";
import "package:truco/utils/app_images.dart";

class TrucoIntro extends StatefulWidget {
  static const String screenName = "/trucoIntro";
  const TrucoIntro({super.key});

  @override
  State<TrucoIntro> createState() => __TrucoIntroStateState();
}

class __TrucoIntroStateState extends State<TrucoIntro> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      Navigator.of(context).pushReplacementNamed(HomeScreen.screenName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          AppImages.trucoIntro,
          fit: BoxFit.cover,
        ).animate().fadeIn(duration: const Duration(seconds: 1)),
      )),
    );
  }
}
