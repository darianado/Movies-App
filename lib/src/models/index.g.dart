// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: always_specify_types
// ignore_for_file: implicit_dynamic_parameter

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppState$ _$$AppState$FromJson(Map<String, dynamic> json) => _$AppState$(
      movies: (json['movies'] as List<dynamic>?)?.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList() ??
          const <Movie>[],
      page: json['page'] as int? ?? 0,
      user: json['user'] == null ? null : AppUser.fromJson(json['user'] as Map<String, dynamic>),
      pending: (json['pending'] as List<dynamic>?)?.map((e) => e as String).toSet() ?? const <String>{},
      comments:
          (json['comments'] as List<dynamic>?)?.map((e) => Comment.fromJson(e as Map<String, dynamic>)).toList() ??
              const <Comment>[],
      selectedMovieId: json['selectedMovieId'] as int?,
      users: (json['users'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, AppUser.fromJson(e as Map<String, dynamic>)),
          ) ??
          const <String, AppUser>{},
    );

Map<String, dynamic> _$$AppState$ToJson(_$AppState$ instance) => <String, dynamic>{
      'movies': instance.movies,
      'page': instance.page,
      'user': instance.user,
      'pending': instance.pending.toList(),
      'comments': instance.comments,
      'selectedMovieId': instance.selectedMovieId,
      'users': instance.users,
    };

_$AppUser$ _$$AppUser$FromJson(Map<String, dynamic> json) => _$AppUser$(
      email: json['email'] as String,
      uid: json['uid'] as String,
      username: json['username'] as String,
      favoriteMovies: (json['favoriteMovies'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const <int>[],
    );

Map<String, dynamic> _$$AppUser$ToJson(_$AppUser$ instance) => <String, dynamic>{
      'email': instance.email,
      'uid': instance.uid,
      'username': instance.username,
      'favoriteMovies': instance.favoriteMovies,
    };

_$Movie$ _$$Movie$FromJson(Map<String, dynamic> json) => _$Movie$(
      id: json['id'] as int,
      title: json['title'] as String,
      year: json['year'] as int,
      rating: (json['rating'] as num).toDouble(),
      genres: (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      summary: json['summary'] as String,
      poster: json['medium_cover_image'] as String,
    );

Map<String, dynamic> _$$Movie$ToJson(_$Movie$ instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'year': instance.year,
      'rating': instance.rating,
      'genres': instance.genres,
      'summary': instance.summary,
      'medium_cover_image': instance.poster,
    };

_$Comment$ _$$Comment$FromJson(Map<String, dynamic> json) => _$Comment$(
      id: json['id'] as String,
      uid: json['uid'] as String,
      movieId: json['movieId'] as int,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$Comment$ToJson(_$Comment$ instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'movieId': instance.movieId,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
    };
