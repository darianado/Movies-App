import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/containers/home_page_container.dart';
import 'package:movies/src/containers/movies_container.dart';
import 'package:movies/src/containers/user_container.dart';
import 'package:movies/src/models/index.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    StoreProvider.of<AppState>(context, listen: false)
        .dispatch(GetMovies(_onResult));
  }

  void _onResult(AppAction action) {
    if (action is GetMoviesSuccessful) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("page loaded")));
    } else if (action is GetMoviesError) {
      final Object error = action.error;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    return HomePageContainer(
      builder: (BuildContext context, AppState state) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  store.dispatch(GetMovies(_onResult));
                },
                icon: const Icon(Icons.add),
              )
            ],
            title: Align(
              child: Text('Movies ${state.page}'),
            ),
          ),
          body: MoviesContainer(
            builder: (BuildContext context, List<Movie> movies) {
              if (state.isLoading && movies.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return UserContainer(
                builder: (BuildContext context, AppUser? user) {
                  // ignore: dead_code
                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Movie movie = movies[index];

                      final bool isFavorite =
                          user!.favoriteMovies.contains(movie.id);

                      return Column(
                        children: <Widget>[
                          Stack(children: <Widget>[
                            Image.network(movie.poster),
                            IconButton(
                                color: Colors.red,
                                onPressed: () {
                                  StoreProvider.of<AppState>(context).dispatch(
                                      UpdateFavorites(movie.id,
                                          add: !isFavorite));
                                },
                                icon: Icon(isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border))
                          ]),
                          Center(
                            child: Text(movie.title),
                          ),
                          Center(
                            child: Text(movie.genres.join(', ')),
                          ),
                          Text('${movie.rating}'),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
