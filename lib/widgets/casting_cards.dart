// casting_cards.dart

import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';

class CastingCards extends StatelessWidget {
  final List<Character> characters;

  CastingCards({required this.characters});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: characters.length,
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    characters[index].imageUrl,
                    height: 120,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(characters[index].name),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
