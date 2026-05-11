import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';

class QuestionTwo extends StatefulWidget {
  final bool isMale;
  final Function(int) onAgeSelected;

  const QuestionTwo({super.key, required this.isMale, required this.onAgeSelected});

  @override
  State<QuestionTwo> createState() => _QuestionTwoState();
}

class _QuestionTwoState extends State<QuestionTwo> {
  final TextEditingController _controller = TextEditingController();
  int? _currentAge;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDateChanged(String value) {
    String digits = value.replaceAll('/', '');
    String formatted = '';
    for (int i = 0; i < digits.length && i < 8; i++) {
      if (i == 2 || i == 4) formatted += '/';
      formatted += digits[i];
    }

    if (formatted != value) {
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    if (formatted.length == 10) {
      _validateDate(formatted);
    } else {
      setState(() {
        _currentAge = null;
        _errorText = null;
      });
    }
  }

  void _validateDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      final day   = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year  = int.parse(parts[2]);

      final birth = DateTime(year, month, day);
      final today = DateTime.now();

      if (birth.day != day || birth.month != month || birth.year != year) {
        setState(() { _errorText = 'Fecha inválida'; _currentAge = null; });
        return;
      }

      int age = today.year - birth.year;
      if (today.month < birth.month ||
          (today.month == birth.month && today.day < birth.day)) {
        age--;
      }

      if (age < 10) {
        setState(() { _errorText = 'Edad mínima de 10 años'; _currentAge = null; });
      } else if (age > 99) {
        setState(() { _errorText = 'Edad máxima de 99 años'; _currentAge = null; });
      } else {
        setState(() { _errorText = null; _currentAge = age; });
        widget.onAgeSelected(age);
      }
    } catch (_) {
      setState(() { _errorText = 'Fecha inválida'; _currentAge = null; });
    }
  }

  String _getImagePath() {
    final age = _currentAge;
    if (age == null) {
      return widget.isMale
          ? 'assets/images/human_resources/man_kid.png'
          : 'assets/images/human_resources/woman_kid.png';
    }

    final String stage;
    if (age <= 13) {
      stage = 'kid';
    } else if (age <= 21) {
      stage = 'teen';
    } else if (age <= 49) {
      stage = 'adult';
    } else {
      stage = 'elder';
    }

    final String gender = widget.isMale ? 'man' : 'woman';
    return 'assets/images/human_resources/${gender}_$stage.png';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          'Mi fecha de \nnacimiento es...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.darkPurple,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),

        if (_currentAge != null)
          Text(
            '$_currentAge años',
            style: TextStyle(
              color: AppColors.darkPurple,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

        const SizedBox(height: 10),

        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Image.asset(
              _getImagePath(),
              key: ValueKey(_getImagePath()),
              height: 260,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            controller: _controller,
            style: const TextStyle(
              color: AppColors.darkPurple, // O el color que prefieras
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 10,
            textAlign: TextAlign.center,
            onChanged: _onDateChanged,
            decoration: InputDecoration(
              hintText: 'día/mes/año',
              hintStyle: TextStyle(
                color: AppColors.darkPurple.withOpacity(0.4), // Un tono suave para la sugerencia
                fontWeight: FontWeight.normal,
                fontSize: 20,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.darkPurple, 
                  width: 1.0, 
                ),
              ),
              errorText: _errorText,
              counterText: '',
              errorStyle: const TextStyle(
                color: AppColors.darkMagenta, 
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              // Recuerda que el borde cuando hay error también se puede cambiar:
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.darkMagenta, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.darkMagenta, width: 2.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.darkMagenta, width: 2.5),
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom > 0 ? 300.0 : 120.0,
        ),
      ],
    );
  }
}