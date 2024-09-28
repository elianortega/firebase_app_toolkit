import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/l10n/l10n.dart';

@visibleForTesting
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueSetter<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          key: const Key('bottomNavBar_topStories'),
          icon: const Icon(Icons.home_outlined),
          label: context.l10n.bottomNavBarOption1,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.search,
            key: Key('bottomNavBar_search'),
          ),
          label: context.l10n.bottomNavBarOption2,
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
