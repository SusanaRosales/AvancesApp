import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app_liftmove/core/api_config.dart';
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';
import 'package:flutter_app_liftmove/core/theme/widgets/customs_bg.dart';
import 'package:flutter_app_liftmove/core/theme/widgets/nav_buttons.dart';

// Pantallas de preguntas
import 'package:flutter_app_liftmove/screens/surveyfolder/pages/inicial_page.dart';
import 'package:flutter_app_liftmove/screens/surveyfolder/pages/question_one.dart';
import 'package:flutter_app_liftmove/screens/surveyfolder/pages/question_two.dart';
import 'package:flutter_app_liftmove/screens/surveyfolder/pages/question_three.dart';
import 'package:flutter_app_liftmove/screens/surveyfolder/pages/question_four.dart';
import 'package:flutter_app_liftmove/screens/surveyfolder/pages/question_five.dart';
import 'package:flutter_app_liftmove/screens/surveyfolder/pages/final_page.dart';

class SurveyScreen extends StatefulWidget {
  final String nombreUsu;
  final String contrasenha;

  const SurveyScreen({
    super.key,
    required this.nombreUsu,
    required this.contrasenha,
  });

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 7;

  // Datos de la encuesta
  bool _isMale = true;
  int _edad = 0;
  double _altura = 160.0;
  double _peso = 60.0;
  Set<String> _metas = {};

  bool _q1Done = false;
  bool _q2Done = false;
  bool _q3Done = true;  // tiene valor inicial
  bool _q4Done = true;  // tiene valor inicial
  bool _q5Done = false;

  bool _isLoading = false;

  bool get _puedeAvanzar {
    switch (_currentPage) {
      case 0: return true; // InicialPage
      case 1: return _q1Done;
      case 2: return _q2Done;
      case 3: return _q3Done;
      case 4: return _q4Done;
      case 5: return _q5Done;
      default: return true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- Lógica de Navegación ---
  void _irAPagina(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  void _anterior() => _irAPagina(_currentPage - 1);

  void _intentarAvanzar() {
    if (_currentPage == 5) {
      if (_metas.isEmpty) {
        _mostrarError('Por favor selecciona al menos un objetivo');
      } else {
        _registrarUsuario();
      }
    } else {
      _irAPagina(_currentPage + 1);
    }
  }

  // --- API ---
  Future<void> _registrarUsuario() async {
    setState(() => _isLoading = true);
    final url = Uri.parse('${ApiConfig.baseUrl}/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idUsu': widget.nombreUsu,
          'nombreUsu': widget.nombreUsu,
          'correoUsu': '${widget.nombreUsu}@liftmove.app',
          'contrasenha': widget.contrasenha,
          'sexo': _isMale ? 'M' : 'F',
          'altura_cm': _altura.toInt(),
          'peso': _peso.toInt(),
          'objetivo_entreno': _metas.join(', '),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) _irAPagina(6);
      } else {
        final data = json.decode(response.body);
        _mostrarError(data['detail'] ?? 'Error al registrar');
      }
    } catch (e) {
      _mostrarError('Error de conexión con el servidor');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.berry,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        margin: const EdgeInsets.fromLTRB(40, 0, 40, 100),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: _currentPage / (_totalPages - 1)),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
          builder: (context, value, _) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkPurple),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const CustomBg(showLogo: false),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: [
                const InicialPage(),
                QuestionOne(onGenderSelected: (val) {
                  setState(() {
                    _isMale = val;
                    _q1Done = true; 
                  });
                  _irAPagina(2);

                }),
                QuestionTwo(isMale: _isMale, onAgeSelected: (val) => setState(() {
                  _edad = val;
                  _q2Done = true;
                })),

                QuestionThree(isMale: _isMale, onHeightSelected: (val) => setState((){  
                  _altura = val;
                  _q3Done = true;
                })),
                QuestionFour(isMale: _isMale, altura: _altura, edad: _edad, onWeightSelected: (val) => setState((){ 
                  _peso = val;
                  _q4Done = true;
                })),
                QuestionFive(onGoalSelected: (val) => setState((){
                  _metas = val;
                  _q5Done = val.isNotEmpty;
                  })),
                const FinalPage(),
              ],
            ),
          ),
          
          // Botones de navegación con el estilo del primer código
          Positioned(
            bottom: 30,
            left: 25,
            right: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0 && _currentPage < 6)
                  NavButton(
                    onPressed: _anterior,
                    label: "ANTERIOR",
                    isNext: false,
                  )
                else
                  const SizedBox.shrink(),

                if (_currentPage < 6)
                  _isLoading 
                    ? const CircularProgressIndicator(color: AppColors.oceanBlue)
                    : NavButton(
                        onPressed: _puedeAvanzar ? _intentarAvanzar : null,
                        label: _currentPage == 5 ? "LISTO" : "SIGUIENTE",
                        isNext: true,
                      )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}