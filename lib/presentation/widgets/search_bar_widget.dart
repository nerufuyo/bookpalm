import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/localization/localization_service.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(String) onSearchSubmitted;

  const SearchBarWidget({
    super.key,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      widget.onSearchChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationService>(
      init: LocalizationService.instance,
      builder: (localization) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {}); // Rebuild to show/hide clear button
            _onSearchChanged(value);
          },
          onSubmitted: widget.onSearchSubmitted,
          decoration: InputDecoration(
            hintText: LocalizationService.instance.translate(
              'pages.home.searchHint',
            ),
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500]),
                    onPressed: () {
                      _controller.clear();
                      setState(() {});
                      widget.onSearchChanged('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}
