import 'package:flutter/material.dart';
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';

class QuestionFive extends StatefulWidget {
  final Function(Set<String>) onGoalSelected;
  const QuestionFive({super.key, required this.onGoalSelected});

  @override
  State<QuestionFive> createState() => _QuestionFiveState();
}

class _QuestionFiveState extends State<QuestionFive> {
  final Set<String> _metas = {};

  void _seleccionar(String valor) {
    setState(() {
      if (_metas.contains(valor)) {
        _metas.remove(valor);
      } else {
        _metas.add(valor);
      }
    });
    widget.onGoalSelected(_metas);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          'Mi objetivo es...',
          style: TextStyle(
            color: AppColors.darkPurple,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBotonImagen(
                  titulo: 'Ganar músculo',
                  pathImagen: 'assets/images/human_resources/muscle.png',
                ),
                _buildBotonImagen(
                  titulo: 'Perder peso',
                  pathImagen: 'assets/images/human_resources/weightloss.png',
                ),
                _buildBotonImagen(
                  titulo: 'Ganar fuerza',
                  pathImagen: 'assets/images/human_resources/strength.png',
                ),
                _buildBotonImagen(
                  titulo: 'Ser más flexible',
                  pathImagen: 'assets/images/human_resources/flex.png',
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildBotonImagen({required String titulo, required String pathImagen}) {
    final bool estaActivo = _metas.contains(titulo); // ← corregido

    return GestureDetector(
      onTap: () => _seleccionar(titulo),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: estaActivo
              ? AppColors.oceanBlue.withOpacity(0.15)
              : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: estaActivo ? AppColors.oceanBlue : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: estaActivo
                  ? AppColors.oceanBlue.withOpacity(0.2)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              pathImagen,
              height: 55,
              width: 55,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                titulo,
                style: TextStyle(
                  color: estaActivo ? AppColors.oceanBlue : AppColors.darkPurple,
                  fontSize: 15,
                  fontWeight: estaActivo ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: estaActivo ? AppColors.oceanBlue : Colors.transparent,
                border: Border.all(
                  color: estaActivo
                      ? AppColors.oceanBlue
                      : AppColors.darkPurple.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: estaActivo
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}