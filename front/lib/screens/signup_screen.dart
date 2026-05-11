import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';
import 'package:flutter_app_liftmove/core/theme/widgets/customs_bg.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_app_liftmove/screens/survey_screen.dart';
import 'package:flutter_app_liftmove/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validarYContinuar() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final usuario = _usuarioController.text.trim();
    final password = _passwordController.text;
    final regexEspeciales = RegExp(r'[^a-zA-Z0-9]');

    if (usuario.isEmpty) {
      _mostrarSnackbar('El usuario no puede estar vacío');
      return;
    }
    if (usuario.length > 20) {
      _mostrarSnackbar('Máximo 20 caracteres para el usuario');
      return;
    }
    if (regexEspeciales.hasMatch(usuario)) {
      _mostrarSnackbar('El usuario no permite caracteres especiales');
      return;
    }
    if (password.isEmpty) {
      _mostrarSnackbar('La contraseña no puede estar vacía');
      return;
    }
    if (password.length < 8 || password.length > 16) {
      _mostrarSnackbar('La contraseña debe tener entre 8 y 16 caracteres');
      return;
    }
    if (regexEspeciales.hasMatch(password)) {
      _mostrarSnackbar('La contraseña no permite caracteres especiales');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveyScreen(
          nombreUsu: usuario,
          contrasenha: password,
        ),
      ),
    );
  }

  void _mostrarSnackbar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        content: Text(
          mensaje,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.berry,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
        backgroundColor: AppColors.whiteHlight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        margin: const EdgeInsets.fromLTRB(40, 0, 40, 100),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteHlight,
      body: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: CustomBg()),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const SignupHeader(),
                        const SizedBox(height: 25),
                        SignupBox(
                          isPasswordVisible: _isPasswordVisible,
                          onTogglePassword: () {
                            setState(() =>
                                _isPasswordVisible = !_isPasswordVisible);
                          },
                          usuarioController: _usuarioController,
                          passwordController: _passwordController,
                        ),
                        const SizedBox(height: 40),
                        SignupButton(onPressed: _validarYContinuar),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(
              child: Lottie.asset(
                'assets/walking_login.json',
                width: double.infinity,
                height: 240,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 80),
        Text(
          'Bienvenido',
          style: TextStyle(
            fontFamily: 'HeuvelGrotesk',
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: AppColors.oceanBlue,
          ),
        ),
        Text(
          'Da el primer paso a tu nuevo estilo de vida',
          style: TextStyle(
            color: AppColors.periwinkle,
            fontSize: 10,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class SignupBox extends StatelessWidget {
  final bool isPasswordVisible;
  final VoidCallback onTogglePassword;
  final TextEditingController usuarioController;
  final TextEditingController passwordController;

  const SignupBox({
    super.key,
    required this.isPasswordVisible,
    required this.onTogglePassword,
    required this.usuarioController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(
          context,
          'USUARIO',
          trailing: GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
            child: const Text(
              '¿Ya tienes cuenta?',
              style: TextStyle(
                color: AppColors.periwinkle,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.periwinkle,
              ),
            ),
          ),
        ),
        _inputField(
          icon: Icons.person_outline,
          hint: 'Nombre de Usuario',
          controller: usuarioController,
          maxLength: 20,
        ),
        const SizedBox(height: 20),
        _label(context, 'CONTRASEÑA'),
        _inputField(
          icon: Icons.lock_outline,
          hint: 'Crea tu contraseña',
          controller: passwordController,
          isPassword: true,
          obscureText: !isPasswordVisible,
          maxLength: 16,
          suffix: IconButton(
            onPressed: onTogglePassword,
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: AppColors.periwinkle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(BuildContext context, String text, {Widget? trailing}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: AppColors.lightPink,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      );

  Widget _inputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    int? maxLength,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.babyGrey.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        maxLength: maxLength,
        style: const TextStyle(
          color: AppColors.darkPurple,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.greyPurple.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(icon, color: AppColors.periwinkle, size: 22),
          suffixIcon: suffix,
          border: InputBorder.none,
          counterText: '',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}

class SignupButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SignupButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.mainBlue, AppColors.oceanBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text(
          'CREAR CUENTA',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}