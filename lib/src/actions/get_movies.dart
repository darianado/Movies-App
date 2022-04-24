
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/models/movie.dart';

part 'get_movies.freezed.dart';

@freezed
class GetMovies with _$GetMovies implements AppAction {
  const factory GetMovies(ActionResult onResult) = GetMoviesStart;
  const factory GetMovies.successful(List<Movie> movies) = GetMoviesSuccessful;

  @Implements<ErrorAction>()
  const factory GetMovies.error(Object error, StackTrace stackTrace) = GetMoviesError;
}
