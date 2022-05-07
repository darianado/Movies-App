import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/models/index.dart';

class MovieApi {
  MovieApi(this._client, this._firestore);

  final Client _client;
  final FirebaseFirestore _firestore;

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
    final Map<String, dynamic> result =
        jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> movies =
        (result['data'] as Map<String, dynamic>)['movies'] as List<dynamic>;

    final List<Movie> list = <Movie>[];
    for (final dynamic movie in movies) {
      final Map<String, dynamic> item = movie as Map<String, dynamic>;
      list.add(Movie.fromJson(item));
    }
    return list;
  }

  Stream<List<Comment>> listenForComments(int movieId) {
    // final QuerySnapshot<Map<String, dynamic>> snapshot =
    return _firestore
        .collection("comments")
        .where("movieId", isEqualTo: movieId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Comment.fromJson(doc.data())).toList();
    });
  }

  Future<void> createComment(
      {required String uid, required int movieId, required String text}) async {
    final DocumentReference<Map<String, dynamic>> ref =
        _firestore.collection("comments").doc();

    final Comment comment = Comment(
        id: ref.id,
        uid: uid,
        movieId: movieId,
        text: text,
        createdAt: DateTime.now());

    ref.set(comment.toJson());
   
  }
}
