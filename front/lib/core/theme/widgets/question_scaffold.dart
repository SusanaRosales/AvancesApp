import 'package:flutter/material.dart';

class QuestionScaffold extends StatelessWidget {
  final Widget child;

  const QuestionScaffold({
    super.key,
    required this.child,
  });

  @override
Widget build(BuildContext context) {
  return Column(
    children: [
      Expanded(child: child),
      const SizedBox(height: 80),
    ],
  );
}
}