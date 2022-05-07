part of 'index.dart';

const String _kGetMoviesGenrePending = 'GetMoviesGenre';
const String _kGetMoviesGenreMorePending = 'GetMoviesGenreMore';

@freezed
class GetMoviesGenre with _$GetMoviesGenre implements AppAction {
  @Implements<ActionStart>()
  const factory GetMoviesGenre.start(
    String genre,
    ActionResult onResult,
    {
    @Default(_kGetMoviesGenrePending) String pendingId,
  }) = GetMoviesGenreStart;

   @Implements<ActionStart>()
  const factory GetMoviesGenre.more(
    ActionResult onResult,
    String genre, {
    @Default(_kGetMoviesGenreMorePending) String pendingId,
  }) = GetMoviesGenreMore;

  @Implements<ActionDone>()
  const factory GetMoviesGenre.successful(
    List<Movie> movies,  String pendingId,) = GetMoviesGenreSuccessful;

  @Implements<ActionDone>()
  @Implements<ErrorAction>()
  const factory GetMoviesGenre.error(
    Object error, 
    StackTrace stackTrace,  String pendingId,) = GetMoviesGenreError;

  static String get pendingKey => _kGetMoviesGenrePending;
  static String get pendingKeyMore => _kGetMoviesGenreMorePending;
}
