import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Movie> _movies = <Movie>[];
  bool _isLoading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  Future<void> _getMovies() async {
    setState(() {
      _isLoading = true;
    });
    final Response response = await get(
      Uri(
        scheme: 'https',
        host: 'yts.mx',
        path: '/api/v2/list_movies.json',
        queryParameters: <String, dynamic>{
          'page': '$_page',
          'quality': '3D',
        },
      ),
    );

    final Map<dynamic, dynamic> result = jsonDecode(response.body) as Map<dynamic, dynamic>;

    final List<dynamic> movies = result['data']['movies'] as List;

    final List<Movie> data = <Movie>[];

    for (int i = 0; i < movies.length; i++) {
      final Map<String, dynamic> item = movies[i] as Map<String, dynamic>;

      data.add(Movie.fromJson(item));
    }

    setState(() {
      _movies.addAll(data);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _page++;
                _getMovies();
              },
              icon: const Icon(Icons.add),
            )
          ],
          title: Align(
            child: Text('Movies $_page'),
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          if (_isLoading && _movies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // ignore: dead_code
          return ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (BuildContext context, int index) {
              final Movie movie = _movies[index];
              return Column(
                children: <Widget>[
                  Image.network(movie.poster),
                  Center(
                    child: Text(movie.title),
                  ),
                  Center(
                    child: Text(movie.genres.join(', ')),
                  ),
                  Text('${movie.rating}'),
                ],
              );
            },
          );
        }));
  }
}

class Movie {
  Movie({
    required this.title,
    required this.year,
    required this.rating,
    required this.genres,
    required this.poster,
  });

  Movie.fromJson(Map<String, dynamic> item)
      : title = item['title'] as String,
        year = item['year'] as int,
        rating = (item['rating'] as num).toDouble(),
        genres = List<String>.from(item['genres'] as List<dynamic>),
        poster = item['medium_cover_image'] as String;

  final String title;
  final int year;
  final double rating;
  final List<String> genres;
  final String poster;

  @override
  String toString() {
    return 'Movie{title: $title, year: $year, rating: $rating, genres: $genres, poster: $poster}';
  }
}
