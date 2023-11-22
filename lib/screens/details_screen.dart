import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';

class DetailScreen extends StatelessWidget {
  final Film film;
  final MoviesProvider moviesProvider = MoviesProvider();

  DetailScreen({required this.film});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(film.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Opening Crawl',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            FutureBuilder(
              future: fetchOpeningCrawl('https://swapi.dev/api/films/${film.episodeId}/'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(fontSize: 14),
                  );
                }
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Characters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            FutureBuilder(
              future: fetchCharacters(film.characters),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data!.isEmpty) {
                  return Text('No characters found');
                } else {
                  return Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return CharacterCard(character: snapshot.data![index]);
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> fetchOpeningCrawl(String openingCrawlUrl) async {
    final response = await http.get(Uri.parse(openingCrawlUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['opening_crawl'];
    } else {
      throw Exception('Failed to fetch opening crawl');
    }
  }

  Future<List<Character>> fetchCharacters(List<String> characterUrls) async {
    List<Character> characters = [];

    // Map the episodeIds according to the provided pattern
    Map<int, int> episodeMapping = {
      4: 1,
      5: 2,
      6: 3,
      1: 4,
      2: 5,
      3: 6,
    };

    for (String url in characterUrls) {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> characterData = json.decode(response.body);

        // Make sure 'name' and 'url' exist in characterData
        if (characterData.containsKey('name') && characterData.containsKey('url')) {
          characters.add(
            Character(
              name: characterData['name'],
              imageUrl: 'https://starwars-visualguide.com/assets/img/characters/${Character.extractIdFromUrl(characterData['url'])}.jpg',
              episodeId: characterData['episode_id'],
              filmTitle: getTitleForEpisodeId(characterData['episode_id']),
            ),
          );
        } else {
          print('Fields "name" and "url" are not present in the character data.');
        }
      } else {
        throw Exception('Failed to fetch character details');
      }
    }

    // Sort characters based on the mapped episodeId
    characters.sort((a, b) {
      int episodeIdA = episodeMapping[a.episodeId] ?? 0;
      int episodeIdB = episodeMapping[b.episodeId] ?? 0;
      return episodeIdA.compareTo(episodeIdB);
    });

    return characters;
  }

  String getTitleForEpisodeId(int? episodeId) {
    // Check if episodeId is not null before accessing it
    if (episodeId != null) {
      // Add your logic to get the title for the given episodeId
      // For example, you can create a map with episodeId-title pairs
      // and return the corresponding title.
      // Replace the logic below with your own.
      return 'Episode $episodeId';
    } else {
      // Handle the case where episodeId is null
      return 'Unknown Episode';
    }
  }
}

class CharacterCard extends StatelessWidget {
  final Character character;

  CharacterCard({required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(
            character.imageUrl,
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              character.name,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}