
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/data/auth_api.dart';
import 'package:movies/src/data/movie_api.dart';
import 'package:movies/src/models/index.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class MovieEpic {
  MovieEpic(this._movieApi);

  final MovieApi _movieApi;

  Epic<AppState> getEpics() {
    return combineEpics(<Epic<AppState>>[
      TypedEpic<AppState, GetMoviesStart>(_getMovies),
    ]);
  }

  Stream<AppAction> _getMovies(Stream<GetMoviesStart> actions, EpicStore<AppState> store) {
    return actions.flatMap((GetMoviesStart action) {
      return Stream<void>.value(null)
          .asyncMap((_) => _movieApi.getMovies(store.state.page))
          .map<GetMovies>($GetMovies.successful)
          .onErrorReturnWith($GetMovies.error)
          .doOnData(action.onResult);
    });
  }

  
}
