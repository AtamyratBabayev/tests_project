import 'package:flutter/material.dart';
import 'package:tests_project/src/features/show_case/widgets/show_case_painter.dart';

/// Widget that show showCase.
///
/// * [renderBox] used to find position and size of widget.
class ShowCaseWidget extends StatefulWidget {
  const ShowCaseWidget(this.renderBox,
      {required this.onAnimationFinished, super.key});

  final RenderBox renderBox;

  final void Function() onAnimationFinished;

  @override
  State<ShowCaseWidget> createState() => _ShowCaseWidgetState();
}

class _ShowCaseWidgetState extends State<ShowCaseWidget>
    with TickerProviderStateMixin {
  // Staggered animation
  late final AnimationController _mainAnimation;

  // Bouncing animation of circles
  late final AnimationController _bouncingAnimation;

  @override
  void initState() {
    super.initState();
    _mainAnimation = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
        reverseDuration: const Duration(milliseconds: 500));
    _bouncingAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    // Start main animation
    _mainAnimation.forward();
    // On main animation finished start bouncing animation
    _mainAnimation.addListener(() {
      if (_mainAnimation.isCompleted) {
        _bouncingAnimation.forward();
      } else if (_mainAnimation.isDismissed) {
        widget.onAnimationFinished();
      }
    });
    // Make animation continuously
    _bouncingAnimation.addListener(() {
      if (_bouncingAnimation.isCompleted) {
        _bouncingAnimation.reverse();
      } else if (_bouncingAnimation.isDismissed) {
        _bouncingAnimation.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final centerPos = _getCorrectCenterPosition(widget.renderBox);
    final widgetSize = widget.renderBox.size;
    // Animation of circles on showcase started
    final openingCurvedAnimation = CurvedAnimation(
        parent: _mainAnimation,
        curve: const Interval(0.000, 0.400, curve: Curves.easeOutCubic));
    // Bouncing animation for circles
    final bouncingCurvedAnimation =
        CurvedAnimation(parent: _bouncingAnimation, curve: Curves.easeInOut);

    // Appearing animation of title
    final titleCurvedAnimation = CurvedAnimation(
        parent: _mainAnimation,
        curve: const Interval(0.400, 0.600, curve: Curves.easeOutCubic));

    // Appearing animation of body text
    final bodyCurvedAnimation = CurvedAnimation(
        parent: _mainAnimation,
        curve: const Interval(0.600, 0.800, curve: Curves.easeOutCubic));

    // Appearing animation of continue button
    final buttonCurvedAnimation = CurvedAnimation(
        parent: _mainAnimation,
        curve: const Interval(0.800, 1.000, curve: Curves.easeOutCubic));

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: ShowCasePainter(
                  widgetSizeMultiplier: 2,
                  bouncingAnimationSizeMuliplier: 10.0,
                  ringWidth: 40.0,
                  bouncingAnimation: bouncingCurvedAnimation,
                  centerPosition: centerPos,
                  widgetSize: widgetSize,
                  openingAnimation: openingCurvedAnimation),
            ),
          ),
          Positioned(
            top: centerPos.dy + 120.0,
            child: SafeArea(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: AnimatedBuilder(
                      animation: _mainAnimation,
                      builder: (context, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.translate(
                              offset: Offset(0.0,
                                  (1.0 - titleCurvedAnimation.value) * 5.0),
                              child: Opacity(
                                opacity: titleCurvedAnimation.value,
                                child: Text(
                                  'I\'m title of new thing',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Transform.translate(
                              offset: Offset(
                                  0.0, (1.0 - bodyCurvedAnimation.value) * 5.0),
                              child: Opacity(
                                opacity: bodyCurvedAnimation.value,
                                child: Text(
                                  'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Transform.translate(
                              offset: Offset(0.0,
                                  (1.0 - buttonCurvedAnimation.value) * 5.0),
                              child: Opacity(
                                opacity: buttonCurvedAnimation.value,
                                child: SizedBox(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _mainAnimation.reverse();
                                      },
                                      child: const Text('Et harum quidem')),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Returns center position of widget
  Offset _getCorrectCenterPosition(RenderBox box) {
    Offset position = box.localToGlobal(Offset.zero);
    Size size = box.size;
    return Offset(
      position.dx + size.width ~/ 2,
      position.dy + size.height ~/ 2,
    );
  }

  @override
  void dispose() {
    _mainAnimation.dispose();
    _bouncingAnimation.dispose();
    super.dispose();
  }
}
