// home_screen.dart
import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/screens/details_screen.dart';
import 'package:movies_app/widgets/card_swiper.dart';

class HomeScreen extends StatelessWidget {
  final MoviesProvider moviesProvider = MoviesProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SWAPI App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Peliculas de Star Wars',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
              future: moviesProvider.getFilms(),
              builder: (context, AsyncSnapshot<List<Film>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Film> films = snapshot.data ?? [];
                  films.sort((a, b) => a.episodeId.compareTo(b.episodeId));

                  return CardSwiper(films: films);
                }
              },
            ),
            // Nueva sección de personajes
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Personajes de Star Wars',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
              future: moviesProvider.getAllCharacters(),
              builder: (context, AsyncSnapshot<List<Character>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Character> characters = snapshot.data ?? [];

                  return Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        return CharacterCard(character: characters[index]);
                      },
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Naves de Star Wars',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
              future: moviesProvider.getStarships(),
              builder: (context, AsyncSnapshot<List<Starship>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Muestra la lista de naves usando un ListView
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (Starship? starship in snapshot.data ?? []) ...[
                        if (starship != null)
                          ListTile(
                            title: Text(starship.name),
                            subtitle: Text('Model: ${starship.model}, Class: ${starship.starshipClass}'),
                          ),
                        Divider(),
                      ],
                    ],
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Planetas de Star Wars',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
              future: moviesProvider.getPlanets(),
              builder: (context, AsyncSnapshot<List<Planet>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Muestra la lista de planetas usando un ListView
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (Planet? planet in snapshot.data ?? []) ...[
                        if (planet != null)
                          ListTile(
                            title: Text(planet.name),
                            subtitle: Text('Climate: ${planet.climate}, Terrain: ${planet.terrain}'),
                          ),
                        Divider(),
                      ],
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
