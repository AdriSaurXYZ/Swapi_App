import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/screens/details_screen.dart';

class MoviesProvider {
  final String _baseUrl = 'https://swapi.dev/api';

   Future<List<Character>> getAllCharacters() async {
    final response = await http.get(Uri.parse('$_baseUrl/people/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      List<Character> characters = results
          .map((characterData) => Character.fromJson(characterData))
          .toList();

      return characters;
    } else {
      throw Exception('Failed to load characters');
    }
  }

  Future<String> getOpeningCrawl(int episodeId) async {
    var url = Uri.parse('$_baseUrl/films/$episodeId/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> filmData = json.decode(response.body);
      return filmData['opening_crawl'];
    } else {
      throw Exception('Failed to fetch opening crawl');
    }
  }

  Future<List<Film>> getFilms() async {
    var url = Uri.parse('$_baseUrl/films');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['results'];

      List<Film> films = await Future.wait(data.map((filmData) async {
        List<String> characterUrls =
            (filmData['characters'] as List<dynamic>).cast<String>();

        return Film(
          title: getTitleForEpisodeId(filmData['episode_id']),
          episodeId: filmData['episode_id'],
          openingCrawl: filmData['opening_crawl'],
          characters: characterUrls,
        );
      }));

      return films;
    } else {
      throw Exception('Failed to load films');
    }
  }

  

  Future<List<Starship>> getStarships() async {
    var url = Uri.parse('$_baseUrl/starships');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((starship) => Starship.fromJson(starship)).toList();
    } else {
      throw Exception('Failed to load starships');
    }
  }

  String getTitleForEpisodeId(int episodeId) {
    switch (episodeId) {
      case 1:
        return 'Ep IV: A New Hope';
      case 2:
        return 'Ep V: The Empire Strikes back';
      case 3:
        return 'Ep VI: Return of the Jedi';
      case 4:
        return 'Ep I: The Phantom Menace';
      case 5:
        return 'Ep II: Attack of the Clones';
      case 6:
        return 'Ep III: Revenge of The Siths';
      default:
        return 'Desconocido';
    }
  }

  Future<List<Character>> fetchCharacters(List<String> characterUrls) async {
    List<Character> characters = [];

    for (String url in characterUrls) {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> characterData = json.decode(response.body);

        // Add a null check for episode_id in characterData
        int episodeId = characterData['episode_id'] ?? 0;

        characters.add(
          Character(
            name: characterData['name'],
            imageUrl:
                'https://starwars-visualguide.com/assets/img/characters/${Character.extractIdFromUrl(characterData['url'])}.jpg',
            episodeId: episodeId,
            filmTitle: getTitleForEpisodeId(episodeId),
          ),
        );
      } else {
        throw Exception('Failed to fetch character details');
      }
    }

    return characters;
  }

  Future<List<Planet>> getPlanets() async {
    var url = Uri.parse('$_baseUrl/planets');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((planet) => Planet.fromJson(planet)).toList();
    } else {
      throw Exception('Failed to load planets');
    }
  }
}



class MoviesListScreen extends StatefulWidget {
  @override
  _MoviesListScreenState createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  List<Film> films = [];
  MoviesProvider moviesProvider = MoviesProvider();

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      List<Film> movies = await moviesProvider.getFilms();

      movies.sort((a, b) => a.episodeId.compareTo(b.episodeId));

      setState(() {
        films = movies;
      });
    } catch (e) {
      print('Error fetching movies: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Star Wars Movies'),
      ),
      body: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(films[index].title),
                subtitle: Text('Episode ${films[index].episodeId}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(film: films[index]),
                    ),
                  );
                },
              ),
              FutureBuilder(
                future: moviesProvider.getStarships(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Starship> starships = snapshot.data ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (Starship starship in starships) ...[
                          ListTile(
                            title: Text(starship.name),
                            subtitle: Text('Model: ${starship.model}'),
                          ),
                          Divider(),
                        ],
                      ],
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
