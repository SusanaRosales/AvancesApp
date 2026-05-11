import 'package:flutter/material.dart';
import 'package:flutter_app_liftmove/core/theme/app_theme.dart';
import 'package:flutter_app_liftmove/core/theme/widgets/customs_bg.dart';
import 'package:intl/intl.dart'; //para la fecha

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('HOME',
            style: TextStyle(
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: AppColors.darkPurple,
              fontSize: 15,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const CustomBg(showLogo: false),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 80),
                const DateDisplay(), 
                const SizedBox(height: 30),
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.mainBlue, AppColors.oceanBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.babyGrey,
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Registrar Rutina'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, 
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: AppColors.pinkie),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, color: AppColors.pinkie),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: AppColors.pinkie),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: AppColors.pinkie),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class DateDisplay extends StatefulWidget {
  const DateDisplay({super.key});

  @override
  State<DateDisplay> createState() => _DateDisplayState();
}

class _DateDisplayState extends State<DateDisplay> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dia = DateFormat('dd').format(now);
    final mes = DateFormat('MMM', 'es').format(now).toUpperCase();
    final diaSemana = DateFormat('EEEE', 'es').format(now).toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          diaSemana,
          style: const TextStyle(
            color: AppColors.darkerPink,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              dia,
              style: const TextStyle(
                
                color: AppColors.oceanBlue,
                fontSize: 52,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                mes,
                style: const TextStyle(
                  color: AppColors.lightPink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}