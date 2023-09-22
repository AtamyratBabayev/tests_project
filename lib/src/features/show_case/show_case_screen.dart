import 'package:flutter/material.dart';
import 'package:tests_project/src/features/show_case/widgets/show_case_widget.dart';

class ShowCaseScreen extends StatefulWidget {
  const ShowCaseScreen({super.key});

  @override
  State<ShowCaseScreen> createState() => _ShowCaseScreenState();
}

class _ShowCaseScreenState extends State<ShowCaseScreen> {
  OverlayEntry? _entry;
  final elevatedButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.favorite),
          key: elevatedButtonKey,
          onPressed: () {
            _showOverlay(context);
          },
        ),
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox =
        elevatedButtonKey.currentContext!.findRenderObject() as RenderBox;
    _entry = OverlayEntry(builder: (context) {
      return ShowCaseWidget(
        renderBox,
        onAnimationFinished: () {
          _entry!.remove();
          _entry = null;
        },
      );
    });

    overlay.insert(_entry!);
  }

  @override
  void dispose() {
    _entry?.remove();
    _entry = null;
    super.dispose();
  }
}
