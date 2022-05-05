import 'package:movies/src/actions/index.dart';
import 'package:movies/src/models/index.dart';
import 'package:redux/redux.dart';

Reducer<AppState> movieReducer = combineReducers<AppState>(<Reducer<AppState>>[
  TypedReducer<AppState, GetMoviesSuccessful>(_getMoviesSuccessful),
]);

AppState _getMoviesSuccessful(AppState state, GetMoviesSuccessful action) {
  return state.copyWith( page: state.page + 1, movies: <Movie>[...state.movies, ...action.movies]);
}
