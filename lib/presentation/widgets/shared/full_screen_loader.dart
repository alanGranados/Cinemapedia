import 'dart:async';

import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> messages = [
      "Cargando",
      "Cargando Estrenos",
      "Cargando Populares",
      "Cargando Mejores Rankeadas",
      "Haciendo palomitas de maiz",
      "Esta tardando mas de lo esperado",
    ];

    Stream<String> getLoadingMessages () => Stream.periodic(const Duration(milliseconds: 1200), (index) => messages[index]).take(messages.length); 

    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Guarimoment plis'),
          const SizedBox(height: 10,),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10,),
          StreamBuilder(
            stream: getLoadingMessages(), 
            builder: (context, snapshot) => snapshot.hasData ?  Text(snapshot.data!) : const Text('Cargando...'),
          )
        ],
      ),
    );
  }
}