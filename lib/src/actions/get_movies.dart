part of 'index.dart';

const String _kGetMoviesPending = 'GetMovies';
const String _kGetMoviesMorePending = 'GetMoviesMore';

@freezed
class GetMovies with _$GetMovies implements AppAction {
  @Implements<ActionStart>()
  const factory GetMovies.start(
    String? genre,
    ActionResult onResult, {
    @Default(_kGetMoviesPending) String pendingId,
  }) = GetMoviesStart;

  @Implements<ActionStart>()
  const factory GetMovies.more(
    String? genre,
    ActionResult onResult, {
    @Default(_kGetMoviesMorePending) String pendingId,
  }) = GetMoviesMore;

  @Implements<ActionDone>()
  const factory GetMovies.successful(
    List<Movie> movies,
    String pendingId,
  ) = GetMoviesSuccessful;

  @Implements<ActionDone>()
  @Implements<ErrorAction>()
  const factory GetMovies.error(
    Object error,
    StackTrace stackTrace,
    String pendingId,
  ) = GetMoviesError;

  static String get pendingKey => _kGetMoviesPending;
  static String get pendingKeyMore => _kGetMoviesMorePending;
}
