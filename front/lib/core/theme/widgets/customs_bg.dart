import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';
import 'package:flutter_svg/svg.dart';

//difuminado para el fondo
class BlurredBlob extends StatelessWidget {
  final double size;
  final Color color;

  const BlurredBlob({
    super.key, 
    this.size = 200, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 80,               
            spreadRadius: 40,             
          ),
        ],
      ),
    );
  }
}

class LogoIcon extends StatelessWidget {
  final double size;

  const LogoIcon({super.key, required this.size}); 
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo_purple.svg',
      width: size
    );
  }
}


// formato de bg
class CustomBg extends StatelessWidget {
  final bool showLogo;
  const CustomBg({super.key, this.showLogo = true});

  @override
  Widget build(BuildContext context) {
    return Stack(children: 
      [
        const Positioned(
            top: -80,
            left: -80,
            child: BlurredBlob(
              size: 250,
              color: AppColors.purpleLilac,
            ),
        ),
        const Positioned(
            bottom: 255,
            right: -80,
            child: BlurredBlob(
              size: 250,
              color: AppColors.skyBlue,
          ),
        ),
        const Positioned(
            bottom: -100,
            left: -2,
            child: BlurredBlob(
              size: 250,
              color: AppColors.lightPink,
          ),
        ),
        if (showLogo)
          const Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: LogoIcon(size: 65)
            ),
        ),
      ],
    );
  }
}

