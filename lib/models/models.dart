class Film {
  final String title;
  final String openingCrawl;
  final int episodeId; // Añadido episodeId como una propiedad
  final List<String> characters; // Añadido characters como una propiedad

  Film({
    required this.title,
    required this.openingCrawl,
    required this.episodeId,
    required this.characters,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      title: json['title'] ?? '',
      openingCrawl: json['opening_crawl'] ?? '',
      episodeId: json['episode_id'] ?? 0,
      characters: List<String>.from(json['characters'] ?? []),
    );
  }
}

class Character {
  final String name;
  final String imageUrl;
  final int? episodeId;
  final String filmTitle;

  Character({
    required this.name,
    required this.imageUrl,
    this.episodeId,
    required this.filmTitle,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? '',
      imageUrl: 'https://starwars-visualguide.com/assets/img/characters/${Character.extractIdFromUrl(json['url'] ?? '')}.jpg',
      filmTitle: json['filmTitle'] ?? '', // Ajusta esto según la estructura real de la respuesta de la API
    );
  }

  static int extractIdFromUrl(String url) {
    RegExp regex = RegExp(r'\/(\d+)\/$');
    Match? match = regex.firstMatch(url);
    return match != null ? int.parse(match.group(1)!) : 0;
  }
}

class CharacterDetails {
  final String details;

  CharacterDetails({required this.details});

  factory CharacterDetails.fromJson(Map<String, dynamic> json) {
    return CharacterDetails(
      details: json['details'] ?? '', // Ajusta esto según la estructura real de la respuesta de la API
    );
  }
}

class Planet {
  final String name;
  final String climate;
  final String terrain;
  final String imageUrl;

  Planet({
    required this.name,
    required this.climate,
    required this.terrain,
    required this.imageUrl,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['name'] ?? '',
      climate: json['climate'] ?? '',
      terrain: json['terrain'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  int extractIdFromUrl(String url) {
    RegExp regex = RegExp(r'\/(\d+)\/$');
    Match? match = regex.firstMatch(url);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  
}

class Starship {
  final String name;
  final String model;
  final String starshipClass;
  final String imageUrl;

  Starship({
    required this.name,
    required this.model,
    required this.starshipClass,
    required this.imageUrl,
  });

  factory Starship.fromJson(Map<String, dynamic> json) {
    return Starship(
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      starshipClass: json['starship_class'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  int extractIdFromUrl(String url) {
    RegExp regex = RegExp(r'\/(\d+)\/$');
    Match? match = regex.firstMatch(url);
    return match != null ? int.parse(match.group(1)!) : 0;
  }
}