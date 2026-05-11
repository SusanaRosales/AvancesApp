import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';

class QuestionFour extends StatefulWidget {
  final bool isMale;
  final double altura;
  final int edad;
  final Function(double) onWeightSelected; // ← corregido typo

  const QuestionFour({
    super.key,
    required this.isMale,
    required this.altura,
    required this.edad,
    required this.onWeightSelected,
  });

  @override
  State<QuestionFour> createState() => _QuestionFourState();
}

class _QuestionFourState extends State<QuestionFour> {
  double _currentWeight = 60.0;

  // ← corregido: _currentWeight en lugar de _peso
  double get _imc =>
      _currentWeight / ((widget.altura / 100) * (widget.altura / 100));

  String get _imcCategoria {
    if (widget.isMale) {
      if (_imc < 20.0) return 'Infrapeso';
      if (_imc < 25.0) return 'Saludable';
      if (_imc < 30.0) return 'Sobrepeso';
      if (_imc < 35.0) return 'Obesidad I';
      if (_imc < 40.0) return 'Obesidad II';
      return 'Obesidad III';
    } else {
      if (_imc < 19.0) return 'Infrapeso';
      if (_imc < 24.0) return 'Saludable';
      if (_imc < 29.0) return 'Sobrepeso';
      if (_imc < 34.0) return 'Obesidad I';
      if (_imc < 39.0) return 'Obesidad II';
      return 'Obesidad III';
    }
  }

  Color get _imcColor {
    final infra  = widget.isMale ? 20.0 : 19.0;
    final normal = widget.isMale ? 25.0 : 24.0;
    final sobre  = widget.isMale ? 30.0 : 29.0;
    final ob1    = widget.isMale ? 35.0 : 34.0;
    final ob2    = widget.isMale ? 40.0 : 39.0;

    if (_imc < infra)  return AppColors.electricBlue;
    if (_imc < normal) return AppColors.darkPurple;
    if (_imc < sobre)  return AppColors.pinkie;
    if (_imc < ob1)    return AppColors.darkMagenta;
    if (_imc < ob2)    return AppColors.berry;      // ← corregido ob1 → ob2
    return AppColors.darkerPink;
  }

  String _getImagePath() {
    final String gender = widget.isMale ? 'man' : 'woman';
    final double infra  = widget.isMale ? 20.0 : 19.0; // ← declarado aquí
    final double normal = widget.isMale ? 25.0 : 24.0;
    final double sobre  = widget.isMale ? 30.0 : 29.0;

    final String stage;
    if (_imc < infra)       { stage = 'underweight'; }
    else if (_imc < normal) { stage = 'normal'; }
    else if (_imc < sobre)  { stage = 'overweight'; }
    else                    { stage = 'obesity'; }

    return 'assets/images/human_resources/${gender}_$stage.png';
  }

  double get _minPeso => widget.edad < 18 ? 30.0 : 40.0;
  double get _maxPeso => widget.isMale ? 230.0 : 200.0;

  @override
  Widget build(BuildContext context) {
    final double pesoLbs = _currentWeight * 2.20462;

    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          'Mi peso es de...',
          style: TextStyle(
            color: AppColors.darkPurple,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),

        // ── ROW: imagen + IMC ──
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Imagen según IMC
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: Image.asset(
                    _getImagePath(),
                    key: ValueKey(_getImagePath()),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Columna IMC
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'IMC',   // ← corregido: faltaba coma después del string
                      style: TextStyle(
                        color: AppColors.berry,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 100),
                      style: TextStyle(
                        color: _imcColor,
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                      child: Text(_imc.toStringAsFixed(1)),
                    ),
                    const SizedBox(height: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 100),
                      style: TextStyle(
                        color: _imcColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      child: Text(
                        _imcCategoria,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── PESO en kg y lbs ──
        Text(
          '${_currentWeight.toStringAsFixed(1)} kg',
          style: TextStyle(
            color: AppColors.darkPurple,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${pesoLbs.toStringAsFixed(1)} lbs',
          style: TextStyle(
            color: AppColors.darkPurple.withOpacity(0.55),
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),

        // ── DIVISION SLIDER ──
        SizedBox(
          height: 80,
          child: DivisionSlider(
            from: _minPeso,
            max: _maxPeso,
            initialValue: _currentWeight,
            onChanged: (value) {
              setState(() => _currentWeight = value);
              widget.onWeightSelected(value);
            },
          ),
        ),

        const SizedBox(height: 100),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// DIVISION SLIDER
// ═══════════════════════════════════════════

class DivisionSlider extends StatefulWidget {
  final double from;
  final double max;
  final double initialValue;
  final Function(double) onChanged;

  const DivisionSlider({
    required this.from,
    required this.max,
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  @override
  State<DivisionSlider> createState() => _DivisionSliderState();
}

class _DivisionSliderState extends State<DivisionSlider> {
  PageController? numbersController;
  final itemsExtension = 1000;
  late double value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  void _updateValue() {
    value = ((((numbersController?.page ?? 0) - itemsExtension) * 10)
                    .roundToDouble() /
                10)
            .clamp(widget.from, widget.max);
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewPortFraction = 1 / (constraints.maxWidth / 10);
          numbersController = PageController(
            initialPage: itemsExtension + widget.initialValue.toInt(),
            viewportFraction: viewPortFraction * 10,
          );
          numbersController?.addListener(_updateValue);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 6),
              SizedBox(
                height: 10,
                width: 11.5,
                child: CustomPaint(painter: TrianglePainter()),
              ),
              _Numbers(
                itemsExtension: itemsExtension,
                controller: numbersController,
                start: widget.from.toInt(),
                end: widget.max.toInt(),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    numbersController?.removeListener(_updateValue);
    numbersController?.dispose();
    super.dispose();
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.darkPurple;
    final paint2 = Paint()
      ..color = AppColors.darkPurple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
      Path()
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(0, 0),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width / 2, 0)
        ..lineTo(size.width / 2, size.height * 2),
      paint2,
    );
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => true;
}

class _Numbers extends StatelessWidget {
  final PageController? controller;
  final int itemsExtension;
  final int start;
  final int end;

  const _Numbers({
    required this.controller,
    required this.itemsExtension,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: PageView.builder(
        pageSnapping: false,
        controller: controller,
        physics: _CustomPageScrollPhysics(
          start: itemsExtension + start.toDouble(),
          end: itemsExtension + end.toDouble(),
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, rawIndex) {
          final index = rawIndex - itemsExtension;
          return _Item(index: index >= start && index <= end ? index : null);
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final int? index;
  const _Item({required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          const _Dividers(),
          if (index != null)
            Expanded(
              child: Center(
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Dividers extends StatelessWidget {
  const _Dividers();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(10, (index) {
          final thickness = index == 5 ? 1.5 : 0.5;
          return Expanded(
            child: Row(
              children: [
                Transform.translate(
                  offset: Offset(-thickness / 2, 0),
                  child: VerticalDivider(
                    thickness: thickness,
                    width: 1,
                    color: AppColors.darkPurple,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _CustomPageScrollPhysics extends ScrollPhysics {
  final double start;
  final double end;

  const _CustomPageScrollPhysics({
    required this.start,
    required this.end,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  _CustomPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _CustomPageScrollPhysics(
      parent: buildParent(ancestor),
      start: start,
      end: end,
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final oldPosition = position.pixels;
    final frictionSimulation =
        FrictionSimulation(0.4, position.pixels, velocity * 0.2);

    double newPosition = (frictionSimulation.finalX / 10).round() * 10;

    final endPosition = end * 10 * 10;
    final startPosition = start * 10 * 10;
    if (newPosition > endPosition) {
      newPosition = endPosition;
    } else if (newPosition < startPosition) {
      newPosition = startPosition;
    }
    if (oldPosition == newPosition) return null;

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      newPosition.toDouble(),
      velocity,
      tolerance: tolerance,
    );
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 20,
        stiffness: 100,
        damping: 0.8,
      );
}