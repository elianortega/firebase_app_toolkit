import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const path = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text('Tu Estudio'),
      ),
      body: Column(),
    );
  }
}














// return Scaffold(
    //   body: Padding(
    //     padding: const EdgeInsets.symmetric(
    //       horizontal: AppSpacing.lg,
    //     ),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Assets.images.logoDark.image(
    //           height: 64,
    //         ),
    //         const SizedBox(height: AppSpacing.xxlg),
    //         AppButton.black(
    //           key: const Key('landingPage_login_button'),
    //           onPressed: () {
    //             context.push<void>(LoginPage.path);
    //           },
    //           child: const Text('Login'),
    //         ),
    //         const SizedBox(height: AppSpacing.md),
    //         AppButton.black(
    //           key: const Key('landingPage_signUp_button'),
    //           onPressed: () {
    //             context.push<void>(LoginPage.path);
    //           },
    //           child: const Text('Sign Up'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );