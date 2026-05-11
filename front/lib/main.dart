import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_liftmove/screens/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart'; //fecha

void main() async {
  // 1. Asegura que los servicios de Flutter estén inicializados antes de bloquear la orientación
  WidgetsFlutterBinding.ensureInitialized();
  // 2. Bloquea la app en modo vertical (Portrait)
  await initializeDateFormatting('es', null);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
      ),
      debugShowCheckedModeBanner: false,
      home: const SignupScreen(),
    );
  }
}
