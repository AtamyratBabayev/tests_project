import 'package:flutter/material.dart';

class Hbox extends StatelessWidget {
  const Hbox(this.height, {super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: height),
    );
  }
}
