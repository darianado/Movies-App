import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movies/src/actions/get_movies.dart';
import 'package:movies/src/containers/home_page_container.dart';
import 'package:movies/src/containers/movies_container.dart';
import 'package:movies/src/models/app_state.dart';
import 'package:movies/src/models/movie.dart';
import 'package:redux/redux.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
                  store.dispatch(GetMovies());
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

              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (BuildContext context, int index) {
                  final Movie movie = movies[index];
                  return Column(
                    children: <Widget>[
                      Image.network(movie.poster),
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
          ),
        );
      },
    );
  }
}