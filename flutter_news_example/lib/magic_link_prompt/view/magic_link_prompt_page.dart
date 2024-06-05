import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/magic_link_prompt/magic_link_prompt.dart';

class MagicLinkPromptPage extends StatelessWidget {
  const MagicLinkPromptPage({required this.email, super.key});

  final String email;

  static Route<void> route({required String email}) {
    return MaterialPageRoute<void>(
      builder: (_) => MagicLinkPromptPage(email: email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        actions: [
          IconButton(
            key: const Key('magicLinkPrompt_closeIcon'),
            icon: const Icon(Icons.close),
            onPressed: () {},
          ),
        ],
      ),
      body: MagicLinkPromptView(
        email: email,
      ),
    );
  }
}
