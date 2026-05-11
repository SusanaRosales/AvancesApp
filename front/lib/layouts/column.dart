import 'package:flutter/material.dart';
//siempre stateless
class ColumnEx extends StatelessWidget {
  const ColumnEx({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 500,
      decoration: BoxDecoration(
      color: const Color.fromARGB(255, 196, 145, 205),
      borderRadius: BorderRadius.circular(8),
      ),
      child:Padding(
        padding: const EdgeInsets.all(0.01),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
          Text('Prueba'), 
          Spacer(),
          Text('Prueba 2'),
          Text('Prueba 2'),
          Text('Prueba 2'),
          Text('Prueba 2'),
          Text('Prueba 2'),
          ],
        ),
      ),
    );
  }
}