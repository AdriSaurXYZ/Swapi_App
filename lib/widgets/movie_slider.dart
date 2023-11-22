
import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/screens/details_screen.dart';

class MovieSlider extends StatefulWidget {
  final MoviesProvider moviesProvider;

  MovieSlider({required this.moviesProvider});

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  late Future<List<Film>> films;

  @override
  void initState() {
    super.initState();
    films = widget.moviesProvider.getFilms();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: films,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          film: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Container(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            'https://starwars-visualguide.com/assets/img/films/${index + 1}.jpg',
                            height: 120,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(snapshot.data![index].title),
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
      },
    );
  }
}
