import 'package:movies/src/actions/get_movies.dart';
import 'package:movies/src/data/movie_api.dart';
import 'package:movies/src/models/app_state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class AppEpic {
  AppEpic(this._movieApi);

  final MovieApi _movieApi;

  Epic<AppState> getEpics() {
    return combineEpics(<Epic<AppState>>[
      TypedEpic<AppState, GetMovies>(_getMovies),
    ]);
  }

  Stream<dynamic> _getMovies(
      Stream<GetMovies> actions, EpicStore<AppState> store) {
    return actions
        .asyncMap(
            (GetMovies action) => _movieApi.getMovies(store.state.page))
        .map<dynamic>(GetMoviesSuccessful.new)
        .onErrorReturnWith(
            (Object error, StackTrace stackTrace) => GetMoviesError(error));
  }
}