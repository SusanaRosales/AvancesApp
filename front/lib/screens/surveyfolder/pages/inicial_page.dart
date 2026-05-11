import 'package:flutter/material.dart';
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';
import 'package:flutter_app_liftmove/core/theme/widgets/question_scaffold.dart';

class InicialPage extends StatelessWidget {
  const InicialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      child: Column(
        children: [
          const SizedBox(height: 150),
          Text(
            'Iniciemos',
            style: 
            TextStyle(
              color: AppColors.oceanBlue,
              fontFamily: 'HeuvelGrotesk',
              fontSize: 45,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Antes de empezar, \nnecesitamos saber un poco sobre ti',
            textAlign: TextAlign.center,
            style: 
            TextStyle(
              color: AppColors.oceanBlue,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

