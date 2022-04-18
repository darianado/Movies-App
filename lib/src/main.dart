import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:movies/src/actions/get_movies.dart';
import 'package:movies/src/data/movie_api.dart';
import 'package:movies/src/epics/app_epic.dart';
import 'package:movies/src/models/app_state.dart';
import 'package:movies/src/presentation/home_page.dart';
import 'package:movies/src/reducer/reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

void main() {
  final Client client = Client();
  final MovieApi movieApi = MovieApi(client);

  final AppEpic epic = AppEpic(movieApi);

  final Store<AppState> store = Store<AppState>(
    reducer,
    initialState: const AppState(),
    middleware: <Middleware<AppState>>[
      EpicMiddleware<AppState>(epic.getEpics()),
    ],
  )..dispatch(GetMovies());

  runApp(App(store: store));
}

class App extends StatelessWidget {
  const App({Key? key, required this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: const MaterialApp(
        title: 'Movie App',
        home: HomePage(),
      ),
    );
  }
}
