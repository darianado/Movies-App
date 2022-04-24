
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/data/auth_api.dart';
import 'package:movies/src/data/movie_api.dart';
import 'package:movies/src/epics/auth_epic.dart';
import 'package:movies/src/epics/movie_epic.dart';
import 'package:movies/src/models/index.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class AppEpic {
  AppEpic(this._movieApi, this._authApi);

  final MovieApi _movieApi;
  final AuthApi _authApi;

  Epic<AppState> getEpics() {
    return combineEpics(<Epic<AppState>>[
      AuthEpic(_authApi).getEpics(),
      MovieEpic(_movieApi).getEpics(),
    ]);
  }

}
