import 'package:meta/meta.dart';
import 'package:movies/src/models/movie.dart';

@immutable
class AppState {
  const AppState({
    this.movies = const <Movie>[],
    this.isLoading = true,
    this.page = 1,
  });

  final List<Movie> movies;
  final bool isLoading;
  final int page;

  AppState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    int? page,
  }) {
    return AppState(
      movies: movies != null ? List<Movie>.unmodifiable(movies) : this.movies,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
    );
  }
}
