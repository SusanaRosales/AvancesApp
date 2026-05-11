import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'package:flutter_app_liftmove/core/api_config.dart';
import 'dart:convert'; 
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';
import 'package:flutter_app_liftmove/core/theme/widgets/customs_bg.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_app_liftmove/screens/home_screen.dart';
import 'package:flutter_app_liftmove/screens/signup_screen.dart';
import 'package:flutter_app_liftmove/core/services/auth_service.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false; 
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  
  Future<void> _validarYContinuar() async {
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

    setState(() => _isLoading = true);


    final url = Uri.parse('${ApiConfig.baseUrl}/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({                             
          'nombreUsu': usuario,
          'contrasenha': password,
        }),
      );

      final data = json.decode(response.body); 

// DESPUÉS — el token llega en data['access_token'] y lo guardamos
if (response.statusCode == 200) {
  // Extraemos el token JWT que devuelve el servidor
  final String token     = data['access_token'];
  final String nombreUsu = data['nombreUsu'];

  // Guardamos el token en almacenamiento seguro (regla del doc teorico:
  // "el token se guarda en lugar seguro")
  final authService = AuthService();
  await authService.guardarSesion(
    token:     token,
    nombreUsu: nombreUsu,
  );

  if (mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
} else {
  _mostrarSnackbar(data['detail'] ?? 'Credenciales incorrectas');
}
    } catch (e) {
      _mostrarSnackbar('⚠️ No se pudo conectar. ¿Está encendido el servidor?');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                        const LoginHeader(),
                        const SizedBox(height: 25),
                        LoginBox(
                          isPasswordVisible: _isPasswordVisible,
                          onTogglePassword: () {
                            setState(() =>
                                _isPasswordVisible = !_isPasswordVisible);
                          },
                          usuarioController: _usuarioController,
                          passwordController: _passwordController,
                        ),
                        const SizedBox(height: 40),
                        
                        _isLoading
                            ? const CircularProgressIndicator()
                            : LoginButton(onPressed: _validarYContinuar),
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



class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 80),
        Text(
          '¡Hola!',
          style: TextStyle(
            fontFamily: 'HeuvelGrotesk',
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: AppColors.oceanBlue,
          ),
        ),
        Text(
          'Es bueno tenerte de regreso',
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

class LoginBox extends StatelessWidget {
  final bool isPasswordVisible;
  final VoidCallback onTogglePassword;
  final TextEditingController usuarioController;
  final TextEditingController passwordController;

  const LoginBox({
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
              MaterialPageRoute(builder: (context) => const SignupScreen()),
            ),
            child: const Text(
              '¿No tienes cuenta?',
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
          hint: 'Ingrese su contraseña',
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

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LoginButton({super.key, required this.onPressed});

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
          'INICIAR SESIÓN',
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