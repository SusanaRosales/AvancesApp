import 'package:flutter/material.dart';
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';


class NavButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isNext;

  const NavButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isNext = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.berry,
        shadowColor: const Color.fromARGB(50, 160, 48, 96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: AppColors.berry, width: 0.5),
        ),
      ),
      icon: isNext ? const SizedBox() : const Icon(Icons.arrow_back_rounded, size: 15),
      label: Row(
        children: [
          Text(label,
            style: const TextStyle(
              color: AppColors.berry,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 9,
            ),
          ),
          if (isNext) const Icon(Icons.arrow_forward_rounded, size: 15),
        ],
      ),
    );
  }
}