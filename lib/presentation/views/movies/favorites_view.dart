import 'package:flutter/material.dart';

class Favoritesview extends StatelessWidget {
  const Favoritesview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites View'),
      ),
      body: const Center(child: Text('Favoritos'),),
    );
  }
}