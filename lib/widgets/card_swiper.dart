// card_swiper.dart

import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/screens/details_screen.dart';


class CardSwiper extends StatelessWidget {
  final List<Film> films;

  CardSwiper({required this.films});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: films.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(film: films[index]),
                ),
              );
            },
            child: Card(
              child: Container(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://starwars-visualguide.com/assets/img/films/${index + 1}.jpg',
                      height: 350,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(films[index].title),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
