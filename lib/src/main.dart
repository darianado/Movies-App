import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:movies/src/actions/get_current_user.dart';
import 'package:movies/src/actions/get_movies.dart';
import 'package:movies/src/data/auth_api.dart';
import 'package:movies/src/data/movie_api.dart';
import 'package:movies/src/epics/app_epic.dart';
import 'package:movies/src/models/app_state.dart';
import 'package:movies/src/presentation/home.dart';
import 'package:movies/src/presentation/home_page.dart';
import 'package:movies/src/reducer/reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final app = await Firebase.initializeApp();
  final FirebaseAuth auth = FirebaseAuth.instanceFor(app: app);

  final Client client = Client();
  final MovieApi movieApi = MovieApi(client);
  final AuthApi authApi = AuthApi(auth);
  final AppEpic epic = AppEpic(
    movieApi, authApi
  );

  final Store<AppState> store = Store<AppState>(
    reducer,
    initialState: const AppState(),
    middleware: <Middleware<AppState>>[
      EpicMiddleware<AppState>(epic.getEpics()),
    ],
  )..dispatch(const GetCurrentUser());

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
        home: Home(),
      ),
    );
  }
}
