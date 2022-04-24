import 'dart:convert';
import 'package:http/http.dart';
import 'package:movies/src/models/index.dart';

class MovieApi {
  MovieApi(this._client);

  final Client _client;

  Future<List<Movie>> getMovies(int page) async {
    final Response response = await _client.get(
      Uri(
        scheme: 'https',
        host: 'yts.mx',
        path: '/api/v2/list_movies.json',
        queryParameters: <String, dynamic>{
          'page': '$page',
          'quality': '3D',
        },
      ),
    );
    final Map<String, dynamic> result = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> movies = (result['data'] as Map<String, dynamic>)['movies'] as List<dynamic>;

    final List<Movie> data = <Movie>[];
    for (final dynamic movie in movies) {
      final Map<String, dynamic> item = movie as Map<String, dynamic>;
      data.add(Movie.fromJson(item));
    }
    return data;
  }
}
