import 'package:flutter/material.dart';
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';

class QuestionThree extends StatefulWidget {
  final bool isMale; // Recibe el género de la pantalla anterior
  final Function(double) onHeightSelected;

  const QuestionThree({super.key, required this.isMale, required this.onHeightSelected,});

  @override
  State<QuestionThree> createState() => _QuestionThreeState();
}

class _QuestionThreeState extends State<QuestionThree> {
  // Altura inicial (puedes ajustarla a 160 o 170 si prefieres)
  double _currentHeight = 150.0; 

  @override
  Widget build(BuildContext context) {
    // Definimos las rutas dinámicamente según el género
    final String pathUp = widget.isMale 
        ? 'assets/images/human_resources/up_man.png' 
        : 'assets/images/human_resources/up_woman.png';
    final String pathDown = widget.isMale 
        ? 'assets/images/human_resources/down_man.png' 
        : 'assets/images/human_resources/down_woman.png';

    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          'Mi altura es...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.darkPurple,
            fontSize: 20,
          ),
        ),
        Text(
          "${_currentHeight.toInt()} cm",
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: AppColors.darkPurple
          ),
        ),
        Text(
          "${(_currentHeight.toInt()/30.48).toStringAsFixed(2)} ft",
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: AppColors.greyPurple
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // 1. Imagen Inferior (Piernas) - Posición fija
              Positioned(
                bottom: 80, 
                child: Image.asset(
                  pathDown,
                  height: 200, // Ajusta según el tamaño de tu PNG
                ),
              ),

              // 2. Imagen Superior (Torso) - Se mueve con el Slider
              Positioned(
                // Esta fórmula separa el torso de las piernas proporcionalmente
                bottom: 95 + (_currentHeight - 110), 
                child: Image.asset(
                  pathUp,
                  height: 280, // Ajusta según el tamaño de tu PNG
                ),
              ),

              // 3. Slider de altura
              Positioned(
                bottom: 50,
                left: 40,
                right: 40,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.berry,
                    inactiveTrackColor: const Color.fromARGB(0, 181, 50, 118).withOpacity(0.2),
                    thumbColor: AppColors.berry,
                    trackHeight: 2.0,
                    overlayColor: Colors.transparent,
                  ),
                  child: Slider(
                    value: _currentHeight,
                    min: 140,
                    max: 200,
                    onChanged: (value) {
                      setState(() {
                        _currentHeight = value;
                      });
                      widget.onHeightSelected(value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 80), // Espacio para los botones inferiores
      ],
    );
  }
}