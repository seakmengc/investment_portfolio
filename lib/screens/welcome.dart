import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  goToSignUpScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    final bodyStyle = TextStyle(fontSize: 19.0);

    final pageDecoration = PageDecoration(
      bodyAlignment: Alignment.center,
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.all(7),
    );

    final listPagesViewModel = [
      PageViewModel(
        title: "Investment portfolio.",
        body:
            "Whether you are interested in investing in cryptocurrency, stock market, etc.",
        image: Lottie.asset('assets/animations/intro-1.json'),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "The easiest and most beautiful investment app.",
        body:
            "Our revolutionary investment tracker app provides an effective way for you to get a clear overview of your investments.",
        image: Lottie.asset('assets/animations/intro-2.json'),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Always and everywhere.",
        body:
            "Access your portofolio anytime and anywhere. Moreover, It's free to use.",
        image: Lottie.asset('assets/animations/intro-3.json'),
        decoration: pageDecoration,
      ),
    ];

    return IntroductionScreen(
      pages: listPagesViewModel,
      onDone: () => goToSignUpScreen(context),
      onSkip: () => goToSignUpScreen(context),
      showSkipButton: true,
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).accentColor,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
