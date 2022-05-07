import 'package:movies/src/actions/index.dart';
import 'package:movies/src/models/index.dart';
import 'package:redux/redux.dart';

Reducer<AppState> movieReducer = combineReducers<AppState>(<Reducer<AppState>>[
  TypedReducer<AppState, GetMoviesSuccessful>(_getMoviesSuccessful),
  TypedReducer<AppState, OnCommentsEvent>(_onCommentsEvent),
  TypedReducer<AppState, SetSelectedMovieId>(_setSelectedMovieId),
  // TypedReducer<AppState, GetMoviesGenreSuccessful>(_getMoviesGenreSuccessful),
]);

AppState _getMoviesSuccessful(AppState state, GetMoviesSuccessful action) {
  return state.copyWith(page: state.page + 1, movies: <Movie>[...state.movies, ...action.movies]);
}

// AppState _getMoviesGenreSuccessful(AppState state, GetMoviesGenreSuccessful action) {
//   return state.copyWith(
//       page: state.page + 1, movies: <Movie>[...state.movies, ...action.movies]);
// }

AppState _onCommentsEvent(AppState state, OnCommentsEvent action) {
  return state.copyWith(comments: <Comment>{...state.comments, ...action.comments}.toList());
}

AppState _setSelectedMovieId(AppState state, SetSelectedMovieId action) {
  return state.copyWith(selectedMovieId: action.movieId);
}
