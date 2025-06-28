import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationService>(
      init: LocalizationService.instance,
      builder: (localization) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/');
                  break;
                case 1:
                  context.go('/bookmarks');
                  break;
                case 2:
                  context.go('/settings');
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: LocalizationService.instance.translate(
                  'navigation.home',
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bookmark),
                label: LocalizationService.instance.translate(
                  'navigation.bookmarks',
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: LocalizationService.instance.translate(
                  'navigation.settings',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
