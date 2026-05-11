import 'package:flutter/material.dart';
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';
import 'package:flutter_app_liftmove/core/theme/widgets/question_scaffold.dart';

//screens
import 'package:flutter_app_liftmove/screens/home_screen.dart';

class FinalPage extends StatelessWidget {
  const FinalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      child: Column(
        children: [
          const SizedBox(height: 150,),
          Text(
            '¡Listo!',
            style: TextStyle(
              color: AppColors.oceanBlue,
              fontFamily: 'HeuvelGrotesk',
              fontSize: 45,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Ya todo esta preparado, \nes hora de ver que eres capaz de hacer',
            textAlign: TextAlign.center,
            style: 
            TextStyle(
              color: AppColors.oceanBlue,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),

          OutlinedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false, // no volver atrás
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent, // Relleno transparente
              foregroundColor: AppColors.darkPurple, // Color de las letras
              side: const BorderSide(
                color: AppColors.darkPurple, 
                width: 0.5, // Borde de 0.5
              ),
              elevation: 0, // Sin sombra
              // shadowColor: Colors.transparent, 
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: BorderSide(width: 5, color: AppColors.darkPurple) 
              ),
            ),
            child: Text(
              'Empieza ya',
              style: TextStyle(
                fontWeight: FontWeight.bold, // Letras bold
                letterSpacing: 1.3, // Espaciado 1.3
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
