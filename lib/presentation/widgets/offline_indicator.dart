import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/connection_service.dart';

class OfflineIndicator extends StatelessWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final connectionService = Get.find<ConnectionService>();

    return Obx(() {
      if (connectionService.isConnected) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          border: Border(
            bottom: BorderSide(color: Colors.orange.shade300, width: 1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 16, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'You\'re offline. Showing cached content.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.info_outline, size: 16, color: Colors.orange.shade700),
          ],
        ),
      );
    });
  }
}

class OfflineWrapper extends StatelessWidget {
  final Widget child;
  final bool showIndicator;

  const OfflineWrapper({
    super.key,
    required this.child,
    this.showIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showIndicator) const OfflineIndicator(),
        Expanded(child: child),
      ],
    );
  }
}
