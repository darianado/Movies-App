
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/models/index.dart';
import 'package:movies/src/reducer/auth_reducer.dart';
import 'package:movies/src/reducer/movie_reducer.dart';
import 'package:redux/redux.dart';

AppState reducer(AppState state, dynamic action) {
  if (action is! AppAction) {
    throw ArgumentError("all actions shout implement appaction");
  }
  
  final AppState newState = _reducer(state, action);
  return newState;
}

Reducer<AppState> _reducer = combineReducers<AppState>(<Reducer<AppState>>[
  authReducer, movieReducer,
]);

